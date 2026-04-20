---
scope: shared
---

# Tech Stack Documentation

Reusable technical knowledge for Drupal 10 + React projects with Lagoon/Amazee.io hosting.

---

## 📚 Overview

This directory contains **reusable technical documentation** that applies to any Drupal 10 + Lagoon project. Use these guides as reference when setting up new projects or troubleshooting existing ones.

---

## 📖 Documentation Index

### 🏗️ Architecture & Setup

**[Lagoon Setup](./LAGOON_SETUP.md)**
- Why use Lagoon/Amazee.io
- Architecture diagram
- Required Docker images
- Critical environment variables
- Local vs production differences
- Deployment process

**[Docker Configuration](./DOCKER_CONFIGURATION.md)**
- Complete docker-compose.yml template
- Service definitions (nginx, php, cli, mariadb)
- WEBROOT configuration (CRITICAL)
- Volume mounts and performance
- Health checks
- Network configuration

### 🚀 Installation & Configuration

**[Drupal Installation](./DRUPAL_INSTALLATION.md)**
- Complete installation sequence
- Composer setup
- Drush installation
- Site installation with --uri parameter
- Verification steps
- Common issues

**[JSON:API & CORS](./JSONAPI_CORS.md)**
- Enabling JSON:API module
- CORS configuration via services.yml
- Anonymous permissions
- Testing API endpoints
- Frontend integration
- Security considerations

### 🔧 Tools & Commands

**[Drush Guide](./DRUSH_GUIDE.md)**
- Critical rules (vendor drush + --uri)
- Command patterns
- Module management
- Content operations
- User management
- Configuration management
- Troubleshooting Drush issues

**[Quick Reference](./QUICK_REFERENCE.md)**
- Daily commands cheat sheet
- Setup & start
- Cache clearing
- Module management
- User management
- Testing endpoints
- Emergency procedures

### 🆘 Help & Troubleshooting

**[Troubleshooting](./TROUBLESHOOTING.md)**
- 8 critical issues documented
- "No input file specified" error
- Drush BadRequestHttpException
- Empty Drupal directory
- Old Drush version
- CORS configuration
- Content type creation
- Permissions
- Docker issues
- Database issues
- Recovery procedures

---

## 🎯 Quick Start Workflow

Follow these guides in order for new projects:

1. **[Lagoon Setup](./LAGOON_SETUP.md)** - Understand the architecture
2. **[Docker Configuration](./DOCKER_CONFIGURATION.md)** - Set up local environment
3. **[Drupal Installation](./DRUPAL_INSTALLATION.md)** - Install Drupal 10
4. **[JSON:API & CORS](./JSONAPI_CORS.md)** - Configure API
5. **[Drush Guide](./DRUSH_GUIDE.md)** - Learn command-line tools
6. **[Quick Reference](./QUICK_REFERENCE.md)** - Bookmark daily commands
7. **[Troubleshooting](./TROUBLESHOOTING.md)** - Keep open while working

---

## 🔑 Critical Concepts

### 1. WEBROOT Environment Variable

**Problem**: Drupal 10 uses `web/` subdirectory but Lagoon defaults to `/app/`.

**Solution**: Set `WEBROOT: web` in both php and nginx services.

```yaml
php:
  environment:
    WEBROOT: web

nginx:
  environment:
    WEBROOT: web
```

**Without this**: "No input file specified" error.

**Documented in**: [Docker Configuration](./DOCKER_CONFIGURATION.md), [Troubleshooting](./TROUBLESHOOTING.md)

---

### 2. Drush --uri Parameter

**Problem**: Drush cannot determine site path in Lagoon environments.

**Solution**: ALWAYS add `--uri='http://localhost:8080'` to ALL Drush commands.

```bash
# ✅ Correct
../vendor/bin/drush --uri='http://localhost:8080' COMMAND

# ❌ Wrong - fails with BadRequestHttpException
../vendor/bin/drush COMMAND
```

**Documented in**: [Drush Guide](./DRUSH_GUIDE.md), [Troubleshooting](./TROUBLESHOOTING.md)

---

### 3. Vendor Drush vs System Drush

**Problem**: System Drush (8.5.0) is too old for Drupal 10.

**Solution**: Always use vendor Drush (12.x).

```bash
# ✅ Correct - Drush 12.x
../vendor/bin/drush

# ❌ Wrong - Drush 8.5.0
drush
```

**Documented in**: [Drush Guide](./DRUSH_GUIDE.md), [Troubleshooting](./TROUBLESHOOTING.md)

---

### 4. CORS Configuration

**Problem**: CORS is NOT a module in Drupal 10.

**Solution**: Configure CORS via `services.yml` file.

```yaml
parameters:
  cors.config:
    enabled: true
    allowedOrigins: ['http://localhost:5173']
    allowedMethods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS']
```

**Documented in**: [JSON:API & CORS](./JSONAPI_CORS.md), [Troubleshooting](./TROUBLESHOOTING.md)

---

## 🛠️ Tech Stack Details

### Backend
- **Drupal 10.2+** - Latest stable release
- **PHP 8.3** - FPM for production, CLI for admin tasks
- **MariaDB 10.6+** - Database (Amazee.io standard, not MySQL)
- **nginx** - Web server
- **Composer** - Dependency management
- **Drush 12.x** - Command-line administration

### Docker Images
All from `uselagoon/*` namespace:
- `uselagoon/php-8.3-fpm:latest` - PHP processor
- `uselagoon/php-8.3-cli-drupal:latest` - Admin tasks
- `uselagoon/nginx-drupal:latest` - Web server
- `uselagoon/mariadb-drupal:latest` - Database

### Drupal Modules
Core modules used:
- `jsonapi` - RESTful API
- `serialization` - Data serialization
- `basic_auth` - Authentication (if needed)

---

## 📐 Architecture Diagram

```
┌─────────────────────────────────────────────┐
│             nginx (Port 8080)               │
│         Web Server / Proxy                  │
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

## 🔍 Common Use Cases

### Starting a New Project

1. Copy [Docker Configuration](./DOCKER_CONFIGURATION.md) template
2. Follow [Drupal Installation](./DRUPAL_INSTALLATION.md) steps
3. Configure [JSON:API & CORS](./JSONAPI_CORS.md)
4. Reference [Quick Reference](./QUICK_REFERENCE.md) for daily work

### Troubleshooting Issues

1. Check [Troubleshooting](./TROUBLESHOOTING.md) for known issues
2. Verify [Docker Configuration](./DOCKER_CONFIGURATION.md) is correct
3. Review [Drush Guide](./DRUSH_GUIDE.md) for command syntax
4. Test using [Quick Reference](./QUICK_REFERENCE.md) commands

### Daily Development

1. Use [Quick Reference](./QUICK_REFERENCE.md) for common commands
2. Refer to [Drush Guide](./DRUSH_GUIDE.md) for advanced operations
3. Keep [Troubleshooting](./TROUBLESHOOTING.md) bookmarked

---

## 🔗 Related Documentation

- [Main Documentation Index](../README.md) - Overview of all documentation
- [Client Portal Project](../projects/client-portal/) - Example implementation
- [Lagoon Official Docs](https://docs.lagoon.sh/) - Hosting platform details
- [Drupal 10 Docs](https://www.drupal.org/docs/10) - Drupal documentation

---

## 🤝 Using This Documentation

### For New Projects

Copy these files to your new project repository and customize as needed. The tech stack knowledge remains the same, only project-specific details change.

### For Existing Projects

Use as reference when troubleshooting or when team members need to understand the technical foundation.

### For Team Onboarding

New team members should read in this order:
1. [Lagoon Setup](./LAGOON_SETUP.md) - Understand architecture
2. [Docker Configuration](./DOCKER_CONFIGURATION.md) - Local setup
3. [Quick Reference](./QUICK_REFERENCE.md) - Daily commands
4. [Troubleshooting](./TROUBLESHOOTING.md) - Common issues

---

## 📋 Checklist for New Setups

When starting a new Drupal 10 + Lagoon project:

- [ ] Copy docker-compose.yml template
- [ ] Set WEBROOT environment variable
- [ ] Pull all Lagoon images
- [ ] Start Docker services
- [ ] Wait 30 seconds for MariaDB
- [ ] Install Drupal via Composer
- [ ] Install Drush as dev dependency
- [ ] Run site:install with --uri parameter
- [ ] Configure CORS in services.yml
- [ ] Enable jsonapi and serialization modules
- [ ] Add anonymous 'access content' permission
- [ ] Create content types
- [ ] Create sample content
- [ ] Test JSON:API endpoints
- [ ] Verify CORS headers
- [ ] Test frontend integration

---

**Last Updated**: November 10, 2025
**Stack Version**: Drupal 10 + PHP 8.3 + Lagoon
**Compatibility**: Amazee.io hosting platform
