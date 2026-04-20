---
scope: shared
---

# Lagoon/Amazee.io Setup Guide

Complete guide for setting up projects compatible with Lagoon/Amazee.io hosting.

---

## 🎯 Why Lagoon?

Lagoon/Amazee.io is a Docker-based hosting platform specifically designed for Drupal, with:
- Built-in Drupal optimization
- Docker Compose for local development
- Production-parity environments
- Automated backups and scaling

---

## 🏗️ Architecture

Lagoon uses a specific service architecture:

```
┌─────────────────────────────────────────────┐
│             nginx (Web Server)              │
│          Port 8080 → Public Access          │
└────────────────┬────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
┌───────▼────────┐  ┌─────▼──────────────────┐
│  PHP-FPM       │  │  CLI Container         │
│  (Processes    │  │  (Drush, Composer,     │
│   PHP code)    │  │   Admin tasks)         │
└───────┬────────┘  └────────────────────────┘
        │
┌───────▼────────┐
│   MariaDB      │
│  (Database)    │
└────────────────┘
```

---

## 📦 Required Images

All images must be from `uselagoon/*` namespace:

```yaml
services:
  mariadb:
    image: uselagoon/mariadb-drupal:latest
  
  php:
    image: uselagoon/php-8.3-fpm:latest
  
  nginx:
    image: uselagoon/nginx-drupal:latest
  
  cli:
    image: uselagoon/php-8.3-cli-drupal:latest
```

**Why**: These images are pre-configured for Drupal and match production environment.

---

## 🔧 Critical Environment Variables

### WEBROOT

**MUST be set** for both php and nginx:

```yaml
php:
  environment:
    WEBROOT: web

nginx:
  environment:
    WEBROOT: web
```

**Reason**: Drupal 10 uses `web/` subdirectory but Lagoon defaults to `/app/`.

### Database Connection

```yaml
php:
  environment:
    MARIADB_HOST: mariadb  # Container name
    MARIADB_PORT: 3306
    MARIADB_DATABASE: ${MARIADB_DATABASE}
    MARIADB_USER: ${MARIADB_USER}
    MARIADB_PASSWORD: ${MARIADB_PASSWORD}
```

### LAGOON_ROUTE

```yaml
php:
  environment:
    LAGOON_ROUTE: http://localhost:8080

nginx:
  environment:
    LAGOON_ROUTE: http://localhost:8080
```

---

## 📁 Directory Structure

```
project/
├── docker-compose.yml          # Lagoon service definitions
├── .env                        # Environment variables
├── .lagoon.yml                 # Lagoon deployment config (production)
├── drupal-backend/
│   ├── web/                    # Drupal webroot
│   │   ├── core/
│   │   ├── modules/
│   │   ├── themes/
│   │   └── sites/
│   ├── vendor/                 # Composer dependencies
│   └── composer.json
└── frontend/                   # Optional frontend app
```

---

## 🔀 Local vs Production Differences

| Aspect | Local Development | Production (Amazee.io) |
|--------|-------------------|------------------------|
| Port Mapping | 8080:8080 | Managed by Lagoon |
| Database Host | `mariadb` | `mariadb` (same) |
| LAGOON_ROUTE | http://localhost:8080 | https://yoursite.com |
| Volumes | Local filesystem | Persistent volumes |
| Backups | Manual | Automated |

---

## 🚀 Deployment to Amazee.io

### 1. Add .lagoon.yml

```yaml
docker-compose-yaml: docker-compose.yml

project: my-drupal-project

environments:
  main:
    routes:
      - nginx:
        - "www.example.com"
        - "example.com"

tasks:
  post-rollout:
    - run:
        name: drush updb
        command: drush updb -y
        service: cli
    - run:
        name: drush cr
        command: drush cr
        service: cli
```

### 2. Connect Git Repository

```bash
# Add Amazee.io remote
git remote add lagoon ssh://git@ssh.lagoon.amazeeio.cloud:32222/yourproject.git

# Push to deploy
git push lagoon main
```

### 3. Monitor Deployment

```bash
# View build logs (via Amazee.io dashboard or CLI)
lagoon logs build -p yourproject -e main
```

---

## ✅ Best Practices

1. **Always use Lagoon images** - never use standard Docker Hub images
2. **Set WEBROOT** - critical for Drupal 10
3. **Use MariaDB, not MySQL** - production uses MariaDB
4. **Match PHP versions** - local and production should match (8.3)
5. **Test locally first** - verify everything works before deploying
6. **Use health checks** - ensure services are ready before dependent services start
7. **Delegated volumes on macOS** - better performance with `:delegated`

---

## 🔗 Related Documentation

- [Docker Configuration](./DOCKER_CONFIGURATION.md)
- [Drupal Installation](./DRUPAL_INSTALLATION.md)
- [Troubleshooting](./TROUBLESHOOTING.md)

---

## 📚 External Resources

- [Lagoon Documentation](https://docs.lagoon.sh/)
- [Amazee.io](https://www.amazee.io/)
- [Lagoon Docker Images](https://hub.docker.com/u/uselagoon)

---

**Last Updated**: November 10, 2025
