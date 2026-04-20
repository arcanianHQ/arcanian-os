---
scope: shared
---

# ArcFlux Batch Command

Process multiple issues sequentially without human intervention.

## Overview

The batch command enables "fire and forget" development where Claude works through a queue of issues autonomously, running the full 7-phase workflow for each.

## CLI vs Claude Code

| Action | Where to Run | Command |
|--------|--------------|---------|
| **Create batch queue** | CLI (Terminal) | `arcflux batch XAR-010 XAR-011 XAR-012` |
| **Process the batch** | Claude Code | `/arcflux-batch` |
| **Check status** | CLI (Terminal) | `arcflux batch --status` |
| **Resume batch** | CLI (Terminal) | `arcflux batch --resume` |
| **Clear batch** | CLI (Terminal) | `arcflux batch --clear` |

**Key Point**: The CLI manages state, Claude Code does the work.

---

## Quick Start

### Standard Workflow

```bash
# 1. Queue issues for processing
arcflux batch XAR-010 XAR-011 XAR-012

# 2. In Claude Code, process the queue
/arcflux-batch

# 3. Check final status
arcflux batch --status

# 4. Clear when done
arcflux batch --clear
```

### Docker Projects (Drupal)

For Docker-based projects, start containers first:

```bash
# 1. Start Docker containers
arcflux docker up

# 2. Queue issues (with permission analysis)
arcflux batch AF-001 AF-002 --save-permissions

# 3. In Claude Code, process
/arcflux-batch

# 4. Check status
arcflux batch --status
```

---

## Two Components

### 1. CLI: `arcflux batch` (Run in Terminal)

Manages the batch queue and state. Use this to:
- Create a new batch queue
- Check batch progress
- Resume or clear batches

```bash
# Queue issues for processing
arcflux batch XAR-010 XAR-011 XAR-012

# Queue from file
arcflux batch --from-file issues.txt

# Check progress
arcflux batch --status

# Resume interrupted batch
arcflux batch --resume

# Clear batch state
arcflux batch --clear
```

### 2. Slash Command: `/arcflux-batch` (Run in Claude Code)

Claude Code processes the queue, implementing each issue through all phases. Use this to actually execute the batch.

---

## What Happens During Batch

For each issue in the queue:

1. **Start the issue**
   ```bash
   arcflux start <issue-key> --create
   ```

2. **Execute all phases**
   - explore - Search and understand codebase
   - plan - Break down the work
   - architect - Design the solution
   - implement - Write the code
   - review - Self-review changes
   - test - Run tests
   - document - Update docs

3. **Validate before commit**
   ```bash
   arcflux validate --all
   ```
   - For Docker projects, runs inside container
   - Runs phpcs, phpstan, phpunit for Drupal
   - Runs npm test, tsc for Node.js

4. **Commit if validation passes**
   ```bash
   arcflux commit --yes
   ```

5. **Complete and move to next**
   ```bash
   arcflux phase complete --yes
   ```

---

## Permission Prediction (Preflight)

Batch automatically analyzes issues and predicts required permissions before processing.

### Automatic Analysis

When you create a batch, preflight analyzes all issues:

```bash
arcflux batch AF-001 AF-002 AF-003
```

Output includes:
```
Permission Prediction
────────────────────────────────────────
✔ Permission analysis complete

🔐 Permission Manifest

Tools Required:
  • Read, Glob, Grep, Edit, Write, Bash

Files to Edit:
  • src/commands/foo.js
  • src/utils/bar.js

Bash Commands (Allow):
  ✓ npm test
  ✓ docker compose *
```

### Save Permissions

Auto-save to `.claude/settings.json`:

```bash
arcflux batch AF-001 AF-002 --save-permissions
```

This creates pre-authorized permissions for Claude Code.

### Skip Preflight

For faster batch creation (no analysis):

```bash
arcflux batch AF-001 AF-002 --skip-preflight
```

### Workflow for Autonomous Runs

```bash
# 1. Create batch with saved permissions
arcflux batch AF-001 AF-002 --save-permissions

# 2. Review permissions
cat .claude/settings.json

# 3. In Claude Code, process with pre-authorized permissions
/arcflux-batch
```

---

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--on-failure <action>` | What to do on failure: `skip`, `stop`, `prompt` | `skip` |
| `--auto-commit` | Auto-commit successful issues | `true` |
| `--no-auto-commit` | Require manual commit | - |
| `--skip-phases <phases>` | Skip specific phases (comma-separated) | none |
| `--skip-preflight` | Skip permission prediction analysis | - |
| `--save-permissions` | Save predicted permissions to `.claude/settings.json` | - |
| `-v, --verbose` | Show detailed permission analysis | - |
| `--from-file <file>` | Load issues from file | - |
| `--resume` | Resume existing batch | - |
| `--status` | Show batch status | - |
| `--clear` | Clear batch state | - |

---

## Docker Projects (Drupal)

For Docker-based Drupal projects, ensure containers are running before batch processing:

### Requirements

1. **Docker containers must be running**
2. **Testing tools must be installed** (auto-installed by `drupal-init`)

### Workflow

```bash
# 1. Start Docker containers
arcflux docker up

# 2. Verify containers are running
arcflux docker status

# 3. Create batch queue
arcflux batch AF-001 AF-002 AF-003 --save-permissions

# 4. In Claude Code, process
/arcflux-batch
```

### What Gets Validated

The validation step automatically runs inside Docker:

- `phpcs --standard=Drupal` - Coding standards
- `phpstan analyse` - Static analysis
- `phpunit` - Unit tests
- `drush status` - Drupal health check

### New vs Existing Projects

**New projects** (via `arcflux drupal-init`):
- Testing tools are installed automatically
- PHPStan config is created
- Ready for batch processing

**Existing projects**:
```bash
# Install testing tools manually
docker compose exec cli composer require --dev \
  drupal/coder phpstan/phpstan mglaman/phpstan-drupal phpunit/phpunit
```

---

## Failure Handling

| Action | Behavior |
|--------|----------|
| `skip` | Log failure, continue to next issue |
| `stop` | Halt batch, output partial report |
| `prompt` | Ask user what to do (breaks autonomy) |

---

## State File

Batch state is stored in `.arcflux/batch-state.json`:

```json
{
  "batchId": "batch-1234567890",
  "status": "in_progress",
  "queue": ["XAR-010", "XAR-011", "XAR-012"],
  "completed": ["XAR-010"],
  "failed": [],
  "current": "XAR-011",
  "options": {
    "onFailure": "skip",
    "autoCommit": true
  },
  "startedAt": "2026-01-09T10:00:00Z",
  "results": [
    {
      "issue": "XAR-010",
      "status": "complete",
      "completedAt": "2026-01-09T10:15:00Z"
    }
  ]
}
```

---

## Resume Interrupted Batch

If a session ends mid-batch:

```bash
arcflux batch --resume
```

Shows remaining issues and continues from where it left off.

---

## From File

Create `issues.txt`:
```
XAR-010
XAR-011
# This is a comment (ignored)
XAR-012
XAR-013
```

Queue all:
```bash
arcflux batch --from-file issues.txt
```

---

## Status Output

```bash
arcflux batch --status
```

Output:
```
═══ Batch Status ═══

Progress
────────────────────────────────────────
  ✓ XAR-010 - complete
  → XAR-011 - in progress
  · XAR-012 - pending

Completed: 1
Failed: 0
Pending: 2
```

---

## Best Practices

1. **Start Docker first**: For Drupal projects, run `arcflux docker up` before batch
2. **Start small**: Test with 2-3 issues before large batches
3. **Use `--on-failure skip`**: For autonomous processing
4. **Review commits**: Check git log after batch completes
5. **Clear old batches**: Run `--clear` before starting new batch
6. **Save permissions for automation**: Use `--save-permissions` for unattended runs
7. **Review permission manifest**: Check predicted files/commands are accurate
8. **Use verbose mode**: `--verbose` shows detailed permission analysis

---

## Limitations

- Each issue starts fresh (no shared context between issues)
- Long batches may hit token limits (session restarts)
- Complex issues may need manual intervention
- **Docker projects**: Containers must be running for validation

---

## Related Commands

- `/arcflux-start` - Start single issue
- `/arcflux-validate` - Run validation
- `/arcflux-commit` - Commit changes
- `/arcflux-phase` - Manage phases
- `arcflux docker up` - Start Docker containers
- `arcflux preflight` - Permission prediction
