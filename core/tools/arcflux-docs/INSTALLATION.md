---
scope: shared
---

# ArcFlux Installation Guide

> Get ArcFlux running on a new machine in minutes.

## Prerequisites

### Required

| Dependency | Minimum | Install |
|------------|---------|---------|
| Node.js | v18+ | `brew install node` |
| Git | 2.x | `brew install git` |
| jq | 1.6+ | `brew install jq` |
| awk | any | Pre-installed on macOS/Linux |

> **Note:** `jq` and `awk` are required for Claude Code hooks. `awk` is pre-installed on all Unix systems.

### Optional (by feature)

| Feature | Dependency | Install |
|---------|------------|---------|
| GitHub PRs | GitHub CLI | `brew install gh` |
| Linear sync | LINEAR_API_KEY | [Get API key](https://linear.app/settings/api) |
| Drupal dev | Docker Desktop | `brew install --cask docker` |
| SSH deploy | SSH keys | Configure `~/.ssh/config` |
| Supabase | Supabase CLI | `brew install supabase/tap/supabase` |

---

## Installation

### Option 1: Copy Directory (Recommended)

```bash
# On source machine - create portable copy:
cd /path/to/arcflux
npm install              # ensure dependencies installed
npm run build 2>/dev/null || true  # if build step exists

# Copy entire folder to new machine (USB, rsync, zip, etc.)
```

```bash
# On new machine:
cd /path/to/arcflux
npm link

# Verify
arcflux --version
```

### Option 2: Tarball

```bash
# On source machine:
cd /path/to/arcflux
npm pack
# Creates: arcflux-x.x.x.tgz (single file, ~50KB)
```

```bash
# On new machine:
npm install -g ./arcflux-x.x.x.tgz
```

### Option 3: Git Clone (if repo available)

```bash
git clone <your-arcflux-repo>
cd arcflux
npm install
npm link
```

---

## Verify Installation

```bash
# Check arcflux is available
arcflux --version

# Run diagnostics
arcflux doctor
```

Expected output:
```
═══ ArcFlux Doctor ═══

Runtime
────────────────────────────────────────
✓ Node.js v20.x.x

Version Control
────────────────────────────────────────
✓ Git 2.x.x

...
```

---

## Setup Integrations

### GitHub CLI

```bash
# Install
brew install gh

# Authenticate (opens browser)
gh auth login --web --git-protocol https

# Verify
gh auth status
```

### Linear

1. Go to [Linear Settings > API](https://linear.app/settings/api)
2. Create a new Personal API Key
3. Add to your shell profile:

```bash
# ~/.zshrc or ~/.bashrc
export LINEAR_API_KEY="lin_api_xxxxxxxxxxxxx"
```

4. Reload shell:
```bash
source ~/.zshrc
```

### Docker (for Drupal)

```bash
# Install Docker Desktop
brew install --cask docker

# Start Docker Desktop app
open -a Docker

# Verify
docker --version
docker compose version
```

---

## Quick Start

### New Project

```bash
mkdir my-project && cd my-project
git init
arcflux init --yes
arcflux status
```

### Existing Project

```bash
cd existing-project
arcflux adopt
arcflux status
```

### Drupal Project

```bash
mkdir my-drupal-site && cd my-drupal-site
arcflux drupal init --name my-drupal-site --drupal 11
# Wait for Docker setup...
arcflux drupal api setup
```

---

## Configuration

ArcFlux stores configuration in `.arcflux/config.json`:

```json
{
  "project": {
    "name": "my-project",
    "type": "generic"
  },
  "integrations": {
    "github": true,
    "linear": false
  },
  "drupal": {
    "api": {
      "baseUrl": "http://localhost:8080",
      "username": "admin",
      "password": "admin"
    }
  }
}
```

---

## Troubleshooting

### "command not found: arcflux"

```bash
# Check npm global bin is in PATH
npm config get prefix
# Add to PATH if needed:
export PATH="$(npm config get prefix)/bin:$PATH"
```

### GitHub CLI not authenticated

```bash
gh auth login --web
```

### Docker not running

```bash
# Start Docker Desktop
open -a Docker

# Or check status
docker info
```

### Linear API key not found

```bash
# Check if set
echo $LINEAR_API_KEY

# If empty, add to ~/.zshrc:
export LINEAR_API_KEY="your-key-here"
source ~/.zshrc
```

### jq not found (hook errors)

If you see "hook error" messages in Claude Code:

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Verify
jq --version
```

---

## Full Dependency Install (One-liner)

```bash
# Install all dependencies
brew install node git gh jq && \
brew install --cask docker && \
brew install supabase/tap/supabase

# Then link your copied arcflux:
cd /path/to/arcflux && npm link
```

---

## Environment Variables

| Variable | Purpose | Required |
|----------|---------|----------|
| `LINEAR_API_KEY` | Linear issue sync | For Linear integration |
| `GITHUB_TOKEN` | GitHub API (auto-set by gh) | For GitHub integration |
| `OPENAI_API_KEY` | AI features (future) | Optional |

---

## Next Steps

After installation:

1. Run `arcflux doctor` to verify setup
2. Run `arcflux init` in your project
3. Run `arcflux onboard` for guided setup
4. Check `arcflux --help` for all commands

For Claude Code integration, see [CLAUDE.md](../CLAUDE.md).
