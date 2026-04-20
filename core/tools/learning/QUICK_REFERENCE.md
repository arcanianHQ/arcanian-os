---
scope: shared
---

# Quick Reference - Drupal 10 + Lagoon

Essential commands cheat sheet for daily development.

---

## 🚀 Setup & Start

```bash
# Pull images first (prevents timeouts)
docker pull uselagoon/mariadb-drupal:latest
docker pull uselagoon/php-8.3-fpm:latest
docker pull uselagoon/nginx-drupal:latest
docker pull uselagoon/php-8.3-cli-drupal:latest
docker pull node:18-alpine

# Start services
docker-compose up -d

# Wait for MariaDB (30 seconds)
sleep 30

# Verify all healthy
docker-compose ps
```

---

## 🔧 Daily Commands

```bash
# Clear Drupal cache
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' cr"

# Check site status
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' status"

# View logs
docker-compose logs -f
docker-compose logs -f nginx
docker-compose logs -f php

# Restart a service
docker-compose restart nginx

# Stop services (keeps data)
docker-compose down
```

---

## 📦 Module Management

```bash
# List modules
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' pm:list"

# Enable module
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' en MODULE_NAME -y"

# Disable module
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' pmu MODULE_NAME -y"
```

---

## 👤 User Management

```bash
# Reset admin password
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' user:password admin 'new_password'"

# Get one-time login link
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' user:login"
```

---

## 🔑 Critical Rules

1. **ALWAYS use vendor Drush**: `../vendor/bin/drush`
2. **ALWAYS include --uri**: `--uri='http://localhost:8080'`
3. **ALWAYS cd to /app/web**: `cd /app/web && ...`
4. **Set WEBROOT in docker-compose.yml**: `WEBROOT: web`

---

## 📡 Test Endpoints

```bash
# Test Drupal
curl -I http://localhost:8080/

# Test JSON:API
curl http://localhost:8080/jsonapi

# Test specific content type
curl http://localhost:8080/jsonapi/node/article
```

---

## 🆘 Emergency

```bash
# Restart everything
docker-compose restart

# Full reset (⚠️ DELETES DATA)
docker-compose down -v
docker-compose up -d
```

---

## 🔗 Important URLs

```
Drupal Admin: http://localhost:8080/user/login
JSON:API:     http://localhost:8080/jsonapi
Frontend:     http://localhost:5173
```

---

**Last Updated**: November 10, 2025
