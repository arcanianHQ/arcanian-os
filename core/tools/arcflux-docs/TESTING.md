---
scope: shared
---

# ArcFlux Testing & Validation Guide

Complete guide to testing and validation in ArcFlux projects.

## Overview

ArcFlux provides stack-aware validation that automatically detects your project type and runs appropriate quality checks. For Docker-based projects (especially Drupal), validation runs inside containers.

## Quick Start

```bash
# Basic validation (state checks only)
arcflux validate

# Full validation with all quality checks
arcflux validate --all

# JSON output for CI/CD
arcflux validate --all --json
```

## How Validation Works

### 1. State Checks (Always Run)

| Check | Description |
|-------|-------------|
| Active Issue | Verifies an issue is being worked on |
| Branch Match | Confirms branch name contains issue key |
| Phase | Validates current workflow phase |

### 2. Stack Detection

ArcFlux auto-detects your stack from project files:

| File | Detected Stack |
|------|----------------|
| `composer.json` | drupal |
| `package.json` | nodejs |
| `tsconfig.json` | typescript |
| `Dockerfile` | docker |
| `requirements.txt` | python |

### 3. Stack-Specific Checks

Each stack has tailored quality checks:

**Drupal:**
- PHP CodeSniffer (Drupal coding standards)
- PHPStan (static analysis)
- PHPUnit (unit tests)
- Drush status (health check)

**Node.js/TypeScript:**
- TypeScript compilation (`tsc --noEmit`)
- ESLint
- npm test
- npm audit (security)

**Python:**
- pytest

**Docker:**
- hadolint (Dockerfile lint)

---

## Docker-Based Drupal Projects

### Automatic Docker Detection

When ArcFlux detects a Docker project, it:

1. Looks for `docker-compose.yml` or `compose.yaml`
2. Finds the PHP container (cli, php, web, drupal, or app)
3. Runs all validation commands inside the container

### Requirements

1. **Docker containers must be running:**
   ```bash
   arcflux docker up
   # or
   docker compose up -d
   ```

2. **Testing tools must be installed in container:**
   - `drupal/coder` (phpcs)
   - `phpstan/phpstan` + `mglaman/phpstan-drupal`
   - `phpunit/phpunit`

### New Projects (Auto-Installed)

When you use `arcflux drupal-init`, all testing tools are installed automatically:

```bash
arcflux drupal-init --name my-site --drupal 11
# Tools are installed during setup

arcflux validate --all  # Ready to use
```

### Existing Projects (Manual Install)

For existing Docker projects, install tools manually:

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

# Run validation
arcflux validate --all
```

### Running Individual Tools

```bash
# PHP CodeSniffer
docker compose exec cli vendor/bin/phpcs \
  --standard=Drupal \
  --extensions=php,module,inc,install,theme \
  web/modules/custom

# PHPStan
docker compose exec cli vendor/bin/phpstan analyse

# PHPUnit
docker compose exec cli vendor/bin/phpunit

# Drush status
docker compose exec cli ./vendor/bin/drush status
```

---

## Batch Processing with Validation

When running batch processing, validation runs automatically for each issue.

### Workflow

```bash
# 1. Start Docker containers
arcflux docker up

# 2. Create batch queue
arcflux batch AF-001 AF-002 AF-003

# 3. In Claude Code, process (validation runs automatically)
/arcflux-batch
```

### What Happens

For each issue, the batch:
1. Runs `arcflux start <issue>`
2. Executes all workflow phases
3. Runs `arcflux validate --all` (inside Docker)
4. If validation passes, runs `arcflux commit --yes`
5. Marks issue complete

### Skipped Tools

If a tool isn't installed, it's marked as "skipped" (not failed):

```
Stack Validation
────────────────────────────────────────
Drupal Coding Standards: ○ skipped (Not installed in container)
PHPStan Analysis:        ○ skipped (Not installed in container)
PHPUnit Tests:           ○ skipped (Not installed in container)
Drupal Status:           ✓ passed (Drupal 11.3.2)

Summary: 1 passed, 0 failed, 3 skipped

✓ VALIDATION PASSED
```

---

## Permission Prediction

Before running batch processing, predict what permissions Claude Code will need.

### Single Issue

```bash
arcflux preflight --issue AF-001
```

### Multiple Issues

```bash
arcflux preflight --issues AF-001,AF-002,AF-003
```

### Save Permissions

Auto-save to `.claude/settings.json`:

```bash
arcflux preflight --issues AF-001,AF-002 --save
```

### Batch with Preflight

Batch command includes automatic preflight:

```bash
# Analyze and create batch
arcflux batch AF-001 AF-002 --save-permissions

# Skip analysis (faster)
arcflux batch AF-001 AF-002 --skip-preflight
```

---

## Validation Options

```bash
arcflux validate [options]
```

| Option | Description |
|--------|-------------|
| `--all` | Run all stack validation checks |
| `--quality` | Same as --all |
| `--json` | Output as JSON (for CI/scripting) |
| `--force` | Continue even with warnings |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 2 | Critical failures |

---

## Example Output

### Passing Validation (Docker)

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

### Failed Validation

```
═══ ArcFlux Validation ═══

Stack Validation
────────────────────────────────────────
Drupal Coding Standards: ⚠ 5 issue(s)
PHPStan Analysis:        ✓ passed
PHPUnit Tests:           ✗ Test failures
Drupal Status:           ✓ Drupal 11.3.2

Summary: 2 passed, 2 failed, 0 skipped

✗ VALIDATION FAILED

Failed checks:
  - Drupal Coding Standards: 5 issue(s)
  - PHPUnit Tests: Test failures
```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Validate
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Start Docker
        run: docker compose up -d

      - name: Wait for containers
        run: sleep 10

      - name: Install ArcFlux
        run: npm install -g arcflux

      - name: Run validation
        run: arcflux validate --all --json
```

### Exit Code Check

```bash
arcflux validate --all --json
if [ $? -ne 0 ]; then
  echo "Validation failed"
  exit 1
fi
```

---

## Troubleshooting

### "Docker containers running but no PHP container found"

The validation looks for containers named: cli, php, web, drupal, app

Check your container names:
```bash
docker compose ps
```

### "Not installed in container"

Tools need to be installed in Docker:
```bash
docker compose exec cli composer require --dev drupal/coder phpstan/phpstan phpunit/phpunit
```

### Containers not running

Start containers before validation:
```bash
arcflux docker up
# or
docker compose up -d
```

### Tests timeout

Increase timeout for long-running tests:
- PHPUnit: 5 minute timeout
- PHPStan: 2 minute timeout
- phpcs: 1 minute timeout

---

## Related Commands

- `arcflux validate` - Run validation
- `arcflux doctor` - Environment diagnostics
- `arcflux docker status` - Check container status
- `arcflux preflight` - Permission prediction
- `arcflux batch` - Batch processing

---

## Summary

| Project Type | Validation Location | Auto-Install |
|--------------|--------------------| -------------|
| New Drupal (drupal-init) | Docker container | Yes |
| Existing Drupal + Docker | Docker container | No (manual) |
| Local Drupal | Host machine | No (manual) |
| Node.js/TypeScript | Host machine | No |
| Python | Host machine | No |
