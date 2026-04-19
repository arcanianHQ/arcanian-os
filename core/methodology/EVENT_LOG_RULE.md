---
scope: shared
---

# Event Log Rule — Operational Event Tracking

> **A data analysis without its event context is guessing.**
> Every client has an EVENT_LOG.md. Every analysis reads it first. Every analysis writes back to it.
>
> v1.0 — 2026-04-14

## Principle

Data doesn't explain itself. A -37% session drop is a crisis or a budget cut — the difference is knowing that on Jan 26 the daily Meta spend was halved. That knowledge must be **stored once, loaded always** — not re-derived from raw daily data every session.

EVENT_LOG.md is the per-client timeline of **external operational events** — things that happened outside our analysis that change how the data should be read.

## What Is an Event

An event is a **dated, external, operational change** that affects data interpretation:

- Budget changes (spend increased/decreased/paused)
- Platform changes (new ad account, property, pixel, feed)
- Agency/team changes (handover, new POC, restructure)
- Tracking changes (GTM publish, sGTM migration, consent update)
- Campaign launches/kills
- System migrations (CMS, ESP, domain, feed)
- Product/pricing changes
- Market events (competitor action, regulation)

**NOT events:** internal decisions (→ CAPTAINS_LOG), task status changes (→ TASKS.md), analytical findings (→ FND files), audit steps (→ AUDIT_LOG).

## Structured Value Deltas

The EVENT_LOG table includes `Prior Value` and `New Value` columns for machine-readable before/after tracking.

**Mandatory** (must have concrete values) for:
- Budget changes: `€150/day` → `€80/day` (always include currency code)
- Bid strategy changes: `Manual CPC` → `tROAS 300%`
- Tracking ID swaps: `UA-12345-1` → `G-EXAMPLE-001`
- Spend caps: `€5,000/month` → `€3,000/month`
- Campaign budget allocation: `60% Search / 40% Shopping` → `40% / 60%`

**Optional** (use `—` dash) for:
- Personnel/agency changes (narrative events)
- Campaign launches (no "prior" exists)
- Legal/compliance events
- Market events

**Format rules:**
- Currency: always with code or symbol (`€150/day`, not `150`)
- Percentages: with `%` symbol (`300%`, not `3x`)
- Tracking IDs: full ID, not abbreviated
- Bid strategies: readable label, not API enum (`Target ROAS 300%`, not `TARGET_ROAS`)

Skills reading EVENT_LOG.md for anomaly detection (e.g., `/health-check` Step 4b) should parse `Prior Value → New Value` deltas to adjust anomaly thresholds around the event date — a -50% session drop on the same day as a budget halving is not an anomaly.

## Three Enforcement Points

### 1. PRE-LOAD (MANDATORY — HARD BLOCK)

**Before ANY data analysis, load EVENT_LOG.md.**

Applies to: `/7layer`, `/analyze-gtm`, `/council`, `/measurement-audit`, `/health-check`, `/morning-brief` anomaly detection, results-mapping runs, all channel-analyst agents, outcome-tracker.

```
Step 0a: Load DOMAIN_CHANNEL_MAP.md (existing rule)
Step 0b: Load EVENT_LOG.md ← NEW
Step 0c: Identify which events fall within the analysis period
Step 0d: Flag any date ranges where events explain expected data shifts
```

If EVENT_LOG.md doesn't exist → WARN but proceed (new client, not yet populated). Create a task to populate it.

**Why hard block:** Without the event timeline, the analyst will either:
- Waste tokens re-deriving dates from raw data (repeatedly rediscovering the same budget cut)
- Miss the context entirely and produce wrong conclusions ("sessions crashed" vs "we cut the budget")

### 2. AUTO-EXTRACT (MANDATORY — ON EVERY ANALYSIS)

**After ANY data analysis that discovers a dated inflection point, append it to EVENT_LOG.md.**

Detection criteria — append an EVT when:
- Data shows >15% change between periods AND the cause is identified
- A platform/account/campaign start/stop date is discovered from data
- Meeting notes or client communication reveal a dated operational change
- An audit discovers a tracking change with a known deployment date

```
Post-analysis step:
1. Were any new dated events discovered? (budget changes, account switches, etc.)
2. Are they already in EVENT_LOG.md? (check by date + type)
3. If new → append row with EVT ID, evidence tag, related FND/REC
4. If existing but more detail now known → update Impact column
```

Source tagging is mandatory:
- `[DATA: Databox]` — derived from spend/traffic data patterns
- `[DATA: GA4]` — seen in GA4 property
- `[STATED: {person}]` — client/agency told us
- `[OBSERVED: {platform}]` — seen in platform UI
- `[INFERRED]` — pattern suggests it, NOT YET VERIFIED → must add verification task

### 3. MEETING/EMAIL EXTRACTION (MANDATORY)

**`/meeting-sync` and `/inbox-process` MUST scan for operational events.**

When processing meeting transcripts or client emails, extract any statement like:
- "We changed the budget last week"
- "The new agency starts on Monday"  
- "We launched the new campaign yesterday"
- "We migrated to the new platform"

Convert relative dates to absolute (per existing rule). Append to EVENT_LOG.md with `[STATED: {person}]` source.

## Event Log Location

```
clients/{slug}/EVENT_LOG.md
```

Template: `core/templates/EVENT_LOG_TEMPLATE.md`
Created by: `/scaffold-project` Step 3d (mandatory for all project types)

## Ontology Integration

Events are first-class ontology objects (see ONTOLOGY_STANDARD.md):
- EVT ID format: `EVT-YYYY-MM-DD-NNN` (sequential per client per day)
- Edges: EVT ↔ FND, EVT ↔ REC, EVT ↔ Task, EVT → Layer
- When a Finding references an external event, link FND → EVT
- When creating a task to verify an inferred event, link Task → EVT

## What Happens Without This

Without EVENT_LOG.md pre-loaded, every analysis session:
1. Pulls weekly/daily data from Databox
2. Sees an inflection point
3. Spends 5-10 minutes and 3-6 MCP calls re-deriving what happened
4. Discovers the same budget cut / account switch / agency change
5. Reports it as if it's new information
6. The knowledge evaporates when the session ends

With EVENT_LOG.md:
1. Loads the timeline (1 file read)
2. Knows the context before looking at data
3. Interprets data correctly on first pass
4. Only appends genuinely NEW events

## The Test

> "Can a new analyst open EVENT_LOG.md and understand every external change that affected this client's data, without re-deriving anything from raw metrics?"

If not, the event log is incomplete.
