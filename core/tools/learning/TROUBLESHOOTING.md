---
scope: shared
---

# Troubleshooting Guide - Drupal 10 + Lagoon

Complete reference for all common issues and their solutions.

---

## 🚨 CRITICAL Issues (Must Read)

### 1. "No input file specified" Error

**Symptom**:
```
ERROR: Unable to open primary script: /app/index.php (No such file or directory)
```
When accessing http://localhost:8080/user/login you see "No input file specified"

**Root Cause**: Drupal 10 uses `web/` subdirectory as document root, but Lagoon containers default to `/app/`.

**Solution**: Add `WEBROOT: web` to BOTH php and nginx services in docker-compose.yml:

```yaml
php:
  image: uselagoon/php-8.3-fpm:latest
  environment:
    WEBROOT: web  # ← CRITICAL
    MARIADB_HOST: mariadb
    # ... other vars

nginx:
  image: uselagoon/nginx-drupal:latest
  environment:
    WEBROOT: web  # ← CRITICAL
    LAGOON_ROUTE: http://localhost:8080
```

**After adding, restart services**:
```bash
docker-compose down && docker-compose up -d
```

---

### 2. Drush "BadRequestHttpException" Error

**Symptom**:
```
In DrupalKernel.php line 402:
[Symfony\Component\HttpKernel\Exception\BadRequestHttpException]
```

**Root Cause**: Drush cannot determine site path without URI context in Lagoon environments.

**Solution**: ALWAYS add `--uri='http://localhost:8080'` to ALL Drush commands:

```bash
# ❌ Wrong - will fail
docker-compose exec cli drush status

# ✅ Correct - always include --uri
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' status"
```

**All commands need --uri**:
- site:install
- module enable/disable
- permissions
- cache clear
- php:eval
- config:import/export

---

### 3. Drupal Not Installed / Empty Backend Directory

**Symptom**: No Drupal files in `drupal-backend/` directory, only empty placeholder folders.

**Root Cause**: Drupal must be installed via Composer - it doesn't come pre-installed.

**Solution**: Install Drupal 10 via Composer:

```bash
# 1. Create Drupal project
docker-compose exec cli composer create-project drupal/recommended-project:^10 /tmp/drupal --no-interaction

# 2. Copy to /app directory
docker-compose exec cli bash -c "cp -r /tmp/drupal/* /app/ && cp -r /tmp/drupal/.* /app/ 2>/dev/null || true"

# 3. Install Drush
docker-compose exec cli bash -c "cd /app && composer require drush/drush --dev --no-interaction"

# 4. Run site installation
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush site:install standard --db-url='mysql://drupal_user:drupal_pass@mariadb:3306/drupal_db' --uri='http://localhost:8080' --site-name='Client Portal' --account-name=admin --account-pass=admin_secure_pass --account-mail=admin@clientportal.local -y"
```

---

### 4. Drush Version Too Old

**Symptom**:
```
Drush Version: 8.5.0
Command not found or unsupported
```

**Root Cause**: System Drush (8.5.0) is too old for Drupal 10 (requires Drush 12+).

**Solution**: Always use vendor Drush, not system Drush:

```bash
# ❌ Wrong - uses old system Drush
docker-compose exec cli drush

# ✅ Correct - uses project Drush 12.x
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush"
```

---

### 5. CORS Module Not Found

**Symptom**:
```
Unable to install modules jsonapi, serialization, basic_auth, cors due to missing modules cors.
```

**Root Cause**: CORS is NOT a module in Drupal 10 - it's configured via `services.yml`.

**Solution**: Configure CORS in services.yml:

```bash
docker-compose exec -T cli bash -c "cat > /app/web/sites/default/services.yml << 'EOFCORS'
parameters:
  cors.config:
    enabled: true
    allowedOrigins: ['http://localhost:5173', 'http://localhost:3000']
    allowedMethods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS']
    allowedHeaders: ['*']
    maxAge: 1000
    supportsCredentials: true
EOFCORS
"
```

Only enable these modules:
```bash
drush --uri='http://localhost:8080' en jsonapi serialization basic_auth -y
```

---

### 6. Content Type Creation Fails

**Symptom**: `drush generate:content-types` command doesn't exist or fails.

**Root Cause**: This command is not available in Drupal 10.

**Solution**: Create content types using `drush php:eval`:

```bash
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' php:eval \"
\\\$node_type = \\\Drupal\\\node\\\Entity\\\NodeType::create([
  'type' => 'client',
  'name' => 'Client',
  'description' => 'A client in the portal',
]);
\\\$node_type->save();
echo 'Created Client content type\n';
\""
```

---

### 7. JSON:API Permission Error

**Symptom**:
```
Permission(s) not found: restful get jsonapi
```

**Root Cause**: This permission doesn't exist in Drupal 10. JSON:API uses standard content access.

**Solution**: Only add standard permissions:

```bash
# ✅ This works
drush --uri='http://localhost:8080' role:perm:add anonymous 'access content' -y

# ❌ This doesn't exist
drush role:perm:add anonymous 'restful get jsonapi'
```

---

### 8. Sample Content with Custom Fields

**Symptom**: Creating nodes with custom fields like `field_email`, `field_company` fails.

**Root Cause**: Custom fields must be created first - they don't exist by default.

**Solution**: Use only default fields (title, body, status):

```bash
# ✅ Correct - uses only default fields
$node = \Drupal\node\Entity\Node::create([
  'type' => 'client',
  'title' => 'Acme Corporation',
  'status' => 1,  # Published
]);

# ❌ Wrong - tries to use non-existent fields
$node = \Drupal\node\Entity\Node::create([
  'type' => 'client',
  'field_email' => 'test@example.com',  # Doesn't exist!
]);
```

For body field (it's an array):
```bash
$node = \Drupal\node\Entity\Node::create([
  'type' => 'article',
  'title' => 'My Article',
  'body' => ['Complete article content here'],
  'status' => 1,
]);
```

---

## 🐳 Docker Issues

### Port Already in Use

**Symptom**: `Bind for 0.0.0.0:8080 failed: port is already allocated`

**Solution**:
```bash
# Find what's using the port
lsof -i :8080
lsof -i :3306
lsof -i :5173

# Stop conflicting container
docker stop <container-name>

# Or stop all containers
docker stop $(docker ps -aq)
```

### Image Pull Timeout

**Symptom**: `context deadline exceeded` when pulling images

**Solutions**:
1. Pull images individually:
```bash
docker pull uselagoon/mariadb-drupal:latest
docker pull uselagoon/php-8.3-fpm:latest
docker pull uselagoon/nginx-drupal:latest
docker pull uselagoon/php-8.3-cli-drupal:latest
```

2. Check Docker Hub status: https://status.docker.com/

3. Retry during off-peak hours

### Platform Warning (Apple Silicon)

**Symptom**:
```
The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)
```

**This is NORMAL and SAFE** - Lagoon images are amd64 and run via Rosetta on Apple Silicon. Ignore this warning.

---

## 🗄️ Database Issues

### Connection Refused

**Symptom**: `Connection refused` or `Can't connect to server`

**Solutions**:

1. MariaDB not ready - wait 30 seconds:
```bash
sleep 30
```

2. Wrong hostname - use `mariadb` not `localhost`:
```bash
# ✅ Correct
--db-url='mysql://user:pass@mariadb:3306/database'

# ❌ Wrong
--db-url='mysql://user:pass@localhost/database'
```

3. Check MariaDB health:
```bash
docker-compose ps mariadb
# Should show: Up (healthy)
```

### SSL/TLS Warning

**Symptom**:
```
ERROR 2026 (HY000): TLS/SSL error: SSL is required, but the server does not support it
```

**This is a WARNING, not an error** - installation continues successfully. Safe to ignore in local development.

---

## 🌐 Web Access Issues

### 404 on All Pages

**Causes & Solutions**:

1. Drupal not installed - run installation
2. WEBROOT not set - add to docker-compose.yml
3. Nginx not running - check `docker-compose ps`

### 403 Forbidden

**Causes**:
1. Permissions not set - add anonymous permissions
2. Content unpublished - set `status = 1`
3. CORS not configured - add services.yml

---

## 🔄 Recovery Procedures

### Full Reset

```bash
# Stop all services
docker-compose down

# Remove volumes (⚠️ DELETES ALL DATA)
docker-compose down -v

# Clean images (optional)
docker image prune -a -f

# Start fresh
docker-compose up -d
sleep 30

# Reinstall Drupal
./scripts/install-drupal.sh
```

### Database Reset Only

```bash
# Drop and recreate database
docker-compose exec mariadb mariadb -u root -proot_pass -e "DROP DATABASE IF EXISTS drupal_db; CREATE DATABASE drupal_db;"

# Remove settings
docker-compose exec cli bash -c "cd /app/web/sites/default && rm -f settings.php settings.local.php && chmod 777 ."

# Reinstall
./scripts/install-drupal.sh
```

---

## 🔗 Related Documentation

- [Docker Configuration](./DOCKER_CONFIGURATION.md)
- [Drupal Installation](./DRUPAL_INSTALLATION.md)
- [Drush Guide](./DRUSH_GUIDE.md)
- [JSON:API & CORS](./JSONAPI_CORS.md)

---

**Last Updated**: November 10, 2025
