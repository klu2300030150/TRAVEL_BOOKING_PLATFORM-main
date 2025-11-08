# TravelSathi - Complete Automated Deployment Guide

## 🚀 One-Command Deployment

This project is fully automated! Just follow these simple steps:

### Step 1: Deploy Backend to Railway (5 minutes)

1. **The automation script will open Railway for you:**
   ```powershell
   cd d:\TRAVEL_BOOKING_PLATFORM-main
   .\deploy-complete.ps1
   ```

2. **In Railway website:**
   - Click **"Deploy from GitHub repo"**
   - Select: `TRAVEL_BOOKING_PLATFORM-main`
   - Wait for detection...
   - Click on your service → **Settings**
   - Set **Root Directory**: `TravelSathi`
   - Click **"+ New"** → **"Database"** → **"Add MySQL"**
   - Wait 2-3 minutes for deployment
   - Click **"Settings"** → **"Networking"** → **"Generate Domain"**
   - Copy your URL (like `https://travelsathi-production-xxxx.up.railway.app`)

### Step 2: Complete Automated Deployment (1 command)

Once you have your Railway URL, run:

```powershell
.\deploy-complete.ps1 -RailwayBackendUrl "https://your-railway-url.up.railway.app"
```

**This single command will:**
- ✅ Create `.env` file with your backend URL
- ✅ Update all frontend API calls automatically
- ✅ Build production frontend
- ✅ Commit and push to GitHub
- ✅ Trigger GitHub Pages deployment
- ✅ Open deployment status and your live site

### Step 3: Wait 2-3 Minutes

GitHub Actions will automatically deploy your frontend to:
**https://klu2300030150.github.io/TRAVEL_BOOKING_PLATFORM-main/**

## 📋 What's Automated

### Backend Configuration ✅
- MySQL database connection (Railway auto-injects `DATABASE_URL`)
- CORS configured for GitHub Pages
- Port configuration (`$PORT` from Railway)
- Dockerfile and build configs
- Database tables auto-created on first run

### Frontend Configuration ✅
- Environment variables (`.env` with `VITE_API_BASE_URL`)
- API service with centralized configuration
- Production build optimized for GitHub Pages
- Router configured with correct basename
- GitHub Actions workflow for auto-deployment

### Git & Deployment ✅
- Automatic commit and push
- Railway config files (`railway.toml`, `Procfile`, etc.)
- GitHub Pages workflow
- Build optimization

## 🎯 Quick Commands Reference

### Full Automated Deployment
```powershell
.\deploy-complete.ps1 -RailwayBackendUrl "https://your-app.up.railway.app"
```

### Skip Backend (if already deployed)
```powershell
.\deploy-complete.ps1 -RailwayBackendUrl "https://your-app.up.railway.app" -SkipBackend
```

### Only Deploy Frontend
```powershell
.\deploy-complete.ps1 -RailwayBackendUrl "https://your-app.up.railway.app" -SkipBackend
```

### Build Frontend Locally
```powershell
.\build-frontend.ps1
```

### Deploy Backend to Minikube (Local)
```powershell
.\deploy-minikube.ps1
```

## 🔧 Manual Override

If you prefer manual control:

**Backend:**
```powershell
# Push to GitHub (Railway auto-deploys)
git add .
git commit -m "Update backend"
git push origin main
```

**Frontend:**
```powershell
# Create .env
echo "VITE_API_BASE_URL=https://your-backend.up.railway.app" > travelsathi-frontend\.env

# Build
cd travelsathi-frontend
npm run build

# Deploy
cd ..
git add .
git commit -m "Update frontend"
git push origin main
```

## 📊 Monitoring

### Railway Backend
- Dashboard: https://railway.app/dashboard
- Logs: Click service → "Deployments" → Latest → "View Logs"
- Metrics: CPU, Memory, Network usage available

### GitHub Pages Frontend
- Actions: https://github.com/klu2300030150/TRAVEL_BOOKING_PLATFORM-main/actions
- Pages: https://klu2300030150.github.io/TRAVEL_BOOKING_PLATFORM-main/

### Local Minikube
```powershell
kubectl get pods -n travelsathi
kubectl logs -f <pod-name> -n travelsathi
minikube service frontend -n travelsathi --url
```

## 🐛 Troubleshooting

If automation fails, check:

1. **Prerequisites:**
   - Git installed and in PATH
   - Node.js installed
   - Railway account created

2. **Railway Issues:**
   - Root Directory set to `TravelSathi`
   - MySQL database added
   - Domain generated

3. **Frontend Issues:**
   - Check `TROUBLESHOOTING.md`
   - View GitHub Actions logs
   - Check browser console (F12)

## 📁 Project Structure

```
TRAVEL_BOOKING_PLATFORM-main/
├── deploy-complete.ps1          # ⭐ MAIN AUTOMATION SCRIPT
├── deploy-minikube.ps1          # Local Kubernetes deployment
├── build-frontend.ps1           # Frontend build only
├── TravelSathi/                 # Backend (Spring Boot)
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
├── travelsathi-frontend/        # Frontend (React + Vite)
│   ├── .env                     # Auto-generated with backend URL
│   ├── src/
│   │   └── services/
│   │       └── api.js          # Centralized API configuration
│   └── package.json
├── .github/workflows/
│   └── deploy.yml              # Auto-deploy to GitHub Pages
├── railway.toml                # Railway configuration
├── Procfile                    # Railway start command
└── TROUBLESHOOTING.md         # Detailed troubleshooting guide
```

## 🎉 Success Criteria

Your deployment is successful when:

1. ✅ Railway shows "Deployed" status
2. ✅ Backend URL responds (test: `https://your-backend.up.railway.app/api/user/test`)
3. ✅ GitHub Actions workflow completes (green checkmark)
4. ✅ Frontend loads at GitHub Pages URL
5. ✅ Can login/register through frontend
6. ✅ No CORS errors in browser console

## 💡 Tips

- **First deployment takes longer** (~5-10 minutes for Railway build)
- **Subsequent deployments are faster** (~2-3 minutes)
- **Railway free tier** gives $5 credit/month (sufficient for testing)
- **GitHub Pages** is completely free for public repos
- **Keep Railway URL handy** - you'll need it to re-run automation if you make changes

## 📞 Need Help?

1. Check `TROUBLESHOOTING.md` for common issues
2. View Railway logs for backend errors
3. Check GitHub Actions logs for frontend build errors
4. Inspect browser console (F12) for runtime errors

---

**Ready? Run the automation!** 🚀

```powershell
.\deploy-complete.ps1
```
