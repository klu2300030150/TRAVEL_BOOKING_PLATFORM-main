param(
  [string]$ProjectName = "TravelSathi",
  [string]$ServiceName = "backend",
  [string]$DbPlugin = "mysql",
  [string]$RailwayToken = ""
)

$ErrorActionPreference = "Stop"

Write-Host "Provisioning Railway project/services..." -ForegroundColor Cyan

# Ensure Node is installed
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host "Node.js is required to install the Railway CLI. Please install Node.js first." -ForegroundColor Red
  exit 1
}

# Install Railway CLI if missing
if (-not (Get-Command railway -ErrorAction SilentlyContinue)) {
  Write-Host "Installing Railway CLI..." -ForegroundColor Yellow
  npm install -g @railway/cli | Out-Null
}

if (-not (Get-Command railway -ErrorAction SilentlyContinue)) {
  Write-Host "Failed to install Railway CLI. Install manually from https://railway.app/cli" -ForegroundColor Red
  exit 1
}

if ([string]::IsNullOrWhiteSpace($RailwayToken)) {
  Write-Host "No Railway token provided. Opening browser login..." -ForegroundColor Yellow
  Start-Process "https://railway.app/account/tokens"
  Write-Host "Create a token, then re-run: .\provision-railway.ps1 -RailwayToken 'YOUR_TOKEN'" -ForegroundColor Cyan
  exit 0
}

Write-Host "Logging in to Railway..." -ForegroundColor Yellow
railway login --token $RailwayToken | Out-Null

Write-Host "Creating/Selecting project '$ProjectName'..." -ForegroundColor Yellow
railway projects | Out-Null
railway use --project $ProjectName --create | Out-Null

Write-Host "Creating/Selecting service '$ServiceName' (backend)..." -ForegroundColor Yellow
railway service $ServiceName --create | Out-Null

Write-Host "Adding database plugin: $DbPlugin" -ForegroundColor Yellow
railway add --plugin $DbPlugin | Out-Null

Write-Host "Setting environment variables..." -ForegroundColor Yellow
railway variables set PORT=9000 | Out-Null
railway variables set SHOW_SQL=false | Out-Null

# Convert connection URL to JDBC if available
$conn = (railway variables get DATABASE_URL 2>$null)
if ($conn -and $conn.StartsWith('mysql://')) {
  $jdbc = $conn -replace '^mysql://', 'jdbc:mysql://'
  railway variables set DATABASE_URL=$jdbc | Out-Null
}

Write-Host "Triggering deploy from current repo..." -ForegroundColor Yellow
railway up --service $ServiceName --detach | Out-Null

Write-Host "\n✅ Railway provisioning complete." -ForegroundColor Green
Write-Host "If needed, set BACKEND_URL secret in GitHub to the Railway service URL for frontend builds." -ForegroundColor Cyan
