# TravelSathi Frontend Dockerfile
# Build React (Vite) app then serve with Nginx
FROM node:20-alpine AS build
WORKDIR /app
# Install deps
COPY package.json package-lock.json* yarn.lock* ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi
# Copy rest of source
COPY . .
# Build static assets
RUN npm run build

FROM nginx:1.27-alpine
# Replace default Nginx config with SPA-friendly config
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
