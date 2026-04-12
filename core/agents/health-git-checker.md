---
id: health-git-checker
name: "Git Status Checker"
focus: "Git health — uncommitted changes, unpushed commits, submodule refs"
context: [infrastructure]
data: [filesystem]
active: true
confidence_scoring: false
recommendation_log: false
scope: shared
category: infrastructure
weight: 0.15
---

# Agent: Git Status Checker

## Purpose

Checks git status across all project repositories. Flags uncommitted changes, unpushed commits, merge conflicts, and stale submodule refs.

## Process

For each directory containing `.git/`:

1. **Uncommitted changes:** `git status --porcelain` — flag any output
2. **Unpushed commits:** `git log @{u}..HEAD --oneline` (if upstream exists) — flag any output
3. **Merge conflicts:** check for conflict markers in staged files
4. **Submodule status:** `git submodule status` — flag any with `-` prefix (not initialized) or `+` prefix (different commit)

## Scoring

Reference: `core/methodology/HEALTH_CHECK_SCORING.md` → Section 3

- All clean: 100
- Per dirty repo: -10
- Per unpushed: -10
- Any conflict: -20
- Per stale submodule: -5

## Output

```markdown
### Git Status [Score: {0-100}/100]

| Repo | Clean | Pushed | Conflicts | Note |
|---|---|---|---|---|
| {name} | {yes/no} | {yes/no/no upstream} | {yes/no} | {detail} |

Evidence: [OBSERVED: git status, {date}]
```
