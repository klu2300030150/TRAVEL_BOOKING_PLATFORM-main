# Local Development Quick Start

## Problem Fixed
The MySQL container configuration had conflicting environment variables (`MYSQL_USER=root` + `MYSQL_ROOT_PASSWORD`), causing it to fail. Now fixed!

## Prerequisites
- Docker Desktop running
- Port 3306 available
- (Optional) Maven/Java 17 for running backend outside Docker

## Start Full Stack Locally

### 1. Start MySQL Database
```powershell
docker compose up -d db
```
Wait ~10 seconds for MySQL to be healthy:
```powershell
docker ps
# Look for "healthy" status
```

### 2. Option A: Run Backend in Docker
```powershell
docker compose up -d backend
```
Backend: http://localhost:9000

### 2. Option B: Run Backend with Maven (Local)
Ensure `.env` file exists with correct database credentials:
```properties
DATABASE_URL=jdbc:mysql://localhost:3306/travelvibe
MYSQL_USER=root
MYSQL_PASSWORD=Sreekar@8297
```

Run with Maven wrapper (if Maven installed):
```powershell
cd TravelSathi
./mvnw spring-boot:run
```

### 3. Run Frontend Locally
```powershell
cd travelsathi-frontend
npm install
npm run dev
```
Frontend: http://localhost:5173

The frontend will connect to backend at http://localhost:9000 via environment variable `VITE_API_BASE_URL`.

## Verify Everything Works

1. **MySQL**: `docker logs travelsathi-mysql` should show "ready for connections"
2. **Backend**: Visit http://localhost:9000 - should return 404 or Whitelabel Error (means it's running)
3. **Frontend**: http://localhost:5173 should show the TravelSathi UI

## Troubleshooting

### MySQL won't start on port 3306
Check if something else is using it:
```powershell
netstat -ano | findstr ":3306"
```
If busy, either kill that process or change docker-compose port to `"3307:3306"` and update `.env` DATABASE_URL.

### Backend can't connect to database
- Verify MySQL is running: `docker ps`
- Check logs: `docker logs travelsathi-mysql`
- Ensure password matches in `.env` and docker-compose.yml
- Default password: `Sreekar@8297`

### Flyway migration errors
First run will create `flyway_schema_history` table. If you see errors, either:
1. Let JPA create tables first (set `spring.jpa.hibernate.ddl-auto=create` temporarily)
2. Or write actual schema DDL in `TravelSathi/src/main/resources/db/migration/V1__init_schema.sql`

## Clean Slate (Reset Everything)
```powershell
docker compose down -v
docker compose up -d
```
This deletes all data and starts fresh.

## Database Credentials
- **Host**: localhost:3306
- **User**: root
- **Password**: Sreekar@8297
- **Database**: travelvibe

Connect with any MySQL client (MySQL Workbench, DBeaver, etc.) using these credentials.
