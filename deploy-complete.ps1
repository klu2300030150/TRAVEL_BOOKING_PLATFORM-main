# Complete Automated Deployment Script for TravelSathi
# Deploys backend to Railway and updates frontend with backend URL

param(
    [string]$RailwayBackendUrl = "",
    [switch]$SkipBackend,
    [switch]$SkipFrontend,
    [switch]$ProvisionRailway,
    [string]$RailwayToken = ""
)

$ErrorActionPreference = "Stop"
$gitPath = 'C:\Users\sreek\AppData\Local\GitHubDesktop\app-3.5.4\resources\app\git\cmd'
$env:PATH = "$gitPath;$env:PATH"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  TravelSathi Automated Deployment" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check prerequisites
Write-Host "[1/8] Checking prerequisites..." -ForegroundColor Yellow
$hasNode = Get-Command node -ErrorAction SilentlyContinue
$hasGit = Get-Command git -ErrorAction SilentlyContinue
$hasNpm = Test-Path "C:\Program Files\nodejs\node.exe"

if (-not $hasGit) {
    Write-Host "❌ Git not found!" -ForegroundColor Red
    exit 1
}
if (-not $hasNpm) {
    Write-Host "❌ Node.js not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Prerequisites OK" -ForegroundColor Green

# Backend to Railway
if (-not $SkipBackend) {
    Write-Host "`n[2/8] Preparing backend for Railway..." -ForegroundColor Yellow
    
    if ($ProvisionRailway -and [string]::IsNullOrWhiteSpace($RailwayToken)) {
        Write-Host "`n⚠️  Provisioning requested but no Railway token provided." -ForegroundColor Yellow
        Write-Host "Create a token at https://railway.app/account/tokens and pass -RailwayToken '...'." -ForegroundColor White
    }

    if ($ProvisionRailway) {
        Write-Host "Running Railway provisioning helper..." -ForegroundColor Yellow
        & "$PSScriptRoot\provision-railway.ps1" -RailwayToken $RailwayToken
    }

    if ($RailwayBackendUrl -eq "") {
        Write-Host "`n⚠️  Backend URL not provided!" -ForegroundColor Yellow
        Write-Host "Please deploy your backend to Railway first:" -ForegroundColor White
        Write-Host "1. Go to https://railway.app/new" -ForegroundColor White
        Write-Host "2. Click 'Deploy from GitHub repo'" -ForegroundColor White
        Write-Host "3. Select: TRAVEL_BOOKING_PLATFORM-main" -ForegroundColor White
        Write-Host "4. Set Root Directory to: TravelSathi" -ForegroundColor White
        Write-Host "5. Add MySQL database" -ForegroundColor White
        Write-Host "6. Copy your Railway URL (e.g., https://yourapp.up.railway.app)" -ForegroundColor White
        Write-Host "`nThen run this script again with your URL:" -ForegroundColor Cyan
        Write-Host "  .\deploy-complete.ps1 -RailwayBackendUrl 'https://yourapp.up.railway.app'`n" -ForegroundColor Cyan
        
        # Open Railway for user
        Start-Process "https://railway.app/new"
        exit 0
    }
    
    Write-Host "✅ Using backend URL: $RailwayBackendUrl" -ForegroundColor Green

    # Optionally set GitHub secret BACKEND_URL if gh CLI is available
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        try {
            Write-Host "Setting GitHub secret BACKEND_URL via gh CLI..." -ForegroundColor Yellow
            echo $RailwayBackendUrl | gh secret set BACKEND_URL --repo "klu2300030150/TRAVEL_BOOKING_PLATFORM-main" | Out-Null
            Write-Host "✅ GitHub secret BACKEND_URL updated" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Failed to set GitHub secret automatically. Set it manually in repo Settings > Secrets > Actions as BACKEND_URL=$RailwayBackendUrl" -ForegroundColor Yellow
        }
    } else {
        Write-Host "ℹ️  gh CLI not found. Set GitHub secret BACKEND_URL manually to: $RailwayBackendUrl" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n[2/8] Skipping backend deployment (use -SkipBackend flag)" -ForegroundColor Gray
}

# Update frontend API configuration
if (-not $SkipFrontend) {
    Write-Host "`n[3/8] Creating frontend environment configuration..." -ForegroundColor Yellow
    
    $envContent = "VITE_API_BASE_URL=$RailwayBackendUrl"
    Set-Content -Path "travelsathi-frontend\.env" -Value $envContent
    Write-Host "✅ Created .env with API URL" -ForegroundColor Green
    
    # Update Login.jsx to use environment variable
    Write-Host "`n[4/8] Updating frontend API calls..." -ForegroundColor Yellow
    
    $loginFile = "travelsathi-frontend\src\pages\Login.jsx"
    if (Test-Path $loginFile) {
        $content = Get-Content $loginFile -Raw
        $updated = $content -replace "http://localhost:9000", "`${import.meta.env.VITE_API_BASE_URL || 'http://localhost:9000'}"
        Set-Content -Path $loginFile -Value $updated
        Write-Host "✅ Updated Login.jsx" -ForegroundColor Green
    }
    
    # Update Register.jsx
    $registerFile = "travelsathi-frontend\src\pages\Register.jsx"
    if (Test-Path $registerFile) {
        $content = Get-Content $registerFile -Raw
        $updated = $content -replace "http://localhost:9000", "`${import.meta.env.VITE_API_BASE_URL || 'http://localhost:9000'}"
        Set-Content -Path $registerFile -Value $updated
        Write-Host "✅ Updated Register.jsx" -ForegroundColor Green
    }
    
    Write-Host "`n[5/8] Building frontend..." -ForegroundColor Yellow
    Set-Location -Path "travelsathi-frontend"
    
    # Build frontend
    & "C:\Program Files\nodejs\node.exe" "C:\Program Files\nodejs\node_modules\npm\bin\npm-cli.js" run build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Frontend build failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Frontend built successfully" -ForegroundColor Green
    
    Set-Location -Path ".."
    
    Write-Host "`n[6/8] Committing changes..." -ForegroundColor Yellow
    git add .
    git commit -m "Deploy: Update frontend with Railway backend URL and rebuild"
    Write-Host "✅ Changes committed" -ForegroundColor Green
    
    Write-Host "`n[7/8] Pushing to GitHub..." -ForegroundColor Yellow
    git push origin main
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Git push failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Pushed to GitHub" -ForegroundColor Green
    
} else {
    Write-Host "`n[3-7/8] Skipping frontend update (use -SkipFrontend flag)" -ForegroundColor Gray
}

Write-Host "`n[8/8] Deployment Summary" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

if ($RailwayBackendUrl -ne "") {
    Write-Host "🚀 Backend URL: $RailwayBackendUrl" -ForegroundColor Green
    Write-Host "🌐 Frontend URL: https://klu2300030150.github.io/TRAVEL_BOOKING_PLATFORM-main/" -ForegroundColor Green
    Write-Host "`n✅ Deployment complete!" -ForegroundColor Green
    Write-Host "`nGitHub Actions will deploy your frontend in 2-3 minutes." -ForegroundColor White
    Write-Host "Monitor deployment: https://github.com/klu2300030150/TRAVEL_BOOKING_PLATFORM-main/actions" -ForegroundColor Cyan
    
    # Open URLs
    Start-Process "https://github.com/klu2300030150/TRAVEL_BOOKING_PLATFORM-main/actions"
    Start-Sleep -Seconds 2
    Start-Process "https://klu2300030150.github.io/TRAVEL_BOOKING_PLATFORM-main/"
} else {
    Write-Host "`n⚠️  Deploy backend to Railway first, then run:" -ForegroundColor Yellow
    Write-Host "  .\deploy-complete.ps1 -RailwayBackendUrl 'https://your-railway-url.up.railway.app'`n" -ForegroundColor Cyan
}

Write-Host "========================================`n" -ForegroundColor Cyan
