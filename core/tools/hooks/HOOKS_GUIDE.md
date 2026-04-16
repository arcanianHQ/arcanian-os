---
scope: shared
---

# Claude Code Hooks — Ops System Guide

## What Are Hooks?

Claude Code hooks are automated actions that fire at specific points in a session. They let us enforce project safety, automate logging, and reduce manual setup — without relying on discipline.

Four hook types are available:

| Hook | When it fires | Our use case |
|---|---|---|
| `session-start` | When Claude Code session begins | Auto-run `/preflight` |
| `pre-tool-use` | Before any tool executes | Block dangerous file operations |
| `post-tool-use` | After a tool completes | Log significant changes |
| `user-prompt-submit` | When user sends a message | Warn on PII/secrets in prompts |

## Hook 1: session-start — Auto Preflight

**Purpose:** Load project context automatically so every session starts informed.

**Behavior:**
- Runs `/preflight` skill (reads CLAUDE.md, TASKS.md, CAPTAINS_LOG.md, MCP status)
- No user action needed — context loads on session open
- If no CLAUDE.md found, warns instead of failing

**Template:** `templates/session-start-preflight.js`

## Hook 2: pre-tool-use — Directory Guard

**Purpose:** Prevent accidental file writes outside the current project directory.

**Behavior:**
- Intercepts `Write`, `Edit`, `Bash` (write operations) tool calls
- Checks if the target path is within the current project root
- Allows reads anywhere (cross-project reference is fine)
- Allows writes to `/tmp/` (scratch space)
- Blocks and warns if a write targets another client's directory
- Exception list: `core/` (shared resources), `/tmp/`, current project root

**Template:** `templates/pre-tool-use-directory-guard.js`

**Example block:**
```
⚠ Blocked: attempted write to /home/user/projects/other-client/TASKS.md
   Current project: example-saas
   Use the other-client project session to modify those files.
```

## Hook 3: post-tool-use — Auto Log

**Purpose:** Keep CAPTAINS_LOG.md updated without manual entries.

**Behavior:**
- Fires after `Write`, `Edit`, `Bash` (file-modifying) tool calls
- Detects significant changes:
  - New file created → log "Created {filename}"
  - TASKS.md modified → log "Tasks updated"
  - brand/ file modified → log "Brand profile updated: {filename}"
  - findings/ or recommendations/ modified → log "Finding/recommendation updated"
- Appends one-line entries under today's date in CAPTAINS_LOG.md
- Batches entries — does not create a new date header if one exists for today
- Ignores trivial changes (whitespace, .gitkeep, temp files)

**Template:** `templates/post-tool-use-auto-log.js`

**Example log entry:**
```markdown
## 2026-03-23
- Created brand/VOICE.md
- Tasks updated (3 new P1 tasks)
- Finding added: FND-012_consent-mode-v2-missing.md
```

## Hook 4: post-tool-use — Multi-Domain Analysis Guard

**Purpose:** Prevent cross-domain data contamination in analysis files for multi-domain clients.

**Behavior:**
- Fires after `Write`, `Edit` on `.md` files
- Detects if the project is multi-domain (via DOMAIN_CHANNEL_MAP.md or CLIENT_CONFIG.md domain count)
- If multi-domain and no DOMAIN_CHANNEL_MAP.md exists: warns to create it
- If the written file is an analysis file (contains ROAS, revenue, spend, etc.):
  - Checks for domain attribution (mentions specific domains)
  - Flags account-level language without domain filtering
  - Checks for DOMAIN_CHANNEL_MAP.md reference
  - Flags shared data source queries without campaign-level filtering
- Skips: non-analysis files, single-domain clients, infrastructure files (TASKS, CONTACTS, etc.)
- Does NOT block — only warns

**Template:** `templates/post-tool-use-multi-domain-check.sh`

**Example warning:**
```
⚠ MULTI-DOMAIN ANALYSIS GUARD — BUENOSPA_ROAS_ANALYSIS.md is an analysis file for a multi-domain client (10 domains):
  - No domain attribution found — metrics may be mixing data across domains
  - Found account-level language — verify these aren't being presented as single-domain metrics
  - No reference to DOMAIN_CHANNEL_MAP.md — was the map loaded before querying?
  The domain question comes BEFORE the data question.
  Load DOMAIN_CHANNEL_MAP.md and filter all metrics by domain.
  Rule: core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md
```

## Hook 5: user-prompt-submit — PII/Secrets Warning

**Purpose:** Catch accidental PII or secrets before they enter the conversation.

**Behavior:**
- Scans the user's prompt text before it is processed
- Checks for patterns:
  - API keys: `sk-`, `api_key=`, `Bearer `, `token=`
  - Passwords: `password:`, `passwd=`, `secret=`
  - Hungarian personal ID: `[0-9]{6}[A-Z]{2}` pattern
  - Credit card numbers: 16-digit sequences
  - .env file contents pasted directly
- If detected: shows warning and asks for confirmation
- Does NOT block — the user decides whether to proceed
- Never logs the flagged content itself

**Template:** `templates/user-prompt-submit-pii-guard.js`

## Hook 6: user-prompt-submit — Date Context Injection

**Purpose:** Prevent day-of-week miscalculation and ensure accurate date awareness in all date-related prompts.

**Behavior:**
- Scans the user's prompt for date-related keywords (EN + HU):
  - English: today, tomorrow, yesterday, day names, this/next/last week, schedule, due, overdue, deadline, day-start, day-end
  - Hungarian: ma, holnap, tegnap, day names (hétfő–vasárnap), ezen a héten, jövő héten, határidő, mikor, milyen nap
- If detected: injects accurate date context via stderr (date, day of week, week number, quarter, working day status)
- Uses canonical script: `core/scripts/ops/date-context.sh`
- Does NOT block — only injects context

**Template:** `templates/user-prompt-submit-date-context.sh`

**Example output:**
```
📅 2026-04-13 (Monday) | W16 | Q2 | Working day: yes
```

## Setup Instructions

### 1. Create hook templates

Hook templates live in:
```
core/tools/hooks/templates/
  session-start-preflight.js
  pre-tool-use-directory-guard.js
  post-tool-use-auto-log.js
  user-prompt-submit-pii-guard.js
```

### 2. Configure in settings.json

Add hooks to the project's `.claude/settings.json`:

```json
{
  "hooks": {
    "session-start": [
      {
        "command": "node core/tools/hooks/templates/session-start-preflight.js",
        "description": "Auto-run /preflight at session start"
      }
    ],
    "pre-tool-use": [
      {
        "command": "node core/tools/hooks/templates/pre-tool-use-directory-guard.js",
        "description": "Block writes outside project directory"
      }
    ],
    "post-tool-use": [
      {
        "command": "node core/tools/hooks/templates/post-tool-use-auto-log.js",
        "description": "Auto-log significant changes to CAPTAINS_LOG"
      }
    ],
    "user-prompt-submit": [
      {
        "command": "node core/tools/hooks/templates/user-prompt-submit-pii-guard.js",
        "description": "Warn on PII/secrets in prompts"
      }
    ]
  }
}
```

### 3. Per-project activation

Each client project can opt in to hooks by adding to their own `.claude/settings.json`:

```json
{
  "hooks": {
    "session-start": [
      {
        "command": "node ../../core/tools/hooks/templates/session-start-preflight.js"
      }
    ]
  }
}
```

Paths are relative to the project root. Symlinked projects use `../../core/` to reach shared hooks.

### 4. Testing hooks

Test a hook without a full session:
```bash
# Test the PII guard
echo '{"prompt": "my api key is sk-abc123"}' | node core/tools/hooks/templates/user-prompt-submit-pii-guard.js

# Test the directory guard
echo '{"tool": "Write", "path": "/other/project/file.md"}' | node core/tools/hooks/templates/pre-tool-use-directory-guard.js
```

## Adding a New Hook (THE PROCESS)

```
Step 1: Create the hook script
  → core/tools/hooks/templates/post-tool-use-my-new-hook.sh

Step 2: Make it executable
  → chmod +x core/tools/hooks/templates/post-tool-use-my-new-hook.sh

Step 3: Add ONE line to the canonical list in deploy-hooks.sh
  → Edit: core/tools/hooks/deploy-hooks.sh
  → Add:  { "type": "command", "command": "bash ../../core/tools/hooks/templates/post-tool-use-my-new-hook.sh" }

Step 4: Deploy to all projects
  → bash core/tools/hooks/deploy-hooks.sh
  → Deploys to all 13 clients + internal in 1 second

DONE. Never manually edit individual client settings.json files.
```

**The canonical hook list lives in ONE place:** `core/tools/hooks/deploy-hooks.sh`
All 14 project settings.json files are GENERATED from this script.

## Current Hook Inventory (v1.1.0)

| # | Hook | Type | What it does |
|---|---|---|---|
| 1 | `pre-tool-use-directory-guard.sh` | PreToolUse | **Blocks** writes outside client dir |
| 2 | `post-tool-use-auto-log.sh` | PostToolUse | Logs changes to CAPTAINS_LOG |
| 3 | `post-tool-use-assumption-guard.sh` | PostToolUse | Warns on unverified assumptions in diagnostics |
| 4 | `post-tool-use-version-guard.sh` | PostToolUse | Warns on .md without version info |
| 5 | `post-tool-use-glossary-check.sh` | PostToolUse | Warns on banned terms per PROJECT_GLOSSARY |
| 6 | `post-tool-use-ontology-check.sh` | PostToolUse | Warns on missing bidirectional links |
| 7 | `post-tool-use-email-consent-check.sh` | PostToolUse | Warns on email campaigns without consent |
| 8 | `post-tool-use-memo-task-check.sh` | PostToolUse | Reminds to extract tasks from finalized deliverables |
| 9 | `user-prompt-submit-pii-guard.sh` | UserPromptSubmit | Warns on secrets/tokens in prompts |
| 10 | `user-prompt-submit-date-context.sh` | UserPromptSubmit | Injects date/day-of-week context on date-related prompts |

Not yet deployed as hooks (exist as scripts, used manually or by skills):
- `session-start-inbox-check.sh` — inbox aging warning
- `post-tool-use-changelog.sh` — auto-append to CHANGELOG (hub only)
- `post-tool-use-registry-update.sh` — flag stale registries (hub only)
- `post-tool-use-git-stage.sh` — auto git-add changed files

## Design Principles

1. **Hooks inform, rarely block.** Only the directory guard actively prevents actions. Everything else warns or logs.
2. **No hook should slow down the session.** Each hook should complete in <100ms.
3. **Hooks never modify the user's work.** They log, warn, or block — they do not rewrite files.
4. **Fail open.** If a hook errors, the session continues. Log the error, don't crash the session.
5. **One source of truth.** All hook config lives in `deploy-hooks.sh`. Never edit client settings.json directly.
6. **Deploy after every change.** Created a hook? Added to deploy script? Run `bash deploy-hooks.sh`. Always.
7. **Platform portability.** All hook scripts MUST use POSIX-compatible commands. Where platform-specific commands are unavoidable, use the **try-BSD → try-GNU → python3 fallback** pattern:

```bash
# Timestamp conversion (canonical example)
ISO_DATE=$(date -r "$ts" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null)        # BSD (macOS)
[ -z "$ISO_DATE" ] && ISO_DATE=$(date -d "@$ts" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null)  # GNU (Linux)
[ -z "$ISO_DATE" ] && ISO_DATE=$(python3 -c "..." 2>/dev/null)        # Universal fallback

# sed in-place editing
if sed --version 2>/dev/null | grep -q GNU; then
  sed -i "..." "$FILE"           # GNU (Linux)
else
  sed -i '' "..." "$FILE"        # BSD (macOS)
fi

# File modification time
MTIME=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null)  # BSD || GNU
```

Known platform-specific traps: `date -r` (BSD) vs `date -d @` (GNU), `sed -i ''` (BSD) vs `sed -i` (GNU), `stat -f` (BSD) vs `stat -c` (GNU), `readlink -f` (GNU-only, use `realpath` instead).
