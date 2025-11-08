# Build and deploy TravelSathi to Minikube
# Run from d:\TRAVEL_BOOKING_PLATFORM-main

Write-Host "Step 1: Configure Docker to use Minikube daemon" -ForegroundColor Cyan
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

Write-Host "`nStep 2: Build backend image" -ForegroundColor Cyan
docker build -f TravelSathi\Dockerfile.optimized -t travelsathi/backend:latest TravelSathi

Write-Host "`nStep 3: Build frontend image" -ForegroundColor Cyan
docker build -t travelsathi/frontend:latest travelsathi-frontend

Write-Host "`nStep 4: Verify images" -ForegroundColor Cyan
docker images | Select-String "travelsathi"

Write-Host "`nStep 5: Apply Kubernetes manifests" -ForegroundColor Cyan
kubectl apply -f ..\Sample-Ansible-Playbook-template-master\k8s\travelsathi.yaml

Write-Host "`nStep 6: Wait for pods" -ForegroundColor Cyan
Start-Sleep -Seconds 10
kubectl get pods -n travelsathi

Write-Host "`nStep 7: Get service URLs" -ForegroundColor Cyan
Write-Host "Frontend: " -NoNewline -ForegroundColor Yellow
minikube service frontend -n travelsathi --url
Write-Host "Backend:  " -NoNewline -ForegroundColor Yellow
minikube service backend -n travelsathi --url
