---
scope: shared
---

# ArcFlux User Guide

> Complete guide to using ArcFlux for AI-native development workflows.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Project Setup](#project-setup)
3. [Drupal Projects](#drupal-projects)
4. [Daily Workflow](#daily-workflow)
5. [Testing & Validation](#testing--validation)
6. [Batch Processing](#batch-processing)
7. [Commands Reference](#commands-reference)
8. [Integrations](#integrations)
9. [Troubleshooting](#troubleshooting)

---

## Quick Start

### New Generic Project

```bash
mkdir my-project && cd my-project
git init
arcflux init --yes
arcflux status
```

### New Drupal Project

```bash
mkdir my-drupal && cd my-drupal
arcflux drupal-init --name my-drupal --drupal 11
# Wait for Docker + Drupal setup (~5-10 min)
# Testing tools are installed automatically

arcflux status
arcflux validate --all  # Run validation
```

### Existing Project

```bash
cd existing-project
arcflux adopt               # or: arcflux init --yes
arcflux status
```

---

## Project Setup

### Step 1: Create Project Directory

```bash
mkdir my-project
cd my-project
git init
```

### Step 2: Initialize ArcFlux

```bash
arcflux init --yes
```

This creates:
```
my-project/
├── .arcflux/
│   ├── config.json         # Project configuration
│   ├── state.json          # Current state (active issue, phase)
│   └── memory/
│       ├── captains-log.md # Decision journal
│       ├── issues/         # Issue tracking
│       └── stacks/         # Technology knowledge
├── .claude/
│   └── commands/           # Claude Code slash commands
└── CLAUDE.md               # Claude Code bootstrap file
```

### Step 3: Verify Setup

```bash
arcflux status              # Show project state
arcflux doctor              # Check environment
```

---

## Drupal Projects

### One-Step Setup

For Drupal projects, `drupal-init` handles everything:

```bash
arcflux drupal-init --name my-site --drupal 11
```

This creates:
- Drupal 11 codebase
- Docker containers (cli, nginx, php, mariadb, redis, etc.)
- ArcFlux project tracking
- Testing tools (phpcs, phpstan, phpunit)
- PHPStan configuration

### Drupal Init Options

```bash
# Drupal 11 (default)
arcflux drupal-init --name my-site --drupal 11

# Drupal 10
arcflux drupal-init --name my-site --drupal 10

# Minimal profile (faster)
arcflux drupal-init --name my-site --profile minimal

# Skip site installation
arcflux drupal-init --name my-site --skip-install
```

### What's Installed Automatically

`drupal-init` installs these tools in Docker:

| Tool | Purpose |
|------|---------|
| **drupal/coder** | Drupal coding standards (phpcs) |
| **phpstan/phpstan** | PHP static analyzer |
| **mglaman/phpstan-drupal** | Drupal-specific PHPStan rules |
| **phpunit/phpunit** | Unit testing framework |
| **config_split** | Multi-environment configuration |
| **basic_auth** | JSON:API authentication |

### After Drupal Init

```bash
# Verify everything works
arcflux docker status
arcflux drupal api status

# Run validation (testing tools are pre-installed)
arcflux validate --all
```

### Drupal Commands

| Command | Description |
|---------|-------------|
| `arcflux drupal-init` | Create new Drupal project |
| `arcflux drupal api setup` | Enable JSON:API prerequisites |
| `arcflux drupal api status` | Test API connectivity |
| `arcflux drupal content list <type>` | List content |
| `arcflux drupal content create <type>` | Create content |
| `arcflux drupal config list` | List configuration |
| `arcflux drupal config export` | Export config |
| `arcflux drupal config split list` | List config splits |
| `arcflux drush <cmd>` | Run drush commands |
| `arcflux docker status` | Check Docker containers |

---

## Daily Workflow

### Starting Work

```bash
# 1. Check current state
arcflux status

# 2. Start an issue
arcflux start AF-001              # Existing issue
arcflux start AF-002 --create     # Create new issue

# 3. Work through phases
arcflux phase                     # Show current phase
arcflux phase next --yes          # Advance to next phase
```

### The 7 Phases

```
explore → plan → architect → implement → review → test → document
```

| Phase | What to Do |
|-------|------------|
| **explore** | Search codebase, understand requirements |
| **plan** | Break down into tasks |
| **architect** | Design the solution |
| **implement** | Write the code |
| **review** | Review changes, run validation |
| **test** | Run tests, add coverage |
| **document** | Update docs |

### Completing Work

```bash
# Validate changes
arcflux validate --all

# Commit
arcflux commit

# Mark ready for PR
arcflux ready

# Complete issue
arcflux phase complete --yes
```

---

## Testing & Validation

### Quick Start

```bash
# Basic validation (state checks only)
arcflux validate

# Full validation with all quality checks
arcflux validate --all

# JSON output for CI/CD
arcflux validate --all --json
```

### What Gets Validated

#### State Checks (Always Run)

| Check | Description |
|-------|-------------|
| Active Issue | Verifies an issue is being worked on |
| Branch Match | Confirms branch name contains issue key |
| Phase | Validates current workflow phase |

#### Stack-Specific Checks (With --all)

**Drupal:**
- PHP CodeSniffer (Drupal coding standards)
- PHPStan (static analysis)
- PHPUnit (unit tests)
- Drush status (health check)

**Node.js/TypeScript:**
- TypeScript compilation
- ESLint
- npm test
- npm audit (security)

### Docker-Based Validation

For Docker projects (Drupal), validation automatically runs inside containers:

```bash
# 1. Ensure containers are running
arcflux docker up

# 2. Run validation (auto-detects Docker)
arcflux validate --all
```

Example output:
```
═══ ArcFlux Validation ═══

ℹ Detected stacks: drupal
ℹ Using Docker container: cli

Stack Validation
────────────────────────────────────────
Drupal Coding Standards: ✓ passed
PHPStan Analysis:        ✓ passed
PHPUnit Tests:           ✓ passed (42 tests)
Drupal Status:           ✓ Drupal 11.3.2

Summary: 4 passed, 0 failed, 0 skipped

✓ VALIDATION PASSED
```

### Running Tests Manually

```bash
# Inside Docker container
docker compose exec cli vendor/bin/phpcs --standard=Drupal web/modules/custom
docker compose exec cli vendor/bin/phpstan analyse
docker compose exec cli vendor/bin/phpunit

# Using ArcFlux
arcflux validate --all
```

### Installing Testing Tools (Existing Projects)

For projects not created with `drupal-init`:

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

---

## Batch Processing

Process multiple issues automatically without human intervention.

### Quick Start

```bash
# 1. Start Docker (for Drupal projects)
arcflux docker up

# 2. Queue issues
arcflux batch AF-001 AF-002 AF-003

# 3. In Claude Code, process
/arcflux-batch

# 4. Check status
arcflux batch --status
```

### What Happens

For each issue, batch processing:
1. Starts the issue (`arcflux start`)
2. Executes all 7 phases
3. Runs validation (`arcflux validate --all`)
4. Commits if validation passes
5. Moves to next issue

### Permission Prediction

Predict required permissions before batch:

```bash
# Analyze issues and save permissions
arcflux batch AF-001 AF-002 --save-permissions

# Skip analysis (faster)
arcflux batch AF-001 AF-002 --skip-preflight
```

### Options

| Option | Description |
|--------|-------------|
| `--on-failure skip` | Skip failed issues, continue |
| `--save-permissions` | Save predicted permissions |
| `--skip-preflight` | Skip permission analysis |
| `--from-file` | Load issues from file |
| `--resume` | Resume interrupted batch |
| `--status` | Show batch status |
| `--clear` | Clear batch state |

---

## Commands Reference

### Core Commands

| Command | Description |
|---------|-------------|
| `arcflux init` | Initialize new ArcFlux project |
| `arcflux adopt` | Add ArcFlux to existing project |
| `arcflux status` | Show current state |
| `arcflux doctor` | Environment diagnostics |
| `arcflux start <issue>` | Start work on issue |
| `arcflux phase` | Show/manage phases |
| `arcflux validate` | Run validation checks |
| `arcflux commit` | Create commit |
| `arcflux ready` | Prepare for PR |

### Validation Commands

| Command | Description |
|---------|-------------|
| `arcflux validate` | Basic state validation |
| `arcflux validate --all` | Full stack validation |
| `arcflux validate --json` | JSON output for CI |
| `arcflux preflight` | Pre-flight checks |
| `arcflux preflight --issue AF-001` | Permission prediction |

### Drupal Commands

| Command | Description |
|---------|-------------|
| `arcflux drupal-init` | Create Drupal project |
| `arcflux drupal api <cmd>` | API management |
| `arcflux drupal content <cmd>` | Content CRUD |
| `arcflux drupal config <cmd>` | Config management |
| `arcflux drupal cache clear` | Clear caches |
| `arcflux drush <cmd>` | Run drush |
| `arcflux docker <cmd>` | Docker management |

### Batch Commands

| Command | Description |
|---------|-------------|
| `arcflux batch <issues>` | Create batch queue |
| `arcflux batch --status` | Show batch status |
| `arcflux batch --resume` | Resume batch |
| `arcflux batch --clear` | Clear batch state |

---

## Integrations

### GitHub CLI

```bash
# Install
brew install gh
gh auth login

# Use
arcflux ready --pr           # Create PR
```

### Linear

```bash
# Setup
export LINEAR_API_KEY="lin_api_xxxxx"

# Use
arcflux sync                 # Sync with Linear
arcflux start LIN-123        # Start Linear issue
```

### Docker

Required for Drupal projects. Install Docker Desktop:

```bash
brew install --cask docker
```

---

## Troubleshooting

### "command not found: arcflux"

```bash
# Check npm global bin is in PATH
npm config get prefix
export PATH="$(npm config get prefix)/bin:$PATH"
```

### "hook error" in Claude Code

Claude Code hooks require `jq` for JSON parsing:

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Verify
jq --version
```

### "Unknown subcommand: init" (for drupal)

Use hyphen, not space:
```bash
# Wrong
arcflux drupal init

# Correct
arcflux drupal-init
```

### Docker containers not starting

```bash
# Check Docker is running
docker info

# Check ports
arcflux docker status

# Restart containers
arcflux docker down
arcflux docker up
```

### Validation skips tests

Ensure testing tools are installed:

```bash
# New projects - use drupal-init (auto-installs)
arcflux drupal-init --name my-site

# Existing projects - install manually
docker compose exec cli composer require --dev drupal/coder phpstan/phpstan phpunit/phpunit
```

### "Not installed in container"

Testing tools aren't in Docker. Install them:
```bash
docker compose exec cli composer require --dev \
  drupal/coder phpstan/phpstan mglaman/phpstan-drupal phpunit/phpunit
```

### JSON:API 403 Forbidden

```bash
# Run setup to enable basic_auth
arcflux drupal api setup
```

---

## Cheat Sheet

```bash
# === NEW DRUPAL PROJECT ===
mkdir my-site && cd my-site
arcflux drupal-init --name my-site --drupal 11
arcflux validate --all  # Testing tools ready

# === DAILY WORKFLOW ===
arcflux status
arcflux start AF-001
# ... do work ...
arcflux validate --all
arcflux commit
arcflux phase complete --yes

# === BATCH PROCESSING ===
arcflux docker up
arcflux batch AF-001 AF-002 --save-permissions
# In Claude Code: /arcflux-batch
arcflux batch --status

# === DRUPAL OPERATIONS ===
arcflux drupal content list node/article
arcflux drupal config export
arcflux drush cr
arcflux docker status

# === TESTING ===
arcflux validate --all
docker compose exec cli vendor/bin/phpcs --standard=Drupal web/modules/custom
docker compose exec cli vendor/bin/phpstan analyse
docker compose exec cli vendor/bin/phpunit
```

---

## More Documentation

- [Testing Guide](TESTING.md) - Comprehensive testing documentation
- [Batch Command](batch-command.md) - Batch processing details
- [Validate Command](validate-command.md) - Validation details
- [Preflight Command](preflight-command.md) - Permission prediction
- [Installation](INSTALLATION.md) - Setup on new computers

---

## Getting Help

```bash
arcflux --help
arcflux <command> --help
arcflux doctor
```

For issues: https://github.com/your-org/arcflux/issues
