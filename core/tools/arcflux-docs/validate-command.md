---
scope: shared
---

# ArcFlux Validate Command

Run validation checks before committing changes.

## Overview

The validate command runs stack-aware validation checks to ensure code quality before committing. It automatically detects your project's technology stack and runs appropriate checks. For Docker-based projects, validation runs inside containers.

## Quick Start

```bash
# Basic validation (state checks only)
arcflux validate

# Full validation with stack checks
arcflux validate --all

# JSON output for CI
arcflux validate --json
```

## Options

| Option | Description |
|--------|-------------|
| `--all`, `-a` | Run all stack validation checks (tests, lint, etc.) |
| `--quality`, `-q` | Same as --all |
| `--json` | Output as JSON (for CI/scripting) |
| `--force`, `-f` | Continue even with warnings |
| `--threshold <n>` | Confidence threshold (default 0.8) |

## What Gets Validated

### State Checks (Always Run)

| Check | Description |
|-------|-------------|
| Active Issue | Verifies an issue is being worked on |
| Branch Match | Confirms branch name contains issue key |
| Phase | Validates current workflow phase |

### Stack Checks (With --all)

#### Drupal
- `phpcs --standard=Drupal` - Coding standards
- `phpstan analyse` - Static analysis
- `phpunit` - Unit tests
- `drush status` - Drupal health check (Docker only)

#### TypeScript
- `tsc --noEmit` - TypeScript compilation
- ESLint (if configured)

#### Node.js
- `npm test` - Run test suite
- `npm audit` - Security vulnerability check

#### React
- `npm run build` - Build verification

#### Python
- `pytest` - Run test suite

#### Docker
- `hadolint` - Dockerfile lint

---

## Docker Support

For Docker-based projects (especially Drupal), validation automatically runs commands inside containers.

### How It Works

1. **Detection**: Looks for `docker-compose.yml` or `compose.yaml`
2. **Container Discovery**: Finds PHP container (cli, php, web, drupal, or app)
3. **Execution**: Runs validation commands via `docker compose exec`
4. **Fallback**: If tools not installed, marks as "skipped" (not failed)

### Requirements

- Docker containers must be running
- PHP tools installed in container (auto-installed by `drupal-init`)

### Starting Containers

```bash
arcflux docker up
# or
docker compose up -d
```

### Example with Docker

```bash
# Start containers
arcflux docker up

# Run validation (auto-detects Docker)
arcflux validate --all
```

Output:
```
═══ ArcFlux Validation ═══

ℹ Detected stacks: drupal
ℹ Using Docker container: cli

State Checks
────────────────────────────────────────
Active Issue: ✓ AF-001: Add feature
Branch Match: ✓ Branch matches: af-001-add-feature
Phase:        ✓ Current phase: implement

Stack Validation
────────────────────────────────────────
Drupal Coding Standards: ✓ passed
PHPStan Analysis:        ✓ passed
PHPUnit Tests:           ✓ passed (42 tests)
Drupal Status:           ✓ Drupal 11.3.2

Summary: 4 passed, 0 failed, 0 skipped

✓ VALIDATION PASSED
```

---

## Testing Tools Installation

### New Projects (Automatic)

When using `arcflux drupal-init`, all testing tools are installed automatically:

```bash
arcflux drupal-init --name my-site --drupal 11
# Installs: drupal/coder, phpstan, mglaman/phpstan-drupal, phpunit
```

### Existing Projects (Manual)

For existing Docker projects:

```bash
# Start containers
docker compose up -d

# Install testing tools
docker compose exec cli composer require --dev \
  drupal/coder \
  phpstan/phpstan \
  mglaman/phpstan-drupal \
  phpstan/extension-installer \
  phpunit/phpunit

# Create PHPStan config
cat > phpstan.neon << 'EOF'
includes:
  - vendor/mglaman/phpstan-drupal/extension.neon

parameters:
  level: 2
  paths:
    - web/modules/custom
    - web/themes/custom
EOF
```

For local projects:

```bash
composer require --dev drupal/coder phpstan/phpstan mglaman/phpstan-drupal phpunit/phpunit
```

---

## Batch Processing

When using batch processing, validation runs automatically for each issue:

```bash
# Start Docker first
arcflux docker up

# Create and process batch
arcflux batch AF-001 AF-002 AF-003
# In Claude Code: /arcflux-batch
```

The batch calls `arcflux validate --all` before committing each issue.

---

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 2 | Critical failures |

## CI/CD Usage

```bash
# In CI pipeline
arcflux validate --all --json | jq '.valid'
if [ $? -ne 0 ]; then
  echo "Validation failed"
  exit 1
fi
```

---

## Troubleshooting

### "phpcs not available - skipping"

**New projects**: Use `arcflux drupal-init` which installs all testing tools automatically.

**Existing projects**: Install PHP tools manually:

```bash
# Docker projects
docker compose exec cli composer require --dev \
  drupal/coder phpstan/phpstan mglaman/phpstan-drupal phpunit/phpunit

# Local projects
composer require --dev drupal/coder phpstan/phpstan phpunit/phpunit
```

### "Docker containers running but no PHP container found"

The validation looks for containers named: cli, php, web, drupal, app

Check your container names:
```bash
docker compose ps
```

### "Not installed in container"

Tools are not installed in the Docker container. Install them:
```bash
docker compose exec cli composer require --dev drupal/coder phpstan/phpstan phpunit/phpunit
```

### Containers not running

Start containers before validation:
```bash
arcflux docker up
```

### Tests not running in batch mode

1. Start Docker containers before batch: `arcflux docker up`
2. Ensure testing tools are installed in container
3. Batch calls `arcflux validate --all` automatically

---

## Related Commands

- `arcflux commit` - Commit changes (runs validation first)
- `arcflux ready` - Prepare for PR
- `arcflux doctor` - Environment diagnostics
- `arcflux docker status` - Check container status
- `arcflux batch` - Batch processing
- `arcflux preflight` - Permission prediction
