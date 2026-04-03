# Reference: [Audit Framework] Patterns

> The measurement audit platform is the gold standard for structured diagnostic work.
> Location: `/path/to/project/`

## Why This is a Reference
- **FND→REC→Task chain** — the ontology model that inspired the entire task system
- **Phase-gated methodology** — 6 clear phases with defined inputs/outputs
- **Known patterns library** — 35+ reusable bug patterns across clients
- **Client isolation** — identical structure per client, no data mixing
- **Evidence-based** — every finding requires concrete proof
- **Scripts library** — reusable browser, CLI, and analysis scripts

## The FND→REC→Task Chain

This is the core innovation. Every task traces back to WHY it exists:

```
FND-001 (Finding)          → "Google Ads cart data reporting stopped"
    ↓
REC-001 (Recommendation)   → "Remove hardcoded Google Ads from Unas settings"
    ↓
Task #21 (in TASKS.md)     → "Remove hardcoded G-EXAMPLE-001 from Unas"
    ↓                         - FND: FND-008 | REC: REC-001
    ↓                         - Status: done (2026-03-17)
    ↓
TASKS_DONE.md              → Archived with full metadata
```

## Phase-Gated Audit

| Phase | Access | What | Duration |
|---|---|---|---|
| **0 — CLI** | curl, grep | Feed health, SGTM endpoints, structured data, robots.txt | 1-2h |
| **1 — Browser** | Chrome DevTools | JS errors, tracking inventory, dataLayer, consent, network | 4h |
| **2 — Dashboards** | Platform logins | Meta EM, Google Ads, GA4, GMC, Search Console | 4h |
| **3 — Container** | GTM/SGTM JSON | Tag inventory, triggers, consent gating, variables | 4h |
| **4 — Cross-verify** | All above | 10-product end-to-end trace | 1d |
| **5 — Diagnosis** | Analysis | Pattern matching vs KNOWN_PATTERNS, root causes | 4h |

**Rule:** Never skip phases. If access unavailable, document blockage and continue.

## Client Directory Structure

Every client gets identical structure:
```
clients/{slug}/
├── CLIENT_CONFIG.md         ← Domains, tracking IDs, GTM IDs, feeds, CMP
├── ACCESS_REGISTRY.md       ← Platform logins, property IDs, API keys
├── TASKS.md                 ← Per-client task tracking
├── findings/
│   └── FND-NNN_slug.md     ← One file per finding
├── recommendations/
│   └── REC-NNN_slug.md     ← One file per recommendation
├── audits/
│   └── YYYY-MM-DD_{name}/  ← Date-stamped audit
│       ├── AUDIT_REPORT.md
│       └── phase0-5/       ← Phase summaries
└── data/
    ├── gtm-exports/         ← GTM-{ID}_workspace{N}.json
    ├── feeds/               ← {provider}_{country}_YYYY-MM-DD.xml
    ├── analytics/           ← CSV exports
    ├── channable/           ← Feed management docs
    ├── artifacts/           ← Code artifacts
    ├── screenshots/         ← PNG/JPG evidence
    ├── browser-sessions/    ← DevTools session logs
    └── GTM_CHANGELOG.md     ← Container version tracking
```

## Known Patterns Library

`methodology/KNOWN_PATTERNS.md` — 35+ patterns reusable across ALL clients.

Each pattern:
```
### PAT-035: Dead GA4 message bus (measurementIdOverride)

**Detection:** Console: `google_tag_manager.mb.D` is null or empty
**Root cause:** GA4 event tags use measurementIdOverride instead of linking to Google Tag
**Impact:** All post-init GA4 events queue and never deliver
**Fix:** Remove measurementIdOverride, link tags to Google Tag via dropdown
**Found in:** ExampleRetail (all 3 countries), risk in ExampleLocal
```

**Rule:** After every client engagement, extract new patterns and add to this library. ExampleRetail added PAT-030..035, ExampleLocal added PAT-036+.

## Methodology Files

| File | Size | Purpose |
|---|---|---|
| `MEASUREMENT_HEALTH_SOP.md` | 174KB | Main SOP — phase-by-phase instructions |
| `KNOWN_PATTERNS.md` | Growing | Universal bug patterns (PAT-001..035+) |
| `PLATFORM_REFERENCE.md` | ~20KB | Meta, Google, SGTM, Consent Mode specifics |
| `SOP_CHANGELOG.md` | Small | Version tracking for the SOP |

## Scripts Library

```
scripts/
├── browser/     ← JS for Chrome DevTools
│   ├── discovery.js        ← Auto-discover tracking scripts, cookies, storage
│   ├── consent-test.js     ← Test consent banner behavior
│   └── datalayer-check.js  ← Validate dataLayer structure
├── cli/         ← Bash for Phase 0
│   ├── sgtm-health.sh     ← curl SGTM endpoint health
│   ├── feed-check.sh      ← Validate feed XML
│   └── structured-data.sh ← Check JSON-LD / schema
└── analysis/    ← Python
    ├── container-diff.py   ← Compare GTM container versions
    └── feed-analysis.py    ← Analyze feed quality metrics
```

## Session Handoff Pattern

Every session ends with this block in TASKS.md:
```markdown
### Session Handoff — YYYY-MM-DD

**Completed:**
- What was done this session

**Blocked:**
- What can't proceed and why

**Next:**
1. Ordered priority list

**Files created/updated:**
- List of files touched
```

## Knowledge Flow — The Key Mechanism

### Why This Matters

Every client audit makes the next one better. This is what separates Arcanian from "just another consultant" — accumulated diagnostic intelligence across all clients.

The measurement audit hub is not a static methodology. It is a **living system** that learns from every engagement. Client work feeds the hub, the hub feeds the next client. This compounding knowledge is part of Arcanian's moat.

### The 10-Step Cycle

```
1.  New client scaffolded (audit/ section included in clients/{slug}/)
2.  Run phases 0-5 (hub methodology guides the audit)
3.  Findings created in client dir (clients/{slug}/audit/findings/FND-NNN)
4.  Recommendations created in client dir (clients/{slug}/audit/recommendations/REC-NNN)
5.  Tasks created in client TASKS.md
6.  Phase 5 complete → MANDATORY "Extract learnings" task
7.  New patterns → hub methodology/KNOWN_PATTERNS.md (PAT-NNN)
8.  SOP improvements → hub MEASUREMENT_HEALTH_SOP.md + SOP_CHANGELOG.md
9.  New scripts → hub scripts/
10. Next client starts → benefits from ALL previous learnings
```

The cycle is non-negotiable. Step 6 is pre-populated by `/scaffold-project` so it cannot be forgotten.

### What Gets Extracted

| From client | Goes to hub | Format |
|---|---|---|
| New bug pattern | `KNOWN_PATTERNS.md` → PAT-NNN | Detection + root cause + fix |
| Platform-specific behavior | `PLATFORM_REFERENCE.md` | Platform + behavior + workaround |
| New consent pattern | `methodology/consent/` | CMP + pattern + test method |
| New SGTM pattern | `methodology/sgtm/` | Config + gotcha + fix |
| New feed issue | `methodology/feeds/` | Feed type + issue + fix |
| Reusable script | `scripts/browser/` or `scripts/cli/` | Script + documentation |
| SOP improvement | `MEASUREMENT_HEALTH_SOP.md` + `SOP_CHANGELOG.md` | Version + what changed + why |

### Cross-Client Pattern Tracking

Patterns track where they have been seen across clients. This builds confidence and surfaces systemic issues vs one-off bugs.

```markdown
### PAT-035: Dead GA4 message bus (measurementIdOverride)

**Detection:** Console: `google_tag_manager.mb.D` is null or empty
**Root cause:** GA4 event tags use measurementIdOverride instead of linking to Google Tag
**Impact:** All post-init GA4 events queue and never deliver
**Fix:** Remove measurementIdOverride, link tags to Google Tag via dropdown

**Seen in:**

| Client | Finding | Date | Status |
|---|---|---|---|
| ExampleRetail | FND-022 | 2026-03-10 | Fixed |
| ExampleLocal | FND-009 | 2026-03-18 | At risk (same GTM pattern) |
```

The "Seen in" table grows with every client. When a pattern appears 3+ times, it becomes a **Phase 0 auto-check** in the SOP.

### Mandatory Extraction Task

This task is pre-populated by `/scaffold-project` in every new client's TASKS.md:

```markdown
### Extract learnings to hub
- **Phase:** Post Phase 5
- **Priority:** P1
- **Status:** todo
- **Blocked by:** Phase 5 completion

**Checklist:**
- [ ] Review all findings — any new patterns not in KNOWN_PATTERNS.md?
- [ ] Review all recommendations — any new platform behaviors for PLATFORM_REFERENCE.md?
- [ ] Review scripts created — any reusable for hub scripts/?
- [ ] Check consent findings — new CMP patterns?
- [ ] Check SGTM findings — new server-side patterns?
- [ ] Check feed findings — new feed issues?
- [ ] Assign PAT-NNN numbers to new patterns (sequential, never reuse)
- [ ] Update SOP if any phase instructions need improvement
- [ ] Log SOP changes in SOP_CHANGELOG.md
- [ ] Update this reference doc stats section
```

### SOP_CHANGELOG.md Format

Every SOP change is versioned and traced back to the client that triggered it:

```markdown
## v1.0 — 2026-03-01
- Initial SOP based on ExampleRetail Phase 0-5 experience
- 30 known patterns (PAT-001..030)

## v1.1 — 2026-03-12
- **What changed:** Added measurementIdOverride check to Phase 3 container audit
- **Why:** ExampleRetail FND-022 revealed GA4 message bus dies silently when measurementIdOverride is used instead of Google Tag linking. Missed in Phase 1 because no console error — only visible in container JSON.
- **Triggered by:** ExampleRetail PAT-035
- **Patterns added:** PAT-031..035
```

### Current Stats

- **ExampleRetail** contributed: PAT-030..035 (6 new patterns)
- **ExampleLocal** contributed: PAT-036+ (hardcoded gtag.js, Google Tag linking)
- **Total patterns:** 35+ and growing
- **Every new client adds ~3-5 new patterns on average**

The pattern library is the compounding asset. By client #10, the Phase 0-1 auto-checks will catch 80%+ of common issues before manual investigation even begins.

## Critical Rules
1. **Never mix client data** — findings, configs, tasks stay in client directory
2. **Load CLIENT_CONFIG.md first** before any client work
3. **Discover, don't assume** — run discovery scripts before interacting
4. **Evidence is mandatory** — no finding without proof
5. **Cross-reference everything** — FND→REC→Task = connected graph
6. **Append-only logs** — CAPTAINS_LOG records decisions, never deletes
7. **Phase-gate access** — never skip phases
8. **Session handoffs** — always write what's done/blocked/next
9. **Extract learnings after Phase 5** — this is MANDATORY, not optional. Every engagement must feed the hub.
10. **Sequential PAT numbers** — new patterns are numbered sequentially (never reuse PAT numbers)

## Stats (Current)

| Client | Findings | Recommendations | Tasks | Phases | Status |
|---|---|---|---|---|---|
| ExampleRetail | 48 | 48 | 54 (40 done) | 0-5 complete | YELLOW |
| ExampleLocal | 13 | 1 | 21 (10 done) | 0-3 complete | YELLOW → improving |
