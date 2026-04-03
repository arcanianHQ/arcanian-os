---
name: memory-bank
description: Manages persistent project knowledge across sessions
---

# Memory Bank Skill

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.
Maintain and query persistent project knowledge that survives across Claude Code sessions. The memory bank is the project's institutional knowledge.

## When to Use

This skill is activated when:
- Loading context at session start
- Storing new learnings or decisions
- Querying for relevant patterns or history
- Updating issue status or documentation

## Memory Bank Structure

```
.arcflux/memory/
├── SETUP.md              # Environment and CLI requirements
├── architecture.md       # System design overview
├── roadmap.md           # Priorities and planned work
├── captains-log.md      # Decision journal
├── cli-development.md   # CLI development practices
├── environment.md       # Human-readable config docs
├── INSPIRED-BY.md       # References and inspirations
├── issues/
│   ├── _index.md        # Issue index and status
│   ├── AF-001.md        # Individual issue files
│   ├── AF-002.md
│   └── ...
├── stacks/
│   ├── drupal.md        # Drupal-specific patterns
│   ├── typescript.md    # TypeScript patterns
│   └── docker.md        # Docker patterns
└── patterns/
    ├── commands.md      # Command implementation patterns
    ├── testing.md       # Testing patterns
    └── error-handling.md # Error handling patterns
```

## Core Operations

### Read Memory

```bash
# Load specific memory file
arcflux memory read <path>

# Examples:
arcflux memory read architecture
arcflux memory read issues/AF-043
arcflux memory read stacks/drupal
```

### Write Memory

```bash
# Update memory file
arcflux memory write <path> --section <section> --content <content>

# Examples:
arcflux memory write captains-log --entry "Decision: Use hybrid plugin approach"
arcflux memory write issues/AF-043 --section progress --content "Completed phase 1"
```

### Query Memory

```bash
# Search across memory
arcflux memory query <term>

# Examples:
arcflux memory query "error handling"
arcflux memory query "authentication pattern"
```

## Memory Categories

### 1. Architecture (architecture.md)
System-level design and structure.

Contents:
- Component diagram
- Data flow
- Key abstractions
- Extension points

When to update:
- New subsystem added
- Major refactor
- Design decision changed

### 2. Issues (issues/*.md)
Per-issue tracking and history.

Contents:
- Requirements
- Progress notes
- Decisions made
- Blockers
- Outcome

When to update:
- Phase transitions
- Significant decisions
- Blockers encountered
- Completion

### 3. Captain's Log (captains-log.md)
Decision journal for significant choices.

Entry format:
```markdown
## Entry XXX - [Date]

**Context**: [Situation requiring decision]

**Decision**: [What was decided]

**Rationale**: [Why this choice]

**Alternatives Considered**:
- Option A: [rejected because...]
- Option B: [rejected because...]

**Impact**: [What this affects]
```

When to add entry:
- Architecture decisions
- Tool/library choices
- Workflow changes
- Significant trade-offs

### 4. Stack Guides (stacks/*.md)
Stack-specific patterns and practices.

Contents:
- Coding patterns
- Configuration
- Common pitfalls
- Testing approach

When to update:
- New pattern discovered
- Pitfall encountered
- Best practice identified

### 5. Patterns (patterns/*.md)
Reusable implementation patterns.

Contents:
- Code patterns
- Structure patterns
- Testing patterns

When to update:
- Pattern established
- Pattern improved
- Anti-pattern identified

## Context Loading Strategy

### Session Start (Minimal Load)
1. state.json - Current issue/phase
2. Active issue file - If working on something
3. config.json - Project settings

### On Demand (When Relevant)
- Architecture - When making structural changes
- Stack guides - When working with specific tech
- Patterns - When implementing common operations
- Other issues - When dependencies exist

### Full Context (Recovery)
Use `/arcflux:context` to dump complete state.

## Memory Update Rules

### Atomic Updates
Each memory operation should be atomic and meaningful:
```markdown
# Good - Specific and complete
## Progress Update - 2024-01-15
Completed implementation of start command validation.
Files modified: src/commands/start.js, src/utils/validate.js

# Bad - Vague
Updated stuff.
```

### Append-Only for History
Historical entries (Captain's Log, issue progress) should append, not overwrite:
```markdown
## Entry 005
...new entry...

## Entry 004
...previous entry remains...
```

### Version Context
Include context for future readers:
```markdown
## Decision: Hybrid Plugin Architecture
**Session**: 2024-01-15
**Issue**: AF-043

When reading this in a new session, know that...
```

## Integration with Workflow

| Phase | Memory Operations |
|-------|-------------------|
| Explore | Read architecture, relevant issues |
| Plan | Read patterns, update issue with plan |
| Architect | Update architecture if needed |
| Implement | Read patterns, track progress |
| Review | Read compliance requirements |
| Test | Read testing patterns |
| Document | Update all relevant memory |

## CLI Commands

```bash
# List all memory files
arcflux memory list

# Show memory structure
arcflux memory tree

# Search memory content
arcflux memory search "pattern"

# Validate memory structure
arcflux memory validate

# Export memory (for backup/sharing)
arcflux memory export --output backup.zip
```

## Best Practices

1. **Write for Future Self**
   - Assume no context
   - Be specific about files/locations
   - Include rationale

2. **Keep Updated**
   - Update immediately when decisions made
   - Don't batch updates
   - Mark outdated info

3. **Cross-Reference**
   - Link related issues
   - Reference architecture sections
   - Point to patterns

4. **Prune Carefully**
   - Archive rather than delete
   - Keep history for learning
   - Remove only clearly obsolete info
