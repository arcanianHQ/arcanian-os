---
scope: shared
type: methodology
version: 1.1
created: 2026-04-21
updated: 2026-04-22
---

# Campaign Registry Standard

## Purpose

Every client running marketing campaigns MUST have a `CAMPAIGN_REGISTRY.md` in their client directory. Without it, Nexus (and any skill that asks data questions) cannot resolve short campaign names clients actually use in day-to-day language — *"Glamour"*, *"Húsvét"*, *"Black Friday"*, *"Tavaszi megújulás"*.

The registry answers one question before any campaign analysis begins: **when exactly did this campaign run, on which entities, and what's its canonical identifier?** Clients don't think in ISO dates — they say *"the Glamour one from last month"*. The registry maps those human references to precise windows.

This standard parallels `AD_ACCOUNT_REGISTRY_STANDARD.md` but covers a different axis: campaigns are *time events* with *intent*, whereas ad accounts are *infrastructure*.

## Specific failure modes this standard prevents

- `/nexus-answer` asked to analyze "Glamour" but the skill doesn't know the dates → fallback to generic last-14-days window → wrong numbers analyzed
- Team member joins mid-engagement, types *"hogyan ment a Húsvét"* — skill has no way to know Húsvét = 2026-03-25 → 2026-04-07, not the 2025 Easter
- Multiple Glamour campaigns per year (spring, autumn) → short name ambiguous → skill picks wrong one
- Campaign ended but team still asks about it — skill picks a stale or default window
- Post-mortem requires comparing "Glamour 2026 vs Glamour 2025" — no structured history to pull from

## What the registry contains

### Per campaign

| Field | Required | Purpose |
|---|---|---|
| `id` | yes | Unique stable slug (e.g. `glamour-2026-spring`). Never changes. |
| `name_short` | yes | What the team CALLS it in conversation (e.g. `Glamour`). Used for fuzzy matching in skill queries. |
| `name_full` | no | Full marketing name if different (e.g. `Glamour Tavaszi Megújulás 2026`) |
| `start` | yes | ISO date — first live day |
| `end` | yes | ISO date — last live day (may be future for scheduled campaigns) |
| `status` | yes | `scheduled` / `active` / `ended` / `cancelled` |
| `entities` | yes | List of entity_ids that participated (single-entity clients can omit) |
| `goal_metric` | optional | Primary KPI (revenue, ROAS, conversions, sessions, brand_awareness, etc.) |
| `goal_value` | optional | Target number for the KPI |
| `managing_team` | optional | Who ran it (internal / agency name / joint) |
| `aliases` | optional | Other names the team uses (e.g. `["Tavaszi Glamour", "G2026-Spring"]`) |
| `notes` | optional | 1-2 sentences of context — why this campaign ran, key learning |
| `retrospective_url` | optional | Link to post-mortem doc if one exists |

### Registry-level

- **Alias resolution table** — for disambiguation when short names could match multiple campaigns (*"Glamour"* could be Spring 2025 or Spring 2026)
- **Active / upcoming section** — quick-reference for what's running now
- **Archive section** — ended campaigns, sortable by start date
- **Year-over-year pairs** — explicit mapping for YoY analyses (*"Glamour 2026 vs Glamour 2025"*)

## When to update

| Trigger | Required Action |
|---|---|
| New campaign approved / scheduled | Add entry with `status: scheduled` |
| Campaign goes live | Update to `status: active`, confirm `start` date |
| Campaign ends | Update to `status: ended`, confirm `end` date, add brief notes |
| Campaign cancelled or paused | Update to `status: cancelled`, note reason |
| New team members use a short name no one else uses | Add it to `aliases` for their campaign |
| Post-mortem or retro complete | Add `retrospective_url` |
| Entity changes mid-campaign | Update `entities` list with note |

The registry is append-mostly — rows rarely disappear. Ended campaigns move to the archive section but stay queryable.

## Resolution order for skills

When a skill (like `/nexus-answer`) resolves a campaign reference from a user question, it follows this strict order. The order is canonical — skills may not reorder it, skip phases, or invent alternate heuristics.

**Phase A — File resolution (always first):**

1. **Exact id match** — user typed or config resolved to `glamour-2026-spring` → direct lookup
2. **Exact name_short match, unique** — user said "Glamour", only one active/recent row matches → use it
3. **Alias match, unique** — user said "Tavaszi Glamour", `aliases` field matches → use it
4. **name_short match, ambiguous** — multiple matches → go to Phase B with ONLY the matching campaigns from THIS registry as options (never leak other clients)
5. **No match, ended campaign heuristic** — if question implies "the recent promo" AND there is exactly one recently-ended (≤30 days) campaign in the registry → use it; otherwise go to Phase B

**Phase B — Disambiguation ask-back (exactly ONE user question):**

6. **No resolution from files** — ask the user ONE disambiguation. Offer:
   - The most recent ended campaign from registry (if any)
   - Utolsó 14 nap (generic non-campaign default)
   - Named campaign + dates (user supplies both)
   - Explicit date range only (user supplies start/end, skill assigns placeholder name)

**Phase C — Persistence (MANDATORY when Phase B names a campaign or window):**

7. **Write back to CAMPAIGN_REGISTRY.md** — see §Auto-registration from disambiguation below. Persistence happens BEFORE the analysis continues.

**Phase D — Hard prohibition (no inference backdoor):**

8. **Never infer a campaign window from data patterns.** Revenue plateaus, spend spikes, conversion bumps — none of these are campaign-window resolution heuristics. A pattern in the data is not a campaign declaration. If files don't resolve and the user hasn't been asked, the skill MUST ask — it MUST NOT pattern-hunt.
9. **Never fabricate a campaign.** If no window resolves and the user opts for "Utolsó 14 nap", that's a generic window — label it as such, do NOT call it a campaign, do NOT persist it to the registry.
10. **Never silently reuse a prior conversation's window.** Each time/campaign-referring question re-triggers the phase sequence from the top.

## Auto-registration from disambiguation

When a skill asks the user to name a campaign or provide a window because Phase A resolution failed, the user's answer MUST be persisted to `CAMPAIGN_REGISTRY.md` BEFORE the skill proceeds with analysis. Without persistence, the same question re-asks every session — the registry's value is precisely that it accumulates the team's domain vocabulary as a byproduct of actual use.

### Trigger

Any skill disambiguation where the user's answer contains EITHER:
- a campaign name (short or full) with implied or explicit dates, OR
- an explicit start/end date range tied to a specific event, campaign, or promo

### Action

1. **Ensure registry exists** — if `CAMPAIGN_REGISTRY.md` is absent from the active client dir, create it from §Minimum registry for a new client.
2. **Derive `id`** — format: `{slug(name_short)}-{YYYY}-{season-or-month}`. Examples:
   - `glamour-2025-spring`, `husvet-2026`, `black-friday-2025`, `promo-2026-03-23` (placeholder for unnamed windows)
3. **Write the row** with at minimum these fields:
   - `id` (derived)
   - `name_short` (user-supplied, or prompted ONCE if user gave only dates)
   - `start`, `end` (ISO dates)
   - `status` (`ended` for post-hoc questions, `active` if still running, `scheduled` if future)
   - `entities` (from config `default_for: general` unless user named specific entities)
4. **Confirm to user** in one line: *"Feljegyeztem: `{id}` ({start} → {end}). Következő kérdésnél automatikusan feloldódik."*
5. **ONLY THEN proceed** to the data pull. The registry write is blocking — a failed write must abort the analysis, not proceed with an unregistered window.

### When NOT to auto-register

- User picked the generic "last 14 days" option in disambiguation — that's a non-campaign window, persisting it would be noise.
- User's answer is a pure relative phrase like "tegnap" or "múlt hét" — already deterministically resolvable via `get_current_datetime`, no registry row needed.
- Skill is running in read-only mode (e.g., a report-rendering context where filesystem writes are prohibited) — in that case, surface the gap and stop; do not proceed with an unregistered window.

### Scope guard

Auto-registration writes ONLY to the CURRENT active client's registry (`<active_client_dir>/CAMPAIGN_REGISTRY.md`). It never writes to other clients' directories, the hub, or any shared location. This is enforced by the same CWD-boundary rule that governs all per-client file access.

### Rationale

Without mandatory persistence: every session asks the same disambiguation, users get tired of re-answering, and the registry stays empty — which is exactly the failure mode this standard was written to prevent. With mandatory persistence: the first analysis of any campaign costs one ask-back; every subsequent analysis of the same campaign is instant.

## Scope and security

`CAMPAIGN_REGISTRY.md` is `scope: int-confidential` by default — it contains strategic campaign metadata that competitors would value. It lives in the client directory and never crosses client boundaries.

Skills with `scope: shared` or `scope: int-company` must not enumerate campaign registries from other clients. The active client directory bounds the registry a skill can read.

## Minimum registry for a new client

```yaml
---
client: {slug}
scope: int-confidential
---

# {Client} — Campaign Registry

## Active / upcoming

| id | name_short | start | end | status | entities |
|---|---|---|---|---|---|
| (none yet) | | | | | |

## Archive (recent)

| id | name_short | start | end | status | notes |
|---|---|---|---|---|---|
| (none yet) | | | | | |
```

Add rows as campaigns are planned or retroactively documented. Don't over-structure early — fields fill in as the engagement matures.

## Related standards

- `core/methodology/AD_ACCOUNT_REGISTRY_STANDARD.md` — ad infrastructure registry
- `core/methodology/NEXUS_CLIENT_CONFIG.md` — per-client skill config (used to reference this registry)
- `core/methodology/EVENT_LOG_RULE.md` — campaign launch/end also logged to EVENT_LOG.md for temporal auditability

## Skills interacting with this registry

- `/campaign` — CRUD operations on the registry
- `/nexus-answer` — reads registry for window resolution
- `/morning-brief` — flags active campaigns in daily summary
- `/health-check` — cross-references active campaigns with anomaly signals
- `/map-results` — uses campaign windows as comparison anchors

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-21 | Initial — schema, update triggers, resolution order, scope rules. Extracted from `.nexus-config.md` v1.3 which had campaigns inline; promoted to standalone registry per VID-002 real-data readiness requirements. |
| v1.1 | 2026-04-22 | **Four-phase resolution + auto-registration**: rewrote §Resolution order as explicit Phase A (files) → Phase B (one ask-back) → Phase C (mandatory persistence) → Phase D (hard prohibition on data-pattern inference). Added new §Auto-registration from disambiguation section making registry write-back blocking before data pull. Caught during shared-flavor test where `/nexus-answer` inferred a promo window from a revenue plateau (instead of asking) AND didn't persist the resulting window (so the next session would re-infer). Both failure modes now codified as explicit violations. Companion change: `core/skills/nexus-answer.md` v1.8 phases realigned to reference this standard. |
