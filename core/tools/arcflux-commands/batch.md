---
name: batch
description: Process multiple issues sequentially without human intervention
usage: /arcflux:batch <issue1> <issue2> ... [options]
aliases: [queue, auto]
scope: shared
---

# Batch Command

## Purpose

Process multiple issues sequentially in autonomous mode. Each issue goes through the full workflow (explore → document), gets validated, committed, and then the next issue starts automatically.

## Usage

### Basic

```bash
/arcflux:batch AF-043 AF-044 AF-045 AF-046 AF-047
```

### With Options

```bash
/arcflux:batch AF-043 AF-044 AF-045 \
  --on-failure skip \
  --auto-commit \
  --skip-phases architect
```

### From File

```bash
/arcflux:batch --from-file backlog.txt
```

### Resume Interrupted Batch

```bash
/arcflux:batch --resume
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--on-failure` | `stop` | Action on failure: `skip`, `stop`, `prompt` |
| `--auto-commit` | `true` | Commit automatically after validation |
| `--skip-phases` | none | Phases to skip (comma-separated) |
| `--from-file` | none | Read issue list from file |
| `--resume` | false | Resume previous batch |
| `--summary-file` | none | Output summary to file |
| `--max-issues` | none | Limit number of issues to process |

## Behavior

### 1. Initialize Batch

```bash
# Parse input
ISSUES=("AF-043" "AF-044" "AF-045")

# Create batch state
cat > .arcflux/batch-state.json << EOF
{
  "batchId": "batch-$(date +%Y%m%d-%H%M%S)",
  "status": "in_progress",
  "queue": $ISSUES,
  "completed": [],
  "current": null,
  "failed": [],
  "startedAt": "$(date -Iseconds)"
}
EOF

echo "═══ ArcFlux Batch Mode ═══"
echo "Issues queued: ${#ISSUES[@]}"
echo "Mode: Autonomous"
```

### 2. Process Each Issue

```
For each ISSUE in queue:

  ┌─────────────────────────────────────┐
  │ Processing: $ISSUE                  │
  └─────────────────────────────────────┘

  1. Update batch state: current = $ISSUE

  2. Start issue:
     /arcflux:start $ISSUE --batch-mode

  3. Execute phases (auto-advance):
     - Explore: Analyze requirements
     - Plan: Create implementation plan
     - Architect: Design solution (if not skipped)
     - Implement: Write code
     - Review: Run validation agents
     - Test: Execute tests
     - Document: Update docs

  4. Validate:
     /arcflux:validate --batch-mode

     If FAILED:
       case $ON_FAILURE in
         skip)  log_failure; continue ;;
         stop)  output_report; exit 1 ;;
         prompt) ask_user ;;  # Breaks autonomy
       esac

  5. Commit:
     /arcflux:commit --batch-mode --message "Complete $ISSUE"

  6. Update batch state:
     - Add to completed[]
     - Remove from queue
     - Set current = null

  7. Continue to next issue
```

### 3. Generate Report

```markdown
═══ Batch Complete ═══

Duration: 2h 45m
Processed: 5 issues

Results:
  ✅ AF-043 - Complete (32 min)
  ✅ AF-044 - Complete (28 min)
  ✅ AF-045 - Complete (35 min)
  ❌ AF-046 - Failed (validation)
  ✅ AF-047 - Complete (40 min)

Success Rate: 80% (4/5)

Failed Issues:
  AF-046: Security scanner found hardcoded credentials

Report saved to: .arcflux/batch-report-20260109.md
```

## Output Modes

### Progress Display (During Execution)

```
═══ Batch Progress ═══

Queue: ████████░░░░░░░░ 3/5 (60%)

✅ AF-043 Complete    32m
✅ AF-044 Complete    28m
🔄 AF-045 Implement   [████████░░] 80%
⏳ AF-046 Pending
⏳ AF-047 Pending

Current: AF-045 | Phase: Implement | ETA: ~45m remaining
```

### Summary (On Completion)

```
═══ Batch Summary ═══

Started:    2026-01-09 10:00:00
Completed:  2026-01-09 12:45:00
Duration:   2h 45m

Issues:     5 queued → 4 successful, 1 failed
Commits:    4 created
Branches:   4 merged (if configured)

Tokens Used: ~125,000 (estimated)

Next Steps:
  • Review AF-046 failure manually
  • Run /arcflux:status to see updated state
```

## Failure Handling

### Skip Mode (`--on-failure skip`)

```
❌ AF-046 failed validation

Reason: Security scanner found critical issue
  - Hardcoded API key in src/config.js:23

Action: Skipping to next issue
Logged to: .arcflux/batch-failures.log

Continuing with AF-047...
```

### Stop Mode (`--on-failure stop`)

```
❌ AF-046 failed validation

Reason: Security scanner found critical issue
  - Hardcoded API key in src/config.js:23

Action: Stopping batch execution
Remaining: 1 issue (AF-047) not processed

To resume after fixing:
  /arcflux:batch --resume

To skip and continue:
  /arcflux:batch AF-047
```

## Integration with Ralph-Wiggum

For fully hands-off operation:

```bash
/ralph-loop "
Run /arcflux:batch AF-043 AF-044 AF-045 AF-046 AF-047 --on-failure skip

Monitor progress. If all issues complete (success or skipped), output:
<promise>BATCH_COMPLETE</promise>

If a critical error occurs that cannot be recovered, output:
<promise>BATCH_FAILED</promise>
" --completion-promise "BATCH_COMPLETE" --max-iterations 300
```

This creates a fully autonomous development loop where:
1. Ralph-wiggum keeps Claude running
2. ArcFlux batch processes each issue
3. Validation ensures quality
4. Auto-commit saves progress
5. Loop continues until all done

## State File

`.arcflux/batch-state.json`:

```json
{
  "batchId": "batch-20260109-100000",
  "status": "in_progress",
  "queue": ["AF-046", "AF-047"],
  "completed": ["AF-043", "AF-044", "AF-045"],
  "current": "AF-046",
  "failed": [],
  "options": {
    "onFailure": "skip",
    "autoCommit": true,
    "skipPhases": []
  },
  "startedAt": "2026-01-09T10:00:00Z",
  "results": [
    {
      "issue": "AF-043",
      "status": "complete",
      "duration": 1920000,
      "phases": ["explore", "plan", "implement", "review", "test"],
      "commit": "abc123"
    }
  ]
}
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All issues completed successfully |
| 1 | Some issues failed (with `--on-failure skip`) |
| 2 | Batch stopped due to failure |
| 3 | Invalid input or configuration |

## Best Practices

1. **Start small**: Test with 2-3 issues before queuing 15
2. **Use skip mode**: `--on-failure skip` keeps progress moving
3. **Review failures**: Check batch report for failed issues
4. **Set limits**: Use `--max-issues` for very long queues
5. **Combine with ralph-wiggum**: For true autonomy

## Limitations

- Context limits may affect very long batches
- Each issue starts fresh (no cross-issue context)
- Complex interdependent issues may need manual sequencing
- Token usage scales linearly with issue count
