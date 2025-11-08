# Build and Deploy Frontend to GitHub Pages
# Run this script to build your frontend for GitHub Pages

Write-Host "Building TravelSathi Frontend for GitHub Pages..." -ForegroundColor Cyan

# Navigate to frontend directory
Set-Location -Path "$PSScriptRoot\travelsathi-frontend"

# Install dependencies if needed
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
}

# Build the application
Write-Host "Building production bundle..." -ForegroundColor Yellow
npm run build

Write-Host "`n✅ Build complete! Files are in the 'dist' folder." -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Commit and push these changes to GitHub" -ForegroundColor White
Write-Host "2. Go to your GitHub repository settings" -ForegroundColor White
Write-Host "3. Navigate to Pages section" -ForegroundColor White
Write-Host "4. Select 'GitHub Actions' as the source" -ForegroundColor White
Write-Host "5. The workflow will automatically deploy your site`n" -ForegroundColor White

# Return to root directory
Set-Location -Path $PSScriptRoot
