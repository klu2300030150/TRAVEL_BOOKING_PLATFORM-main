<#
Deploy or update TravelSathi stack (backend + frontend) to Minikube/Kubernetes with parameterized images and API URL.
Requires: minikube, kubectl, docker

Usage examples:
  .\k8s-deploy.ps1 -FrontendApiUrl "http://backend.travelsathi.svc.cluster.local:9000"
  .\k8s-deploy.ps1 -Tag v1 -Rebuild
#>
param(
  [string]$Profile = 'minikube',
  [string]$Tag = 'latest',
  [string]$FrontendApiUrl = 'http://backend.travelsathi.svc.cluster.local:9000',
  [switch]$Rebuild,
  [switch]$SkipFrontend,
  [switch]$SkipBackend
)

$ErrorActionPreference = 'Stop'

Write-Host "[1/6] Ensuring Minikube running (profile $Profile)" -ForegroundColor Cyan
minikube status -p $Profile 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { minikube start -p $Profile --driver=docker | Out-Host }

Write-Host "[2/6] Point Docker to Minikube daemon" -ForegroundColor Cyan
minikube -p $Profile docker-env --shell powershell | Invoke-Expression

if ($Rebuild -and -not $SkipBackend) {
  Write-Host "Building backend image travelsathi/backend:$Tag" -ForegroundColor Yellow
  docker build -t travelsathi/backend:$Tag "$PSScriptRoot/TravelSathi" | Out-Host
}
if ($Rebuild -and -not $SkipFrontend) {
  Write-Host "Building frontend image travelsathi/frontend:$Tag (API=$FrontendApiUrl)" -ForegroundColor Yellow
  docker build --build-arg VITE_API_BASE_URL=$FrontendApiUrl -t travelsathi/frontend:$Tag "$PSScriptRoot/travelsathi-frontend" | Out-Host
}

Write-Host "[3/6] Applying manifest template with tag '$Tag'" -ForegroundColor Cyan
$manifestPath = "$PSScriptRoot/../Sample-Ansible-Playbook-template-master/k8s/travelsathi.yaml"
if (-not (Test-Path $manifestPath)) { throw "Manifest not found: $manifestPath" }

$raw = Get-Content $manifestPath -Raw
$patched = $raw -replace 'travelsathi/backend:latest', "travelsathi/backend:$Tag" -replace 'travelsathi/frontend:latest', "travelsathi/frontend:$Tag" -replace 'VITE_API_BASE_URL: \"http://backend.travelsathi.svc.cluster.local:9000\"', "VITE_API_BASE_URL: \"$FrontendApiUrl\""
$tmp = New-TemporaryFile
Set-Content $tmp $patched
kubectl apply -f $tmp | Out-Host
Remove-Item $tmp -Force

Write-Host "[4/6] Waiting for deployments" -ForegroundColor Cyan
kubectl wait --for=condition=available deployment/backend -n travelsathi --timeout=180s | Out-Host
kubectl wait --for=condition=available deployment/frontend -n travelsathi --timeout=180s | Out-Host

Write-Host "[5/6] Service URLs" -ForegroundColor Cyan
$fUrl = minikube service frontend -n travelsathi --url
$bUrl = minikube service backend -n travelsathi --url
Write-Host "Frontend: $fUrl" -ForegroundColor Green
Write-Host "Backend : $bUrl" -ForegroundColor Green

Write-Host "[6/6] Done. To rebuild with new code: .\k8s-deploy.ps1 -Rebuild -Tag v2" -ForegroundColor Cyan
