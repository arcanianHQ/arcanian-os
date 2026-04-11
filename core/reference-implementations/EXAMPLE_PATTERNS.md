> v1.0 — 2026-04-03

# Reference: ExampleBrand Patterns

> ExampleBrand is the most complete project (944 files, all L0-L7 layers). Use as gold standard for client projects.
> Location: `/path/to/project/`

## Why ExampleBrand is the Reference
- Only project touching all layers (L1: ~30, L5: ~35, L6: ~30, L7: ~15 tasks)
- Most mature process system (21 numbered SOPs)
- Full audit coverage (AC 51 files, Shopify 42 files, GTM 7 files)
- 6 agency relationships in different statuses (onboarding, stable, terminating, transitioning)
- Takeover coordination pattern (20 strategy docs + 44 correspondence files)
- Complete Databox dashboard implementation (5 dashboards)
- Working Asana sync with ext: IDs
- CAPTAINS_LOG with 594 lines of decisions

## Structure to Replicate

### Governance (root level)
```
CLAUDE.md                    ← 50 lines, client-specific rules
CAPTAINS_LOG.md              ← 594 lines, decision journal
TASKS.md                     ← 111 active tasks (unified format)
TASKS_DONE.md                ← 12 completed (archive)
```

### Processes (00-21)
```
processes/
├── 00-PROCESS-MAP.md        ← Master index (3 tiers: core/quick-win/dashboard)
├── 01-09: Core ops          ← Agency, Lead, Financial, Measurement, Campaign, Email, Vendor, Content, Sales
├── 10-18: Quick wins        ← Each has: effort + annual impact estimate
│   └── QUICK-WINS-FINANCIAL-SUMMARY.md  ← Total: ~$1.73M/year potential from 40h work
├── 19-21: Databox specs     ← Dashboard plan, CEO Pulse build, all settings
└── Integration docs         ← Clay, Medencevásár webhook, AC abandoned cart, GHL migration
```

### Audits (3 domains, 100 files)
```
audit/
├── ac/                      ← 51 files: 00-09 sections + AUDIT-REPORT + SVG diagrams
├── shopify/                 ← 42 files: analysis/00-09 + raw CSV exports + screenshots
└── gtm/                     ← 7 files: container analysis
```
Pattern: `00-audit-overview.md` → `01-09 sections` → `AUDIT-REPORT.md` (consolidated)

### Agencies (6 folders)
```
agencies/
├── bp-digital-seo/          ← 557 files! 7 markets, per-market: keywords + content + SEO + monitoring
├── growww-digital/           ← Contracts v1-v3, meeting notes, Roivenue partnership
├── [agency-a]/                   ← Termination docs (ends 2026-03-31)
├── team-handover/           ← 10 files: Excel tracking, roadmap, NDA
├── [competitor]/                 ← Partnership intel
└── brandmaker/               ← Legacy (minimal)
```
Pattern: Active agency = detailed + organized. Legacy = minimal.

### Takeover (37 files)
```
takeover/
├── 00-20: Strategy docs     ← Coordination, access dictionary, agreement, [Customer Need Framework] diagnostic, scapegoat cycle
├── correspondence/           ← 44 files: {recipient}-{topic}-{sent|received|draft}.md
├── ga4-access-exports/       ← 8 CSV files (per GA4 property)
├── MASTER-TASKLIST-4WEEKS.md ← Day-by-day transition plan
├── EXTERNAL-CONTACTS-TABLE.md ← Stakeholder registry
└── EXAMPLE_NDA.md
```

### Other Key Patterns
- `analysis/mindset/` — Arcanian diagnostic skills applied (map-results, )
- `analysis/screenshots/` — 21 visual evidence files (competitors, 404s, Wayback)
- `newsletter/` — 18 HTML templates (MMDD naming) + EMAIL-BEST-PRACTICES.md
- `memory/` — google-ads-accounts.md (critical reference)
- `skills/` — 27 Arcanian skills imported

## Key ExampleBrand-Specific Rules (from CLAUDE.md)
1. [Owner] = SolarNook employee (use solarnook.com email, NEVER Arcanian)
2. Single source of truth: TASKS.md (syncs to Asana)
3. No financial data in client-facing docs
4. All data under NDA
