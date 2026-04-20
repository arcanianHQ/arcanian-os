---
scope: shared
---

# Arcanian Ops — GitHub Org & Repo Structure

## Organization: `arcanian-ops` (GitHub Free)

```
arcanian-ops/                          ← GitHub Organization (private)
│
├── arcanian-methodology/              ← SHARED: skills, frameworks, templates
│   ├── CLAUDE.md                      ← Instructions for Claude Code
│   ├── skills/                        ← All 34+ skills (md files)
│   │   ├── 7layer.md
│   │   ├── tasks.md
│   │   ├── audit.md
│   │   ├── client-report.md           ← NEW: weekly/monthly report generator
│   │   └── ...
│   ├── methodology/                   ← Frameworks, thesaurus, references
│   ├── templates/                     ← TASKS.md template, report templates
│   └── memory/
│       ├── TASK_SYSTEM_RULES.md       ← Canonical task format
│       └── TASKS_TEMPLATE.md
│
├── client-wellis/                     ← One repo per client
│   ├── CLAUDE.md                      ← Client-specific instructions
│   ├── TASKS.md                       ← Active tasks
│   ├── TASKS_DONE.md                  ← Completed tasks archive
│   ├── .claude/
│   │   └── commands/
│   │       └── tasks.md               ← /tasks command
│   ├── processes/                     ← SOPs (01-AGENCY-COORDINATION, etc.)
│   ├── reports/                       ← Weekly/monthly reports (aggregated)
│   │   ├── 2026-W12.md
│   │   └── 2026-03-monthly.md
│   ├── audit/                         ← Audit findings if applicable
│   ├── data/                          ← .gitignore'd (raw data stays local)
│   │   ├── .gitkeep
│   │   └── raw/                       ← NEVER committed
│   ├── memory/                        ← Claude auto-memory
│   └── .gitignore
│
├── client-diego/                      ← Same structure as above
├── client-mancsbazis/
├── client-deluxe/
│
├── arcanian-internal/                 ← Internal company ops
│   ├── CLAUDE.md
│   ├── TASKS.md
│   ├── TASKS_DONE.md
│   ├── leads/
│   ├── strategy/
│   ├── brand/
│   ├── content/
│   ├── analyses/
│   └── product/
│
└── ops-infra/                         ← This project (setup, scripts, guides)
    ├── BRIEF.md
    ├── DATA_RULES.md
    ├── REPO_STRUCTURE.md (this file)
    ├── SETUP_GUIDE.md
    ├── SLACK_INTEGRATION.md
    ├── REMOTE_CONTROL.md
    └── scripts/
        ├── setup-tmux-sessions.sh
        ├── health-check.sh
        └── daily-brief.sh
```

## Shared Methodology

The `arcanian-methodology` repo is shared across all client repos via:
- **Option A:** Git submodule (developer-friendly)
- **Option B:** Symlink on Mac mini (simpler)
- **Option C:** Copy skills to each client repo (simplest, minor duplication)

**Recommended:** Option B (symlink) for the Mac mini, Option C (copy) for team MacBooks.

```bash
# On Mac mini — symlink methodology into each client
ln -s /Users/laszlo/Sites/arcanian-methodology/skills /Users/laszlo/Sites/client-wellis/skills
```

## Access Control

| Person | Repos | Role |
|---|---|---|
| László | All repos | Admin |
| Éva | client-wellis, arcanian-methodology, arcanian-internal | Write |
| Dóra | client-mancsbazis, client-deluxe, arcanian-methodology | Write |
| 4th hire | Assigned client repos only | Write |

## Branch Strategy

Keep it simple — no complex branching:
- `main` = current truth
- Work directly on `main` for day-to-day changes
- Create a branch only for: large restructures, experiments, or if two people edit the same file
- GitHub Desktop makes this a one-click operation
