---
scope: shared
---

# Arcanian Ops — Setup Guide

## Prerequisites

- Mac mini (M2/M4, 16GB+ RAM)
- macOS Sequoia or later
- Apple ID signed in
- Internet connection (ethernet preferred)
- Anthropic Claude Max 20x subscription ($200/mo)
- GitHub account

---

## Step 1: Mac Mini Base Setup (30 min)

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install essentials
brew install git node

# 3. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 4. Authenticate Claude Code
claude auth

# 5. Enable Remote Control globally (auto-enable for every session)
claude config set --global remoteControl true

# 6. Prevent sleep
caffeinate -d -i -s &

# 7. System Settings:
#    → General → Energy → "Wake for network access" = ON
#    → General → Energy → "Prevent automatic sleeping" = ON
#    → General → Sharing → Remote Login (SSH) = ON (fallback)
```

## Step 2: Start Server Mode (5 min)

```bash
# Start Claude Code in server mode — one process, 32 concurrent sessions
claude remote-control --name "Arcanian Hub" --spawn worktree --capacity 32

# Verify it's running
claude remote-control status
```

Team members connect by opening `claude.ai/code` and selecting "Arcanian Hub". No SSH needed for Claude sessions.

## Step 3: GitHub Setup (20 min)

```bash
# 1. Create GitHub org: "arcanian-ops" at github.com/organizations/new
# Choose Free plan, private repos

# 2. Enable security features on EVERY repo:
#    → Settings → Code security → Enable:
#      - Dependabot alerts
#      - Secret scanning
#      - Push protection
#    These are FREE and catch leaked tokens/secrets automatically.

# 3. Create repos
gh auth login
gh repo create arcanian-ops/ops-core --private
gh repo create arcanian-ops/client-diego --private
gh repo create arcanian-ops/client-mancsbazis --private
gh repo create arcanian-ops/client-deluxe --private
gh repo create arcanian-ops/arcanian-internal --private

# 4. Clone all repos
cd ~/Sites/_arcanian-ops
for repo in ops-core client-diego client-mancsbazis client-deluxe arcanian-internal; do
  gh repo clone arcanian-ops/$repo
done

# 5. Install GitHub Desktop on Mac mini + team MacBooks
# Download from https://desktop.github.com
```

## Step 4: Auto-Pull Cron (5 min)

Keep all repos synced when team pushes from GitHub Desktop:

```bash
# Create auto-pull script
cat > ~/Sites/_arcanian-ops/scripts/ops/auto-pull.sh << 'EOF'
#!/bin/bash
# Pull latest from all repos every 5 minutes
find ~/Sites/_arcanian-ops -maxdepth 2 -name ".git" -type d | while read gitdir; do
  repo=$(dirname "$gitdir")
  cd "$repo" && git pull --ff-only 2>/dev/null
done
EOF

chmod +x ~/Sites/_arcanian-ops/scripts/ops/auto-pull.sh

# Add to crontab (every 5 minutes)
(crontab -l 2>/dev/null; echo "*/5 * * * * ~/Sites/_arcanian-ops/scripts/ops/auto-pull.sh") | crontab -
```

## Step 5: Configure MCP Servers (30 min)

```bash
# Create .env file (NEVER commit this)
cat > ~/.env.arcanian << 'EOF'
TODOIST_API_TOKEN=
ASANA_ACCESS_TOKEN=
DATABOX_API_KEY=
GOOGLE_APPLICATION_CREDENTIALS=/path/to/sa.json
META_ACCESS_TOKEN=
AC_API_URL=
AC_API_KEY=
SHOPIFY_ACCESS_TOKEN=
SLACK_BOT_TOKEN=
FIREFLIES_API_KEY=
FIRECRAWL_API_KEY=
EOF

# Add MCP servers
claude mcp add todoist
claude mcp add asana
claude mcp add --transport http -s local databox https://mcp.databox.com/mcp
# Add others as needed per project
```

## Step 6: Pre-Commit Hook for PII (10 min)

**This is a safety net — not optional.**

```bash
# Create a global pre-commit hook
cat > ~/Sites/_arcanian-ops/scripts/ops/pre-commit-pii-check.sh << 'HOOK'
#!/bin/bash
# Block commits containing PII patterns

STAGED=$(git diff --cached --name-only)

# Check for .env files
echo "$STAGED" | grep -E '\.env' && echo "BLOCKED: .env file staged" && exit 1

# Check for API keys/tokens
git diff --cached | grep -iE '(api_key|api_token|access_token|secret_key|password)=' && \
  echo "BLOCKED: Possible API token in staged changes" && exit 1

# Check for email patterns in .md files
git diff --cached -- '*.md' | grep -E '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' && \
  echo "WARNING: Email address found in staged .md file — verify no PII" && exit 1

exit 0
HOOK

chmod +x ~/Sites/_arcanian-ops/scripts/ops/pre-commit-pii-check.sh

# Install in every repo
find ~/Sites/_arcanian-ops -maxdepth 2 -name ".git" -type d | while read gitdir; do
  cp ~/Sites/_arcanian-ops/scripts/ops/pre-commit-pii-check.sh "$gitdir/hooks/pre-commit"
done
```

## Step 7: Migrate Existing Files (2-3 hours)

See `CONSOLIDATION_PLAN.md` for detailed migration steps per project.

## Step 8: Team Setup (15 min per person)

On each team member's device:

1. Open `claude.ai/code` → connect to "Arcanian Hub"
2. Install GitHub Desktop → clone assigned repos
3. Install Typora (for editing .md files)
4. Read `DATA_RULES.md`

**That's it.** No SSH setup, no Tailscale, no Terminal knowledge needed for day-to-day work.

For fallback/advanced: install Tailscale + Termius (see REMOTE_CONTROL.md).

## Step 9: Verify Everything Works (15 min)

- [ ] `claude remote-control status` shows hub running with capacity
- [ ] Team member opens `claude.ai/code` → sees "Arcanian Hub"
- [ ] Connect to a project → `/tasks` works
- [ ] GitHub Desktop shows repos, push/pull works
- [ ] Pre-commit hook blocks `.env` files
- [ ] Auto-pull cron is running (`crontab -l`)
- [ ] `caffeinate` is running (`ps aux | grep caffeinate`)
- [ ] GitHub Dependabot + secret scanning enabled on all repos

---

## Ongoing: Adding a New Client

```bash
# Use /scaffold-project — it handles everything
cd ~/Sites/_arcanian-ops
/scaffold-project {clientname} "{Display Name}" client todoist László
```

This creates: directory, CLAUDE.md, TASKS.md, brand profile stubs, .gitignore, /tasks command, starter tasks.
