---
scope: shared
---

# Docker Configuration for Drupal 10 + Lagoon

**Tech Stack**: Docker Compose with Lagoon/Amazee.io compatible images

---

## 📦 Complete docker-compose.yml Template

```yaml
services:
  mariadb:
    image: uselagoon/mariadb-drupal:latest
    container_name: client-portal-mariadb
    restart: unless-stopped
    environment:
      MARIADB_DATABASE: ${MARIADB_DATABASE}
      MARIADB_USER: ${MARIADB_USER}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
    volumes:
      - mariadb-data:/var/lib/mysql
    ports:
      - "3306:3306"
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MARIADB_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 5

  php:
    image: uselagoon/php-8.3-fpm:latest
    container_name: app-php
    restart: unless-stopped
    depends_on:
      mariadb:
        condition: service_healthy
    environment:
      MARIADB_HOST: mariadb
      MARIADB_PORT: 3306
      MARIADB_DATABASE: ${MARIADB_DATABASE}
      MARIADB_USER: ${MARIADB_USER}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
      LAGOON_ROUTE: http://localhost:8080
      WEBROOT: web  # CRITICAL: Drupal 10 uses web/ subdirectory
    volumes:
      - ./drupal-backend:/app:delegated
    networks:
      - app-network

  nginx:
    image: uselagoon/nginx-drupal:latest
    container_name: app-nginx
    restart: unless-stopped
    depends_on:
      - php
    environment:
      LAGOON_ROUTE: http://localhost:8080
      WEBROOT: web  # CRITICAL: Drupal 10 uses web/ subdirectory
    volumes:
      - ./drupal-backend:/app:delegated
    ports:
      - "8080:8080"
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8080/"]
      interval: 30s
      timeout: 10s
      retries: 3

  cli:
    image: uselagoon/php-8.3-cli-drupal:latest
    container_name: app-cli
    restart: unless-stopped
    depends_on:
      mariadb:
        condition: service_healthy
    environment:
      MARIADB_HOST: mariadb
      MARIADB_PORT: 3306
      MARIADB_DATABASE: ${MARIADB_DATABASE}
      MARIADB_USER: ${MARIADB_USER}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
    volumes:
      - ./drupal-backend:/app:delegated
    networks:
      - app-network

  frontend:
    image: node:18-alpine
    container_name: app-frontend
    restart: unless-stopped
    working_dir: /app
    volumes:
      - ./frontend:/app
      - /app/node_modules
    ports:
      - "5173:5173"
    networks:
      - app-network
    environment:
      - VITE_API_URL=http://localhost:8080
      - VITE_API_BASE=/jsonapi
    command: sh -c "npm install && npm run dev -- --host 0.0.0.0"

networks:
  app-network:
    driver: bridge

volumes:
  mariadb-data:
```

---

## 🔧 Environment Variables (.env)

```env
# Database Configuration (MariaDB for Lagoon/Amazee.io)
MARIADB_ROOT_PASSWORD=root_pass
MARIADB_DATABASE=drupal_db
MARIADB_USER=drupal_user
MARIADB_PASSWORD=drupal_pass

# Drupal Configuration
DRUPAL_SITE_NAME=My Drupal Site
DRUPAL_ADMIN_USER=admin
DRUPAL_ADMIN_PASSWORD=admin_secure_pass
DRUPAL_ADMIN_EMAIL=admin@example.com

# Frontend Configuration
VITE_API_URL=http://localhost:8080
VITE_API_BASE=/jsonapi
```

---

## 🎯 Critical Configuration Points

### 1. WEBROOT Environment Variable

**CRITICAL**: Must be set for BOTH php and nginx services.

```yaml
php:
  environment:
    WEBROOT: web  # Required for Drupal 10

nginx:
  environment:
    WEBROOT: web  # Required for Drupal 10
```

**Why**: Drupal 10 uses `web/` as the document root, but Lagoon containers default to `/app/`. Without this, you'll get "No input file specified" error.

### 2. MariaDB (not MySQL)

Always use `uselagoon/mariadb-drupal:latest` - this is what Amazee.io uses in production.

### 3. PHP 8.3

Use `uselagoon/php-8.3-fpm:latest` and `uselagoon/php-8.3-cli-drupal:latest` for:
- Full Drupal 10 compatibility
- Latest security patches
- Lagoon/Amazee.io support

### 4. Health Checks

Health checks ensure services are ready before dependent services start:

```yaml
mariadb:
  healthcheck:
    test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MARIADB_ROOT_PASSWORD}"]
    interval: 10s
    timeout: 5s
    retries: 5

nginx:
  healthcheck:
    test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8080/"]
    interval: 30s
    timeout: 10s
    retries: 3
```

### 5. Volume Mounts

Use `:delegated` flag on macOS for better performance:

```yaml
volumes:
  - ./drupal-backend:/app:delegated
```

### 6. Depends On

Ensure services start in correct order:

```yaml
php:
  depends_on:
    mariadb:
      condition: service_healthy  # Wait for MariaDB to be healthy

nginx:
  depends_on:
    - php  # Nginx needs PHP-FPM running

cli:
  depends_on:
    mariadb:
      condition: service_healthy
```

---

## 🚀 Usage

### Start Services

```bash
# Pull images first (recommended)
docker pull uselagoon/mariadb-drupal:latest
docker pull uselagoon/php-8.3-fpm:latest
docker pull uselagoon/nginx-drupal:latest
docker pull uselagoon/php-8.3-cli-drupal:latest
docker pull node:18-alpine

# Start all services
docker-compose up -d

# Wait for MariaDB (30 seconds)
sleep 30

# Verify all services are healthy
docker-compose ps
```

### Stop Services

```bash
# Stop and keep data
docker-compose down

# ⚠️ NEVER do this unless you want to delete ALL data:
# docker-compose down -v
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f nginx
docker-compose logs -f php
docker-compose logs -f mariadb
```

---

## 🔍 Verification

After starting services, verify:

```bash
# Check all services are running and healthy
docker-compose ps

# Expected output:
# NAME         IMAGE                                   STATUS
# app-mariadb  uselagoon/mariadb-drupal:latest        Up (healthy)
# app-php      uselagoon/php-8.3-fpm:latest           Up
# app-nginx    uselagoon/nginx-drupal:latest          Up (healthy)
# app-cli      uselagoon/php-8.3-cli-drupal:latest    Up
# app-frontend node:18-alpine                          Up

# Test web access
curl -I http://localhost:8080/
```

---

## 📝 Common Issues

### Port Already in Use

```bash
# Find what's using the port
lsof -i :8080
lsof -i :3306
lsof -i :5173

# Stop conflicting container
docker stop <container-name>
```

### Platform Warning (Apple Silicon)

```
The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)
```

**This is normal and safe** - Lagoon images are amd64 and run via Rosetta emulation on Apple Silicon.

### Services Won't Start

```bash
# Full restart
docker-compose down
docker-compose up -d
sleep 30
docker-compose ps
```

---

## 🔗 Related Documentation

- [Drupal Installation](./DRUPAL_INSTALLATION.md)
- [Lagoon Setup](./LAGOON_SETUP.md)
- [Troubleshooting](./TROUBLESHOOTING.md)

---

**Last Updated**: November 10, 2025
