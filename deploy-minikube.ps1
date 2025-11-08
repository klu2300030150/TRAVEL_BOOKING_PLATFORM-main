<#
Deploy TravelSathi stack to Minikube.
Prereqs: Minikube installed, kubectl available, Docker accessible.
Run from any PowerShell prompt:  .\deploy-minikube.ps1
#>
param(
    [int]$Cpu = 2,
    [int]$MemoryMB = 3500,
    [string]$Profile = 'minikube'
)

Write-Host "[1/7] Starting Minikube (CPUs=$Cpu Memory=${MemoryMB}MB)" -ForegroundColor Cyan
minikube start --driver=docker --cpus=$Cpu --memory=$MemoryMB --profile $Profile | Out-Host

Write-Host "[2/7] Pointing Docker CLI to Minikube's Docker daemon" -ForegroundColor Cyan
# Load docker env into current session
minikube -p $Profile docker-env --shell powershell | Invoke-Expression

Write-Host "[3/7] Building backend image travelsathi/backend:latest" -ForegroundColor Cyan
docker build -t travelsathi/backend:latest "$PSScriptRoot\TravelSathi" | Out-Host

Write-Host "[4/7] Building frontend image travelsathi/frontend:latest" -ForegroundColor Cyan
docker build -t travelsathi/frontend:latest "$PSScriptRoot\travelsathi-frontend" | Out-Host

Write-Host "[5/7] Applying Kubernetes manifests" -ForegroundColor Cyan
kubectl apply -f "${PSScriptRoot}\..\Sample-Ansible-Playbook-template-master\k8s\travelsathi.yaml" | Out-Host

Write-Host "[6/7] Waiting for deployments to become available" -ForegroundColor Cyan
kubectl wait --for=condition=available deployment/backend -n travelsathi --timeout=180s | Out-Host
kubectl wait --for=condition=available deployment/frontend -n travelsathi --timeout=180s | Out-Host

Write-Host "[7/7] Fetching service URLs" -ForegroundColor Cyan
$frontendUrl = minikube service frontend -n travelsathi --url
$backendUrl  = minikube service backend -n travelsathi --url
Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Green
Write-Host "Backend URL:  $backendUrl" -ForegroundColor Green

Write-Host "Done. If frontend can't reach backend, ensure it uses import.meta.env.VITE_API_BASE_URL in API calls." -ForegroundColor Yellow
