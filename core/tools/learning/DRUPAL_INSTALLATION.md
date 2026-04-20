---
scope: shared
---

# Drupal 10 Installation Guide (Lagoon/Amazee.io)

Complete step-by-step process for installing Drupal 10 in a Lagoon environment.

---

## 📋 Prerequisites

Before starting:
- ✅ Docker Compose services running
- ✅ MariaDB is healthy (wait 30 seconds after starting)
- ✅ WEBROOT environment variable set in docker-compose.yml

---

## 🚀 Installation Process

### Step 1: Install Drupal via Composer

```bash
# Create Drupal 10 project in temporary location
docker-compose exec cli composer create-project drupal/recommended-project:^10 /tmp/drupal --no-interaction

# Copy files to /app directory
docker-compose exec cli bash -c "cp -r /tmp/drupal/* /app/ && cp -r /tmp/drupal/.* /app/ 2>/dev/null || true"

# Create autoload symlink
docker-compose exec cli bash -c "cd /app && ln -sf vendor/autoload.php autoload.php"
```

**What this does:**
- Downloads Drupal 10.5.x and all dependencies
- Sets up proper directory structure
- Creates `/app/web/` as the webroot
- Installs Composer dependencies

### Step 2: Install Drush

```bash
# Install Drush 12.x (compatible with Drupal 10)
docker-compose exec cli bash -c "cd /app && composer require drush/drush --dev --no-interaction"

# Verify Drush is installed
docker-compose exec cli bash -c "cd /app && ls -la vendor/bin/drush"
```

**Important**: Always use `../vendor/bin/drush` (version 12.x), NOT system drush (version 8.5.0).

### Step 3: Prepare Directories

```bash
# Create and set permissions for files directory
docker-compose exec cli bash -c "mkdir -p /app/web/sites/default/files && chmod 777 /app/web/sites/default/files"

# Set permissions for sites/default
docker-compose exec cli bash -c "chmod 777 /app/web/sites/default"
```

### Step 4: Install Drupal Site

**CRITICAL**: Must include `--uri` parameter for Drush to work in Lagoon.

```bash
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush site:install standard \
  --db-url='mysql://\${MARIADB_USER}:\${MARIADB_PASSWORD}@mariadb:3306/\${MARIADB_DATABASE}' \
  --uri='http://localhost:8080' \
  --site-name='My Drupal Site' \
  --account-name=admin \
  --account-pass=admin_secure_pass \
  --account-mail=admin@example.com \
  --locale=en \
  --yes"
```

**Parameters explained:**
- `--db-url`: Database connection string (use `mariadb` as hostname, not `localhost`)
- `--uri`: **REQUIRED** for Lagoon - tells Drush the site URL
- `--site-name`: Site name shown in admin
- `--account-name`: Admin username
- `--account-pass`: Admin password
- `--account-mail`: Admin email
- `--locale`: Language (en for English)
- `--yes`: Auto-confirm all prompts

---

## ✅ Verification

After installation, verify everything works:

```bash
# Check Drupal status
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' status"

# Expected output:
# Drupal version : 10.5.x
# Site URI       : http://localhost:8080
# Database       : Connected
# Drupal bootstrap : Successful

# Test web access
curl -I http://localhost:8080/

# Expected: HTTP/1.1 200 OK

# Test admin login page
curl -I http://localhost:8080/user/login

# Expected: HTTP/1.1 200 OK
```

### Access the Site

Open in browser:
```
URL: http://localhost:8080/user/login
Username: admin
Password: admin_secure_pass
```

---

## 🔧 Post-Installation Configuration

### Enable Required Modules

```bash
# JSON:API for headless CMS
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' en jsonapi -y"

# Serialization (required for JSON:API)
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' en serialization -y"

# Basic Auth (optional, for API authentication)
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' en basic_auth -y"
```

### Configure CORS

See [JSONAPI_CORS.md](./JSONAPI_CORS.md) for complete CORS configuration.

### Set Permissions

```bash
# Allow anonymous users to access content
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' role:perm:add anonymous 'access content' -y"

# Clear cache
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' cr"
```

---

## 📝 Common Installation Issues

### Issue 1: "No input file specified"

**Symptom**: Website shows "No input file specified" error.

**Cause**: Missing `WEBROOT: web` environment variable.

**Solution**: Add to docker-compose.yml:
```yaml
php:
  environment:
    WEBROOT: web

nginx:
  environment:
    WEBROOT: web
```

Then restart services:
```bash
docker-compose down && docker-compose up -d
```

### Issue 2: Drush "BadRequestHttpException"

**Symptom**:
```
In DrupalKernel.php line 402:
[Symfony\Component\HttpKernel\Exception\BadRequestHttpException]
```

**Cause**: Missing `--uri` parameter.

**Solution**: Always add `--uri='http://localhost:8080'` to ALL Drush commands.

### Issue 3: Database Connection Failed

**Symptom**: "Connection refused" or "Can't connect to server"

**Causes & Solutions**:

1. MariaDB not ready yet:
   ```bash
   # Wait 30 seconds and retry
   sleep 30
   ```

2. Wrong hostname:
   ```bash
   # ✅ Correct - use 'mariadb' as hostname
   --db-url='mysql://user:pass@mariadb:3306/database'

   # ❌ Wrong - don't use 'localhost'
   --db-url='mysql://user:pass@localhost/database'
   ```

3. Check MariaDB health:
   ```bash
   docker-compose ps mariadb
   # Should show: Up (healthy)
   ```

### Issue 4: Drush Not Found

**Symptom**: `drush: command not found`

**Cause**: Using system Drush or Drush not installed.

**Solution**: Use vendor Drush:
```bash
# ✅ Correct
cd /app/web && ../vendor/bin/drush

# ❌ Wrong
drush
```

If not installed:
```bash
docker-compose exec cli bash -c "cd /app && composer require drush/drush --dev"
```

### Issue 5: SSL/TLS Error Warning

**Symptom**:
```
ERROR 2026 (HY000): TLS/SSL error: SSL is required, but the server does not support it
```

**This is a WARNING, not an error** - installation will continue and succeed. It can be safely ignored in local development.

---

## 🔄 Reinstall Process

If you need to reinstall Drupal:

```bash
# 1. Drop database
docker-compose exec mariadb mariadb -u root -proot_pass -e "DROP DATABASE IF EXISTS drupal_db; CREATE DATABASE drupal_db;"

# 2. Remove settings files
docker-compose exec cli bash -c "cd /app/web/sites/default && rm -f settings.php settings.local.php && chmod 777 ."

# 3. Reinstall
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush site:install standard --db-url='mysql://drupal_user:drupal_pass@mariadb:3306/drupal_db' --uri='http://localhost:8080' --site-name='My Drupal Site' --account-name=admin --account-pass=admin_secure_pass --account-mail=admin@example.com -y"
```

---

## 📜 Installation Script Template

Create `scripts/install-drupal.sh`:

```bash
#!/bin/bash
set -e

echo "🚀 Installing Drupal with Lagoon/Amazee.io stack..."

# Wait for MariaDB to be ready
echo "⏳ Waiting for MariaDB database..."
sleep 30

# Install Drupal using CLI container
# IMPORTANT: --uri parameter is required for Drush to work properly
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush site:install standard \
  --db-url='mysql://\${MARIADB_USER}:\${MARIADB_PASSWORD}@mariadb/\${MARIADB_DATABASE}' \
  --uri='http://localhost:8080' \
  --site-name='\${DRUPAL_SITE_NAME}' \
  --account-name=\${DRUPAL_ADMIN_USER} \
  --account-pass=\${DRUPAL_ADMIN_PASSWORD} \
  --account-mail=\${DRUPAL_ADMIN_EMAIL} \
  --locale=en \
  --yes"

echo "✅ Drupal installed successfully!"
echo "🔑 Admin credentials:"
echo "   Username: \${DRUPAL_ADMIN_USER}"
echo "   Password: \${DRUPAL_ADMIN_PASSWORD}"
echo "   URL: http://localhost:8080"
```

Make executable:
```bash
chmod +x scripts/install-drupal.sh
```

---

## 🔗 Related Documentation

- [Docker Configuration](./DOCKER_CONFIGURATION.md)
- [Drush Guide](./DRUSH_GUIDE.md)
- [JSON:API & CORS Setup](./JSONAPI_CORS.md)
- [Troubleshooting](./TROUBLESHOOTING.md)

---

**Last Updated**: November 10, 2025
