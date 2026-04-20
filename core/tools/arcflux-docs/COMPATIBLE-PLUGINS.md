---
scope: shared
---

# Compatible Plugins

Plugins that work well with ArcFlux for extended functionality.

## ralph-wiggum - Autonomous Iteration Loop

**Source**: https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum

**Purpose**: Creates an autonomous feedback loop where Claude keeps working until a completion condition is met.

**How it works**: Ralph-wiggum uses a stop hook to prevent Claude from exiting, re-feeding the same prompt until a "completion promise" appears in the output.

### Installation

```bash
claude plugins install ralph-wiggum
```

### Why Use with ArcFlux

ArcFlux requires human intervention between issues:
- User runs `/arcflux:start AF-043`
- Claude works
- User runs `/arcflux:start AF-044`
- Repeat...

Ralph-wiggum enables **fully autonomous batch processing**:
- User starts the loop
- Claude processes all issues automatically
- User reviews when all complete

### Use Case 1: Single Issue Until Complete

Work on one issue until all tests pass:

```bash
/ralph-loop "
Work on issue AF-043:
1. Run /arcflux:start AF-043
2. Complete all phases
3. Run /arcflux:validate
4. If validation passes, run /arcflux:commit
5. Output <promise>ISSUE_DONE</promise>

If validation fails, fix issues and try again.
" --completion-promise "ISSUE_DONE" --max-iterations 50
```

### Use Case 2: Batch Processing (Multiple Issues)

Process multiple issues sequentially without intervention:

```bash
/ralph-loop "
Process these issues in order:
- AF-043
- AF-044
- AF-045
- AF-046
- AF-047

For each issue:
1. Run /arcflux:start <issue>
2. Complete explore, plan, implement, review, test phases
3. Run /arcflux:validate
4. If passes: /arcflux:commit, mark done, continue to next
5. If fails: Log failure, continue to next (skip mode)

When ALL issues are processed, output:
<promise>ALL_ISSUES_COMPLETE</promise>
" --completion-promise "ALL_ISSUES_COMPLETE" --max-iterations 300
```

### Use Case 3: With ArcFlux Batch Command

Combine ralph-wiggum with `/arcflux:batch` for cleaner syntax:

```bash
/ralph-loop "
Execute: /arcflux:batch AF-043 AF-044 AF-045 AF-046 AF-047 --on-failure skip

When batch completes, output <promise>BATCH_DONE</promise>
" --completion-promise "BATCH_DONE" --max-iterations 300
```

### Best Practices

1. **Set max-iterations**: Prevent infinite loops
   ```bash
   --max-iterations 100  # For single issue
   --max-iterations 500  # For batch of 10+
   ```

2. **Use clear completion promises**: Unique strings that won't appear accidentally
   ```bash
   --completion-promise "ARCFLUX_BATCH_20260109_COMPLETE"
   ```

3. **Include failure handling**: Tell Claude what to do when things fail
   ```
   If validation fails 3 times for same issue, skip and continue.
   ```

4. **Request progress updates**: Ask Claude to output status
   ```
   After each issue, output:
   PROGRESS: X of Y complete
   ```

### Limitations

- No human oversight during execution
- Token usage can be significant for long sessions
- Context limits still apply (each issue should be relatively independent)
- Cannot handle issues requiring external input (waiting for API access, etc.)

### When NOT to Use

- Issues requiring human judgment or approval
- First-time implementations with unclear requirements
- Security-sensitive changes that need review
- Interdependent issues that must be done in specific order with verification

---

## commit-commands - Smart Git Commits

**Source**: https://github.com/anthropics/claude-code/tree/main/plugins/commit-commands

**Purpose**: Enhanced git commit functionality with AI-generated messages.

**Relationship**: ArcFlux peer dependency (required)

### Why Required

ArcFlux's `/arcflux:commit` builds on commit-commands for:
- Intelligent commit message generation
- Conventional commit format
- Co-author attribution

### Integration

ArcFlux commit wraps commit-commands with additional features:
- Issue ID in commit message
- Phase completion tracking
- Validation results in commit body

---

## feature-dev - Feature Development Workflow

**Source**: https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev

**Purpose**: 7-phase development workflow with specialized agents.

**Relationship**: ArcFlux is inspired by this plugin

### Inspiration

ArcFlux adopted feature-dev's workflow:
- Explore → Plan → Architect → Implement → Review → Test → Document

### Difference

ArcFlux adds:
- Issue tracking integration (Linear, GitHub)
- Memory bank persistence
- Multi-project orchestration
- Batch processing

---

## code-review - Multi-Agent Code Review

**Source**: https://github.com/anthropics/claude-code/tree/main/plugins/code-review

**Purpose**: Parallel validation agents with confidence scoring.

**Relationship**: ArcFlux is inspired by this plugin

### Inspiration

ArcFlux adopted code-review's pattern:
- 5 parallel validation agents
- Weighted confidence scoring
- Pass threshold (0.80)

### Agents Adopted

| Agent | Weight | Purpose |
|-------|--------|---------|
| code-reviewer | 20% | Quality & patterns |
| bug-detector | 25% | Bugs & logic errors |
| security-scanner | 25% | Security issues |
| compliance-checker | 15% | Standards compliance |
| test-analyzer | 15% | Test coverage |

---

## Plugin Compatibility Matrix

| Plugin | Relationship | Required | Notes |
|--------|--------------|----------|-------|
| ralph-wiggum | Compatible | No | Enables autonomous mode |
| commit-commands | Peer dependency | Yes | Required for /arcflux:commit |
| feature-dev | Inspiration | No | Workflow adopted |
| code-review | Inspiration | No | Validation pattern adopted |
| hookify | Vendored | Bundled | Screenshot harness |
| security-guidance | Vendored | Bundled | Security patterns |

---

## Installing All Recommended Plugins

```bash
# Required
claude plugins install arcflux

# Required peer dependency
claude plugins install commit-commands

# Optional but recommended for autonomous mode
claude plugins install ralph-wiggum

# Already vendored in ArcFlux (no install needed)
# - hookify patterns
# - security-guidance patterns
```
