> v1.0 — 2026-04-03

# Scaffold — Directory Structure

> Full directory tree per project type. Loaded by `/scaffold-project` Step 1 and Step 10.

---

## Base Structure (every project)

```
{location}/
├── CLAUDE.md
├── CAPTAINS_LOG.md
├── TASKS.md
├── TASKS_DONE.md
├── .gitignore
├── .claude/
│   ├── commands/
│   │   └── tasks.md
│   └── settings.local.json
├── brand/
│   ├── 7LAYER_DIAGNOSTIC.md
│   ├── CONSTRAINT_MAP.md
│   ├── REPAIR_ROADMAP.md
│   ├── .md
│   ├── VOICE.md
│   ├── TARGET_PROFILE.md
│   └── POSITIONING.md
├── skills → ../../core/skills/
├── sops → ../../core/sops/
├── memory/
│   └── MEMORY.md
├── inbox/                             ← Unprocessed inputs (triage within 7 days)
│   └── .gitkeep
├── upd/                               ← User Provided Data (files FROM the client: exports, screenshots, answers)
│   └── README.md
├── archive/                           ← Superseded files, old versions
│   └── .gitkeep
├── reports/                           ← Weekly/monthly deliverables
│   └── .gitkeep
├── meetings/                          ← Transcripts from Fireflies + processed notes
│   └── raw/                           ← Original unedited transcripts
└── data/
    └── raw/                           ← Raw data (gitignored, never committed)
        └── .gitkeep
```

## Client Type Additions

```
├── processes/
│   └── 00-PROCESS-MAP.md
├── agencies/
│   └── .gitkeep
├── takeover/
│   ├── correspondence/
│   └── .gitkeep
├── audit/
│   ├── ac/
│   ├── shopify/
│   └── gtm/
├── analysis/
│   ├── mindset/
│   ├── screenshots/
│   └── .gitkeep
├── newsletter/
│   └── EMAIL-BEST-PRACTICES.md
└── EXTERNAL-CONTACTS-TABLE.md
```

## Audit Type Additions

```
├── findings/
│   └── .gitkeep
├── recommendations/
│   └── .gitkeep
├── audits/
│   └── YYYY-MM-DD_initial/
│       ├── phase0/
│       ├── phase1/
│       ├── phase2/
│       ├── phase3/
│       ├── phase4/
│       └── phase5/
├── data/
│   ├── gtm-exports/                   ← GTM-{ID}_workspace{N}.json + GTM_CHANGELOG.md + GTM_INVENTORY.md
│   ├── feeds/
│   ├── analytics/
│   ├── browser-sessions/
│   ├── artifacts/
│   └── screenshots/
├── audit/evidence/                    ← Timestamped evidence (screenshots, network, cookies, console)
│   └── AUDIT_LOG.md                   ← Master log: every action + timestamp + evidence file link
├── CLIENT_CONFIG.md
└── ACCESS_REGISTRY.md
```

## Internal Type Additions

```
├── strategy/
├── content/
│   ├── linkedin/
│   │   ├── posts/
│   │   ├── comments/
│   │   ├── newsletters/
│   │   └── replies/
│   └── substack/
├── leads/
├── methodology/
├── product/
├── pitches/
├── analyses/
├── team/
├── events/
├── PUBLICATION_DIRECTORY.md
└── CONTENT_CALENDAR.md
```
