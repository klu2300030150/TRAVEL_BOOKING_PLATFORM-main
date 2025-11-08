# GitHub Pages Deployment Guide

## Current Issue
Your GitHub Pages site is showing README text instead of the frontend application because the React app needs to be built first.

## Solution: Deploy Frontend to GitHub Pages

### Prerequisites
1. **Install Node.js** (Required for building the React app)
   - Download from: https://nodejs.org/
   - Install the LTS version (recommended)
   - Restart your terminal after installation

### Option 1: Automatic Deployment with GitHub Actions (Recommended)

I've already created the workflow file. Follow these steps:

1. **Enable GitHub Pages with Actions**
   - Go to: https://github.com/klu2300030150/TRAVEL_BOOKING_PLATFORM-main/settings/pages
   - Under "Build and deployment"
   - Source: Select **"GitHub Actions"**
   - Click Save

2. **Commit and Push the new files**
   - Open GitHub Desktop
   - You should see new files:
     - `.github/workflows/deploy.yml`
     - `travelsathi-frontend/vite.config.js` (modified)
     - `index.html` (root level)
     - `build-frontend.ps1`
   - Commit message: "Add GitHub Pages deployment workflow"
   - Click "Commit to main"
   - Click "Push origin"

3. **Wait for Deployment**
   - Go to: https://github.com/klu2300030150/TRAVEL_BOOKING_PLATFORM-main/actions
   - Watch the "Deploy to GitHub Pages" workflow run
   - Takes about 2-3 minutes
   - Once complete, visit: https://klu2300030150.github.io/TRAVEL_BOOKING_PLATFORM-main/

### Option 2: Manual Build and Deploy

If GitHub Actions doesn't work, follow these steps:

1. **Install Node.js** (if not already installed)
   - https://nodejs.org/

2. **Build the Frontend**
   ```powershell
   cd d:\TRAVEL_BOOKING_PLATFORM-main\travelsathi-frontend
   npm install
   npm run build
   ```

3. **Copy Build Files**
   - The build creates files in `d:\TRAVEL_BOOKING_PLATFORM-main\dist`
   - Move all files from `dist` to the root of your repository

4. **Push to GitHub**
   - Commit all files in GitHub Desktop
   - Push to main branch

5. **Configure GitHub Pages**
   - Go to repository Settings → Pages
   - Source: Deploy from a branch
   - Branch: main / (root)
   - Click Save

### Important Notes

⚠️ **Backend API Issue**
Your frontend makes API calls to `http://localhost:9000`. On GitHub Pages, this won't work because:
- GitHub Pages only hosts static files (HTML/CSS/JS)
- No backend server is running
- API calls to localhost will fail

**Solutions:**
1. **For Demo Purpose**: Mock the API calls or use a demo mode
2. **For Production**: Deploy backend to:
   - Heroku
   - AWS/Azure/GCP
   - Render.com
   - Railway.app
   Then update API base URL in your frontend

### Files Created

✅ `.github/workflows/deploy.yml` - GitHub Actions workflow for auto-deployment
✅ `travelsathi-frontend/vite.config.js` - Updated with GitHub Pages base path
✅ `index.html` - Landing page while app loads
✅ `build-frontend.ps1` - Script to build frontend locally
✅ `GITHUB_PAGES_GUIDE.md` - This guide

### Troubleshooting

**Problem**: Page shows README text
**Solution**: Follow Option 1 above to enable GitHub Actions

**Problem**: 404 errors on routes
**Solution**: Already configured in vite.config.js with proper base path

**Problem**: API calls fail
**Solution**: Backend needs to be deployed separately (see Backend API Issue above)

### Next Steps After Deployment

1. Test your site: https://klu2300030150.github.io/TRAVEL_BOOKING_PLATFORM-main/
2. If you want to deploy backend, let me know and I can help set that up
3. Consider adding environment variables for API endpoints
