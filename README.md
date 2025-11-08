# CI-CD-Devops_InSem-2

## TravelSathi - Travel Booking Platform

A full-stack travel booking application with Spring Boot backend and React frontend, deployed on Kubernetes (Minikube).

### Architecture
- **Backend**: Spring Boot (Java 17) on port 9000
- **Frontend**: React + Vite with Nginx on port 80
- **Database**: MySQL 8.0 with persistent storage
- **Deployment**: Kubernetes manifests for Minikube

### Quick Start

#### Prerequisites
- Docker Desktop
- Minikube
- kubectl

#### Build and Deploy
```powershell
# Navigate to project
cd d:\TRAVEL_BOOKING_PLATFORM-main

# Point Docker to Minikube daemon
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Build images
docker build -f TravelSathi\Dockerfile.optimized -t travelsathi/backend:latest TravelSathi
docker build -t travelsathi/frontend:latest travelsathi-frontend

# Deploy to Kubernetes
kubectl apply -f ..\Sample-Ansible-Playbook-template-master\k8s\travelsathi.yaml

# Get service URLs
minikube service frontend -n travelsathi --url
minikube service backend -n travelsathi --url
```

### Project Structure
```
TRAVEL_BOOKING_PLATFORM-main/
├── TravelSathi/              # Spring Boot backend
│   ├── src/
│   ├── Dockerfile
│   └── pom.xml
├── travelsathi-frontend/     # React frontend
│   ├── src/
│   ├── Dockerfile
│   └── package.json
└── deploy-minikube.ps1       # Automated deployment script
```

### Services
- Frontend: http://127.0.0.1:65301 (NodePort 30080)
- Backend: http://127.0.0.1:xxxxx (NodePort 30090)
- MySQL: ClusterIP (internal only)

### Kubernetes Resources
- Namespace: `travelsathi`
- Deployments: backend (2 replicas), frontend (2 replicas), mysql (1 replica)
- Services: backend (NodePort), frontend (NodePort), mysql (ClusterIP)
- PVC: mysql-pvc (5Gi, standard storage class)
- Secret: mysql-secret (database credentials)

### Development
See individual component READMEs:
- [Backend Documentation](./TravelSathi/README.md)
- [Frontend Documentation](./travelsathi-frontend/README.md)
