# Railway Backend Deployment - Troubleshooting White Page

## Issue: Frontend shows white page after deploying backend to Railway

### Checklist for Railway Deployment

#### 1. Verify Backend is Running
- Go to Railway dashboard: https://railway.app/project
- Check your backend service logs
- Look for: `Started TravelSathiApplication`
- Note your Railway URL: `https://your-app.up.railway.app`

#### 2. Test Backend API Directly
Open in browser: `https://your-railway-url.up.railway.app/api/user/test`

If you see an error or nothing, backend isn't deployed correctly.

#### 3. Check Railway Service Settings

**Root Directory**:
- Settings → Service
- Root Directory should be: `TravelSathi`
- If not set, Railway builds from wrong folder

**Start Command** (should be auto-detected from Procfile):
```
cd TravelSathi && java -Dserver.port=$PORT -jar target/*.jar
```

**Environment Variables**:
Railway should automatically have:
- `DATABASE_URL` - MySQL connection string
- `PORT` - Port number (usually 8080 or random)
- `MYSQL_URL`, `MYSQL_USER`, `MYSQL_PASSWORD`, etc.

#### 4. Check Build Logs
Click on "Deployments" → Latest deployment → "View Logs"

Look for errors like:
- ❌ `BUILD FAILED` - Maven build issue
- ❌ `Connection refused` - Database not connected
- ❌ `Address already in use` - Port conflict
- ✅ `BUILD SUCCESS` - Build worked!
- ✅ `Started TravelSathiApplication` - App started!

#### 5. Common Fixes

**Problem: Build fails with "mvn: command not found"**
Solution: Railway should auto-detect Java/Maven. If not:
- Delete `railway.toml` and `nixpacks.toml`
- Let Railway auto-detect
- Or ensure Java 17 is specified

**Problem: "Connection to database refused"**
Solution:
- Make sure MySQL service is added to your project
- Check that MySQL and backend are in the same Railway project
- Railway automatically injects `DATABASE_URL`

**Problem: "Port 9000 is already in use"**
Solution: Application uses `$PORT` from Railway (check application.properties)

**Problem: Frontend can't reach backend (CORS error)**
Solution: CORS is configured in `WebConfig.java` to allow GitHub Pages
- Check browser console for CORS errors
- Verify your GitHub Pages URL is in allowed origins

#### 6. Update Frontend with Backend URL

Once backend is deployed and working, update your frontend:

**Option 1: Environment Variable (Recommended)**
Create `.env` in `travelsathi-frontend/`:
```env
VITE_API_BASE_URL=https://your-railway-app.up.railway.app
```

**Option 2: Direct Update**
Update API calls in your frontend code from:
```javascript
const response = await axios.post('http://localhost:9000/api/user/login', ...)
```
To:
```javascript
const response = await axios.post('https://your-railway-app.up.railway.app/api/user/login', ...)
```

#### 7. Rebuild and Redeploy Frontend

After updating API URL:
```powershell
cd d:\TRAVEL_BOOKING_PLATFORM-main\travelsathi-frontend
npm run build
cd ..
git add .
git commit -m "Update API URL to Railway backend"
git push origin main
```

GitHub Actions will automatically redeploy your frontend.

### Quick Deploy Commands

If Railway deployment fails, try this:

1. **Remove config files and let Railway auto-detect:**
```powershell
git rm railway.toml railway.json nixpacks.toml Procfile
git commit -m "Remove config, use auto-detection"
git push
```

2. **Manually set in Railway UI:**
- Root Directory: `TravelSathi`
- Build Command: `mvn clean package -DskipTests`
- Start Command: `java -Dserver.port=$PORT -jar target/*.jar`

### Verification Steps

1. ✅ Backend deployed: `https://your-app.up.railway.app` shows something
2. ✅ Database connected: Check Railway logs for database connection messages
3. ✅ Frontend updated: API calls use Railway URL instead of localhost
4. ✅ CORS working: No CORS errors in browser console
5. ✅ Data flows: Can register/login through frontend

### Still Having Issues?

Share:
1. Railway deployment logs (from Railway dashboard)
2. Browser console errors (F12 → Console tab)
3. Your Railway backend URL

I'll help debug further!
