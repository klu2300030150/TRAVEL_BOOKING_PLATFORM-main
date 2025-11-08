# Railway Deployment Guide for TravelSathi Backend

## Quick Deploy to Railway

### Step 1: Create Railway Account
1. Go to https://railway.app/
2. Sign up with your GitHub account (free tier available)
3. Verify your account

### Step 2: Deploy Backend

#### Option A: Deploy from GitHub (Recommended)

1. **Push your code** (already done ✅)
   - Your code is at: https://github.com/klu2300030150/TRAVEL_BOOKING_PLATFORM-main

2. **Create New Project on Railway**
   - Go to: https://railway.app/new
   - Click **"Deploy from GitHub repo"**
   - Select: `TRAVEL_BOOKING_PLATFORM-main`
   - Railway will detect the Spring Boot app automatically

3. **Add PostgreSQL Database**
   - In your Railway project, click **"+ New"**
   - Select **"Database"** → **"Add PostgreSQL"**
   - Railway will automatically provision a PostgreSQL database
   - Database credentials are automatically injected as `DATABASE_URL`

4. **Configure Environment Variables**
   - Click on your **backend service**
   - Go to **"Variables"** tab
   - Add these variables:

   ```
   PORT=9000
   DB_DIALECT=org.hibernate.dialect.PostgreSQLDialect
   SHOW_SQL=false
   ```

   **Note**: `DATABASE_URL`, `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE` are automatically set by Railway when you add PostgreSQL.

5. **Set Root Directory** (Important!)
   - In your service settings
   - Go to **"Settings"** → **"Service"**
   - Set **Root Directory**: `TravelSathi`
   - Click **"Save Changes"**

6. **Deploy**
   - Railway will automatically build and deploy
   - Wait 2-5 minutes for the build to complete
   - You'll get a URL like: `https://your-app-name.up.railway.app`

#### Option B: Deploy with Railway CLI

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Initialize project
cd d:\TRAVEL_BOOKING_PLATFORM-main\TravelSathi
railway init

# Add PostgreSQL
railway add postgresql

# Deploy
railway up
```

### Step 3: Get Your Backend URL

Once deployed, you'll get a URL like:
```
https://travelsathi-production-xxxx.up.railway.app
```

### Step 4: Update Frontend to Use Railway Backend

The backend URL needs to be added to your frontend. Since you're using environment variables:

1. Create a `.env` file in `travelsathi-frontend/`:
   ```
   VITE_API_BASE_URL=https://your-railway-app.up.railway.app
   ```

2. Update your API calls to use this URL instead of `localhost:9000`

### Step 5: Enable CORS (Already configured ✅)

I've already updated `application.properties` to allow requests from:
- `https://klu2300030150.github.io` (your GitHub Pages frontend)
- `http://localhost:3000` (local development)

### Important Notes

#### Database Migration: MySQL → PostgreSQL

Railway uses PostgreSQL instead of MySQL. I've already:
- ✅ Added PostgreSQL driver to `pom.xml`
- ✅ Configured application.properties to auto-detect database
- ✅ Set environment variables for flexibility

Your app will:
- Use **MySQL** locally (with your credentials: root/Sreekar@8297)
- Use **PostgreSQL** on Railway (automatic via `DATABASE_URL`)

#### Database Tables

Railway's PostgreSQL will:
- Create tables automatically on first run (via `ddl-auto=update`)
- No need to manually create the `travelvibe` database
- Hibernate will handle schema creation

### Troubleshooting

**Build fails?**
- Check that Root Directory is set to `TravelSathi`
- Verify Java 17 is being used

**Database connection fails?**
- Ensure PostgreSQL service is added to your project
- Check that `DB_DIALECT` is set to PostgreSQL dialect

**CORS errors?**
- Verify your frontend domain is in the CORS allowed origins
- Check Railway logs for CORS-related messages

### Monitoring

- **Logs**: Click on your service → "Deployments" → Latest deployment → "View Logs"
- **Metrics**: Railway provides CPU, Memory, Network usage graphs
- **Database**: Click PostgreSQL service to see connection details

### Costs

- **Free Tier**: $5 credit/month (enough for small apps)
- **After free tier**: Pay only for usage (~$1-5/month for small apps)
- **No credit card required** for free tier

### Files I've Updated for Railway

✅ `TravelSathi/pom.xml` - Added PostgreSQL driver
✅ `TravelSathi/src/main/resources/application.properties` - Environment variable configuration
✅ This deployment guide

### Next Steps

1. Deploy backend to Railway (follow steps above)
2. Get your Railway backend URL
3. Update frontend API calls with the Railway URL
4. Test your app end-to-end!

---

**Your Railway Project URL**: After deployment, share it here so I can help update the frontend!
