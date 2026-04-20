---
scope: shared
---

# Drush Usage Guide for Lagoon/Amazee.io

Complete reference for using Drush with Drupal 10 in Lagoon environments.

---

## 🎯 Critical Rules

### 1. Always Use Vendor Drush

```bash
# ✅ CORRECT - Use vendor Drush (12.x)
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush COMMAND"

# ❌ WRONG - Don't use system Drush (8.5.0)
docker-compose exec cli drush COMMAND
```

**Why**: System Drush (8.5.0) is too old for Drupal 10. Vendor Drush (12.x) is required.

### 2. Always Include --uri Parameter

```bash
# ✅ CORRECT - Always include --uri
../vendor/bin/drush --uri='http://localhost:8080' COMMAND

# ❌ WRONG - Will fail with BadRequestHttpException
../vendor/bin/drush COMMAND
```

**Why**: In Lagoon environments, Drush can't determine the site path without a URI context.

### 3. Always Change to /app/web Directory

```bash
# ✅ CORRECT - Change to web directory first
cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' COMMAND

# ❌ WRONG - Running from /app won't work
cd /app && drush COMMAND
```

---

## 📚 Common Commands Reference

### Site Management

```bash
# Check site status
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' status"

# Clear all caches
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' cr"

# Rebuild cache (more thorough)
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' rebuild"

# Run database updates
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' updatedb -y"
```

### Module Management

```bash
# List all modules
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' pm:list"

# List enabled modules only
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' pm:list --status=enabled"

# Enable a module
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' en MODULE_NAME -y"

# Disable a module
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' pmu MODULE_NAME -y"

# Uninstall a module
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' pm:uninstall MODULE_NAME -y"
```

### User Management

```bash
# List users
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' user:list"

# Reset user password
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' user:password admin 'new_password'"

# Create user
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' user:create newuser --mail='user@example.com' --password='password'"

# Login as user (generates one-time login link)
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' user:login"
```

### Permissions

```bash
# List all permissions
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' role:perm:list"

# List permissions for a role
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' role:perm:list anonymous"

# Add permission to role
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' role:perm:add anonymous 'access content' -y"

# Remove permission from role
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' role:perm:remove anonymous 'create article content' -y"
```

### Configuration Management

```bash
# Export configuration
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' config:export -y"

# Import configuration
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' config:import -y"

# Get configuration value
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' config:get system.site name"

# Set configuration value
docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' config:set system.site name 'New Site Name' -y"
```

---

## 🔧 Advanced Usage

### PHP Evaluation

Execute PHP code directly:

```bash
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' php:eval \"
\\\$node = \\\Drupal\\\node\\\Entity\\\Node::load(1);
echo \\\$node->getTitle();
\""
```

**Use Cases:**
- Create content types
- Create content programmatically
- Run custom code
- Debug issues

### Create Content Types

```bash
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' php:eval \"
\\\$node_type = \\\Drupal\\\node\\\Entity\\\NodeType::create([
  'type' => 'article',
  'name' => 'Article',
  'description' => 'Use articles for time-sensitive content',
]);
\\\$node_type->save();
echo 'Created Article content type\n';
\""
```

### Create Content

```bash
docker-compose exec -T cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' php:eval \"
\\\$node = \\\Drupal\\\node\\\Entity\\\Node::create([
  'type' => 'article',
  'title' => 'My First Article',
  'body' => ['value' => 'Article content here', 'format' => 'basic_html'],
  'status' => 1,
]);
\\\$node->save();
echo 'Created article: ' . \\\$node->id() . '\n';
\""
```

---

## 📜 Helper Aliases

Add to your shell profile (~/.bashrc or ~/.zshrc):

```bash
# Drush alias
alias drush-local='docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri=\"http://localhost:8080\""'

# Usage:
# drush-local status
# drush-local cr
# drush-local pm:list
```

Or create a wrapper script `scripts/drush.sh`:

```bash
#!/bin/bash
# Helper script to run Drush commands easily

docker-compose exec cli bash -c "cd /app/web && ../vendor/bin/drush --uri='http://localhost:8080' $@"
```

Make it executable:
```bash
chmod +x scripts/drush.sh
```

Usage:
```bash
./scripts/drush.sh status
./scripts/drush.sh cr
./scripts/drush.sh pm:list
```

---

## ⚠️ Common Errors

### Error 1: "Command not found"

**Symptom**: `drush: command not found`

**Cause**: Using system drush or drush not installed

**Solution**:
```bash
# Install drush
docker-compose exec cli bash -c "cd /app && composer require drush/drush --dev"

# Use vendor drush
cd /app/web && ../vendor/bin/drush
```

### Error 2: "BadRequestHttpException"

**Symptom**:
```
In DrupalKernel.php line 402:
[Symfony\Component\HttpKernel\Exception\BadRequestHttpException]
```

**Cause**: Missing --uri parameter

**Solution**: Add `--uri='http://localhost:8080'` to your command

### Error 3: "Bootstrap to a higher level"

**Symptom**: Command needs a higher bootstrap level

**Cause**: Not running from Drupal root or wrong directory

**Solution**: Make sure you're in `/app/web` directory:
```bash
cd /app/web && ../vendor/bin/drush COMMAND
```

### Error 4: "Version too old"

**Symptom**: Commands not working or unsupported

**Cause**: Using system drush (8.5.0) instead of vendor drush (12.x)

**Solution**: Always use `../vendor/bin/drush`

---

## 🔗 Related Documentation

- [Drupal Installation](./DRUPAL_INSTALLATION.md)
- [JSON:API & CORS](./JSONAPI_CORS.md)
- [Troubleshooting](./TROUBLESHOOTING.md)

---

**Last Updated**: November 10, 2025
