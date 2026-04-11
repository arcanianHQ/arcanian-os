---
scope: shared
name: update
description: Check for and install Arcanian OS updates from GitHub — preserves all your client data and knowledge
allowed-tools: Bash, Read
argument-hint: "Run without arguments to check + update. Add 'check' to only check without updating."
---

# /update — Arcanian OS Update

## Purpose
Safely update the Arcanian OS system (skills, agents, SOPs, guardrails) without touching your client data, tasks, contacts, or any knowledge you've built.

**What gets updated:** `core/`, `CLAUDE.md`, `.claude/commands/`, `.claude/settings.json`, `docs/`, `README.md`, `CHANGELOG.md`

**What is NEVER touched:** `clients/`, `.mcp.json`, any file you created or modified

## Behavior

### Step 1 — Safety check
Run:
```bash
git rev-parse --is-inside-work-tree 2>/dev/null
```
If not a git repo → show:
```
✗ This doesn't look like a git-cloned Arcanian OS installation.
  If you downloaded a ZIP, you'll need to re-install by cloning:
  git clone https://github.com/arcanianHQ/arcanian-os.git
  Then copy your clients/ folder into the new clone.
```
Stop.

Check branch:
```bash
git branch --show-current
```
If not `main` → show:
```
⚠ You're on branch '{branch}', not 'main'. Switch to main first:
  git checkout main
```
Stop.

### Step 2 — Check current version
Read the first line of `CHANGELOG.md` to get the current version number.

### Step 3 — Fetch latest from GitHub
Run:
```bash
git fetch origin main --quiet 2>&1
```
If fails → "Can't reach GitHub. Check your internet connection." Stop.

### Step 4 — Compare versions
Run:
```bash
git rev-list HEAD..origin/main --count
```

If 0:
```
✓ Arcanian OS is up to date (v{current_version})
  System: {count files in core/skills/} skills, {count files in core/agents/} agents
```
Stop.

If >0 → updates available. Show what changed in system files only:
```bash
git diff HEAD..origin/main --stat -- core/ CLAUDE.md .claude/ docs/ README.md CHANGELOG.md
```

Show:
```
Updates available ({count} commits)

System changes:
{diff stat for core/ CLAUDE.md .claude/ docs/ only}

Your data (SAFE — will not be changed):
  clients/     ✓ untouched
  .mcp.json    ✓ untouched
```

**If the user passed "check" as argument, stop here.**

### Step 5 — Check for conflicts
Run:
```bash
git diff --name-only HEAD -- core/ CLAUDE.md .claude/commands/ .claude/settings.json
```

If user modified system files (rare but possible):
```
⚠ You've modified these system files locally:
{list}

These will be updated. Your changes in these files will be merged if possible.
If a merge conflict occurs, the system version wins (your client data is safe).

Continue? (yes/no)
```
Wait for confirmation.

### Step 6 — Pull updates
Run:
```bash
git stash --include-untracked --quiet 2>/dev/null
git pull origin main --ff-only 2>&1
PULL_RESULT=$?
git stash pop --quiet 2>/dev/null
```

The stash/pop ensures any uncommitted user files (new client data, inbox files) are preserved.

If pull succeeds:
```
✓ Updated from v{old} to v{new}

What's new:
{read the CHANGELOG.md diff — show only the new entries, max 20 lines}

⚠ Restart Claude Code to load the new version:
  Type /exit, then start claude again.
```

If pull fails:
```
⚠ Automatic update failed. This usually means your local copy has diverged.

Safe fix (keeps all your client data):
  1. Back up your clients/ folder
  2. Run: git reset --hard origin/main
  3. Your clients/ folder is untouched (it's gitignored or unmodified)

Or contact support if you need help.
```

### Step 7 — Post-update checks
After successful pull:

Check if CLAUDE.md changed:
```bash
git diff HEAD~{count}..HEAD --name-only | grep -c CLAUDE.md
```
If yes → "⚠ CLAUDE.md updated — restart required for new instructions."

Check if settings.json changed:
```bash
git diff HEAD~{count}..HEAD --name-only | grep -c settings.json
```
If yes → "⚠ Hook settings updated — restart required for new hooks."

Check if new skills were added:
```bash
git diff HEAD~{count}..HEAD --name-only -- core/skills/ | head -10
```
If yes → "New skills available: {list skill names}"

## Output Format

Keep it simple. No git jargon. No technical details unless something goes wrong.

- ✓ = done, everything is fine
- ⚠ = needs a restart or attention
- ✗ = something went wrong, here's what to do

## What is NEVER modified by /update

| Your data | Why it's safe |
|-----------|---------------|
| `clients/*` | Your client projects — configs, tasks, contacts, data, audit results |
| `.mcp.json` | Your Databox/Todoist connection (has API keys) |
| `demo-data/` | Your local demo data modifications |
| Any file you created | Git only updates files that exist in the remote repo |
| Uncommitted files | Stashed before pull, restored after |
