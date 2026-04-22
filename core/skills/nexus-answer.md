---
scope: shared
context: fork
allowed-tools:
  - mcp__databox__ask_genie
  - mcp__databox__load_metric_data
  - mcp__databox__list_data_sources
  - mcp__databox__list_data_source_datasets
  - mcp__databox__list_metrics
  - mcp__databox__get_current_datetime
  - Read
  - Grep
argument-hint: "HU question addressed to Nexus (e.g., 'Szia, Nexus. Véget ért az akciós időszakunk. Hogyan teljesített a kampány?')"
---

## 🔒 Privacy + boundary hard rules — MUST follow

### Rule 1 — No account/client enumeration

**NEVER enumerate other client accounts, entities, or account names in skill output.**

The user's MCP authentication may grant access to many Databox accounts across clients. These are visible via `list_accounts`, but their existence is private and client-specific. **Do not use `mcp__databox__list_accounts` in this skill** — it is explicitly NOT in allowed-tools.

When disambiguation requires the user to specify an account:
- ❌ Never list accessible accounts by name ("Diego HU, Wellis, MancsBázis, ...")
- ❌ Never derive client topology from MCP auth metadata
- ✅ Ask the user to **name the client** they mean ("melyik kliens?"), they type the answer
- ✅ Use only the `.nexus-config.md` in the current directory — that's the one authorized data source for entity/account info in this session
- ✅ If running from hub / no config, the only queryable account is the fallback (ArcanianOS DEMO) — never offer "other accounts" as an option

This rule applies regardless of flavor (shared / company / advanced) because even in shared practitioner-mode, client names must not surface in output that could be logged, shared, or rendered publicly.

### Rule 2 — No autonomous cross-client reads (explicit naming permitted)

**This skill only crosses client boundaries when the user explicitly names a client.** It never autonomously decides which client to read based on fuzzy matches, recent context, or pattern guessing.

**Active client resolution:**

1. **CWD client** — if `pwd` is `clients/{slug}/`, that's the active client. Read its `.nexus-config.md` and `CAMPAIGN_REGISTRY.md`.
2. **Explicit-named client (hub mode)** — if the question contains an explicit client name (e.g., *"Mosstrail akciós időszaka"*, *"Diego ROAS"*) AND `clients/{slug}/` exists in the repo:
   - Resolve the named client → that directory becomes the active scope
   - Read its `.nexus-config.md` + `CAMPAIGN_REGISTRY.md`
   - Continue normally — the user authorized the cross-read by naming the client
3. **Hub mode, no explicit name** — fall back to `clients/_demo/` virtual client (if present), otherwise stop with a "name a client" ask-back

**What's still forbidden** (the original Rule 2 motivations apply only to AUTONOMOUS cross-reads):

- **Fuzzy / heuristic auto-pick** — never decide "the user probably means Diego" from context like prior conversation, recent edits, or pattern guessing. Explicit naming required.
- **Multi-client merge** — never read TWO clients in one query. If the question implies cross-client comparison, ask the user to clarify which one (or invoke a different skill that's designed for cross-client analysis).
- **Globbing for cached analyses** — never search `clients/*/docs/*.md` or similar for pre-rendered reports. This skill queries Databox; it is not a file-search tool. If the user wants cached deliverables, that's a different skill (`/find-analysis` or similar).
- **Account enumeration** — see Rule 1. Never list which clients exist in the repo via skill output.

**Why explicit naming is safe** — the original Rule 2 risks (non-reproducibility, privacy-blurring, freshness-lying) all stem from the skill picking a client *on its own*. When the user names the client, those risks disappear:
- Reproducible (the same name gives the same client)
- Not privacy-blurring (the user has filesystem access AND named the target)
- Not freshness-lying (Databox query still pulls live data; only the config/registry is read from file)

**The filesystem is the security layer, not the skill.** If the practitioner has read access to `clients/mosstrail/`, they can read it directly outside the skill anyway. Refusing inside the skill is ceremony, not safety. Reserve enforcement for the cases that actually create risk: autonomous picking, fuzzy matching, enumeration.

If the user's question references a campaign that can't be resolved from the active client's `CAMPAIGN_REGISTRY.md` or `.nexus-config.md`, the skill follows the standard four-phase resolution (Phase B ask-back + Phase C persist) — same as in CWD-client mode.

> v1.10 — 2026-04-22 — Rule 2 refinement: explicit-naming permits cross-client reads (filesystem, not skill, is the security layer)

# Skill: `/nexus-answer` — structured answer to a business-data question

## Purpose

Arcanian Nexus is the analytics engine inside Arcanian Operating System. When a user addresses a business-performance question to Nexus, this skill returns a structured 4-block answer grounded in live Databox data, scored through the **Confidence Engine** (`core/methodology/CONFIDENCE_ENGINE.md`).

This skill is not a different framework — it is the Confidence Engine rendered as an interactive query response.

## Output contract

Nexus ALWAYS returns a 4-block response. Not 1, not 7.

1. **A számok** — raw metrics with period-over-period delta and inline `[Confidence: X.X]` tags
2. **Magyarázat** — narrative interpretation + control-questions, with overall answer confidence
3. **Megbízhatóság** — Source-Confidence matrix (4×4 grid, emoji-coded)
4. **Mit tegyél** — 2–4 concrete next actions, gated by Confidence Engine thresholds

Each block rendered as an ASCII-art terminal box. Output is text, not HTML — the Nexus interface is Claude Code terminal, not a web UI.

## Trigger

Use when:
- User explicitly invokes `/nexus-answer {question}`
- User's free-form HU message addresses "Nexus" by name AND asks a business-performance question
- Pattern match: contains any of *"hogyan teljesített"*, *"megérte"*, *"mi a helyzet"*, *"mit mutatnak az adatok"*, *"mi történt"*, *"hogyan ment"* + a time reference

Do NOT use for:
- Meta questions about Nexus itself (use plain chat)
- Questions where no Databox account is configured (tell user to run setup first)

## Prerequisites

At the start of every call, execute in order:

### 1. Load client config

Per `core/methodology/NEXUS_CLIENT_CONFIG.md`:

- If working dir contains `.nexus-config.md` → read it. Also read `CAMPAIGN_REGISTRY.md` if present. Extract:
  - `entities` table (entity_id → databox_account_id mapping)
  - `campaign windows` from CAMPAIGN_REGISTRY.md (alias-resolution + date windows)
  - `measurement caveats` (known data quality issues to surface)
  - `default_for: general` entity
- Else if working dir is `clients/{slug}/` but no config → warn user: config missing, running with generic defaults
- Else (hub / unknown context) → **fall back to `clients/_demo/` virtual client**:
  - Read `clients/_demo/.nexus-config.md` (DEMO account 748621, Mosstrail entity)
  - Read `clients/_demo/CAMPAIGN_REGISTRY.md` (DEMO campaign registry with alias-resolution for "Glamour", "akció", "promo" → `glamour-demo-2026-spring`)
  - Warn the user at the top of output: `⚠ Hub session → DEMO fallback (clients/_demo/). Synthetic data only.`
  - Full skill behavior otherwise identical — disambiguation still uses the registry's scope, never enumerates other clients

### 1b. Resolve reporting currency (MANDATORY — per `core/methodology/CURRENCY_NORMALIZATION.md`)

Every monetary value rendered in Block 1 MUST be tagged with its currency. Numbers without a unit are a reporting hazard — *"399,446"* reads as HUF to a Hungarian viewer, EUR to a European, USD to an American. Resolve BEFORE any data pull.

**Resolution order:**

1. **`CLIENT_CONFIG.md` `reporting_currency` field** — canonical per CURRENCY_NORMALIZATION. Format: `reporting_currency: HUF`. This is the primary source.
2. **`DOMAIN_CHANNEL_MAP.md` `currency` column** — per-source native currency. Used for per-source tagging when aggregating cross-market (multi-entity).
3. **`.nexus-config.md` `reporting_currency`** — fallback if CLIENT_CONFIG absent.
4. **DEMO virtual client**: read `clients/_demo/.nexus-config.md` `reporting_currency`.
5. **None of the above** → treat currency as `unknown`. Do NOT guess.

**What to do with the resolved value:**

- Store `reporting_currency` for use in Block 1 rendering (§Output templates §Block 1 rules).
- If sources are in multiple currencies (multi-entity cross-market query) → store both the per-source map AND the conversion target.
- If `unknown`: prepend Block 1 with the warning line:
  `⚠ Currency UNKNOWN — ensure CLIENT_CONFIG.md sets reporting_currency. Treat these numbers as unitless.`
  AND drop monetary-row Source Confidence by 0.2 (HIGH → MEDIUM at best).

**Cross-currency aggregation rules** (multi-entity, different native currencies):

- Convert each source to `reporting_currency` using the priority chain in CURRENCY_NORMALIZATION §Conversion source (Databox normalized → platform-reported → ECB daily → manual).
- State the rate + date in Block 2 footer: *"Conversion: 1 EUR = 410 HUF (ECB 2026-04-20)."*
- Rate staleness > 7 days → warning in Block 2, confidence penalty -0.1 on aggregate monetary rows.

**What NOT to do:**

- Don't ask the user for currency — it shouldn't change between questions. If unknown, surface the gap and flag it, don't interrupt flow.
- Don't silently pick a "likely" currency (e.g., "looks like HUF because numbers are big"). That's inference; same prohibition as Phase D of window resolution.
- Don't strip currency tags from Block 1 because they "clutter" — they are load-bearing metadata.

### 2. Parse the question for entity + window + metric focus

**Entity resolution** (multi-entity clients only):
- Question contains specific entity name ("Diego HU", "VR Software", "Deluxe") → use that entity's account
- Question says "cégcsoport" / "összes" / "group" → aggregation mode: query ALL entities + sum/weighted-avg per metric
- Ambiguous → use `default_for: general` entity. If no default, ask ONE short disambiguation question before querying:
  - `"Melyik entitás? (1) Diego HU (2) Cégcsoport összes (3) VR Software"`

**Window resolution order** (per `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md §Resolution order`):

For ANY question containing time or campaign language, follow this four-phase protocol in order. Skipping a phase or reordering it is a skill violation.

**Phase A — File resolution (always first, never skip):**

**A.0 — Active-client resolution** (per Rule 2 — explicit naming permitted):

Before reading any registry/config, determine which client dir is the active scope:

- **CWD client** — if `pwd` is `clients/{slug}/`, use that. Done.
- **Explicit-named client (hub mode)** — if the question contains an explicit client name AND `clients/{slug}/` exists in the repo:
  - Resolve name → that dir becomes active scope (single exact match required)
  - If two clients could match the name: Phase B ask-back with the matching slugs as options (NOT enumeration of all clients)
  - If no client dir matches the name: Phase B ask-back asking the user to either change directories or rename
- **Hub mode, no explicit name** — fall back to `clients/_demo/` virtual client if present, otherwise Phase B ask-back asking the user to name a client (do NOT enumerate which clients exist)

**Hard prohibition** (Rule 2 boundary): NEVER auto-pick a client from fuzzy matches, recent context, or pattern guessing. Explicit naming required for cross-CWD reads.

Once active scope is set, continue with A.1–A.3 in that scope:

1. **CAMPAIGN_REGISTRY.md** in the active client dir — read it first. Match order:
   - a) Exact `id` match
   - b) Exact `name_short` match, unique
   - c) Alias match from the registry's alias-resolution table
   - d) Ambiguous match → go to Phase B with ONLY the matching campaigns from THIS registry as options
2. **`.nexus-config.md`** campaign windows (legacy fallback) — if registry absent but config has inline windows
3. **Relative time phrases** — "tegnap", "múlt hét", "március vége" → compute deterministically vs `get_current_datetime`

**Phase B — Disambiguation ask-back (exactly ONE question, once):**

If Phase A yields no window, ask the user ONE disambiguation with ONLY these option types:
- `(1)` Most recent ended campaign from registry (if any)
- `(2)` Utolsó 14 nap (generic default, explicit non-campaign)
- `(3)` Named campaign + dates — *"mondd meg a kampány nevét és a start/end dátumot"*
- `(4)` Explicit date range only — *"mondd meg a start/end dátumot"*

Privacy constraints:
- **Do NOT offer "másik account" as an option** in CAMPAIGN-window context. If the user wants a different client's data, they either name it explicitly in the question (Phase A.0 resolves it) or change directories.
- **Do NOT enumerate accessible Databox accounts or client directories.** See §🔒 Privacy hard rule.

**Phase C — Persistence (MANDATORY when Phase B answer names a campaign or window):**

Per `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md §Auto-registration from disambiguation` — the user's answer MUST be written to `CAMPAIGN_REGISTRY.md` in the active client dir BEFORE the data pull begins:

1. If `CAMPAIGN_REGISTRY.md` doesn't exist → create it from the minimum template (`core/methodology/CAMPAIGN_REGISTRY_STANDARD.md §Minimum registry for a new client`).
2. Derive `id`: `{slug(name_short)}-{YYYY}-{season-or-month}`. If the user gave only dates, prompt ONCE for a short name OR use `promo-{YYYY}-{MM}-{DD}` as a placeholder.
3. Write row with: `id`, `name_short`, `start`, `end`, `status` (usually `ended` for post-hoc questions, `active` if still running), `entities` (from config `default_for: general` if not specified by user).
4. Confirm to user in one line: *"Feljegyeztem a registry-be: `{id}` ({start} → {end}). Következő kérdésnél automatikusan feloldódik."*
5. ONLY THEN proceed to the data pull.

Skip persistence only if the Phase B answer was option `(2) Utolsó 14 nap` — that's a generic window, not a campaign, and polluting the registry with it would be noise.

**Phase D — Hard prohibition (no inference backdoor):**

NEVER do any of the following in place of Phase B:
- Infer a promo window from revenue plateaus, spend spikes, or other data patterns
- Pick a date range because it "looks campaign-shaped"
- Carry over a window from a previous conversation without verifying it matches THIS question
- Silently fall back to `now − 14 days` when the question clearly names a specific campaign

If the generic default window returns empty data (sync lag, missing ingestion), the correct response is to **surface the gap and STOP**, not to hunt for a different window in the data.

Data patterns may later inform a control question in Block 2 — but they are NEVER the basis for the BLUF window.

### 3. Verify data availability

`mcp__databox__get_current_datetime` → establish "now".
`mcp__databox__list_data_sources` on the target account. For each required source:
- Present → continue
- Missing → surface in Block 3 as `❌ NOT CONNECTED` for that column, do not fabricate

### 4. Identify caveat-triggered confidence penalties

From config `measurement caveats`:
- "GA4 consent mode ~30% undercount" → reduce GA4 Revenue/Conversions base rating by 0.1 for this call
- "Meta pixel overcounter" → reduce Meta Conversions base rating by 0.1
- "SaleCortex offline" → flag pipeline-value metrics as unanswerable
- Any other declared caveat → apply per its stated impact

## Default data sources (ArcanianOS DEMO)

| Source | Source ID | Dataset ID | Type | Purpose |
|---|---|---|---|---|
| Google Ads Daily | `4942423` | `01f567ea-8d5e-44f2-8f60-4c2b45b21a36` | custom-ingested | Paid search performance |
| GA4 Ecommerce | `4942424` | `52ab550e-8845-4ba3-80d4-9035e6bbf016` | custom-ingested | First-party analytics |
| Meta Ads Daily | `4952835` | `78272e0b-54e3-4fcd-a56d-4ab3ecc64135` | custom-ingested | Paid social performance |
| SEMrush Daily | `4952836` | `ef399c10-4729-40e1-b252-c6294203e886` | custom-ingested | Organic/competitive context |
| Reliability Matrix Weekly | `4952873` | `8a59abb3-f099-43a7-a3b8-74e7e4d7aca3` | custom-ingested | Per-source confidence scores (input to Confidence Engine) |
| Explanation Weekly | `4952879` | `c5af0c4b-b994-46db-b968-ade72ec6178b` | custom-ingested | Narrative context + control questions |

All 6 sources are custom-ingested → **Genie-first query path** per `core/methodology/DATABOX_QUERY_ROUTING.md`.

For real (OAuth-integrated) clients, `load_metric_data` with platform metric_keys is the correct path — see the routing doc.

Gap (source missing on account) → Block 3 flag.

## Steps

### 1. Parse the question

Extract:
- **Time window:** resolve via the four-phase protocol in Prerequisites §2 (Phase A files → Phase B ask-back → Phase C persist → Phase D never-infer). Shorthand cues:
  - *"tegnap"* / *"tegnapi"* → previous day (Phase A.3)
  - *"múlt hét"* / *"az elmúlt héten"* → last 7 days (Phase A.3)
  - Explicit date range → use it (Phase A.3)
  - *"akciós időszak"* / *"a kampány"* / *"az akciónk"* / named campaign → REGISTRY-first (Phase A.1). If registry has no matching row → Phase B ask-back + Phase C persist. NEVER silently default to "most recent promo window = last 14 days" when the question clearly refers to a specific campaign.
  - No time reference at all → last 14 days + 14-day PoP (Phase A.3)
- **Metric focus:**
  - *"teljesített"* / *"megérte"* / *"eredmény"* → performance bundle (Revenue, Conversions, Sessions, AOV, ROAS)
  - *"forgalom"* → Sessions focus
  - *"konverzió"* / *"vásárlás"* → Conversions focus
  - *"költség"* → Spend focus
  - *"ROAS"* / *"megtérülés"* → ROAS focus
  - Open-ended → full performance bundle

### 2. Pull data via Databox MCP — follow routing rules

**Canonical routing:** `core/methodology/DATABOX_QUERY_ROUTING.md`

All 6 default sources on ArcanianOS DEMO are **custom-ingested type** (`Push custom data`). Genie-first is the correct path; `load_metric_data` only works once Custom Metrics are defined.

**Sequence:**

1. **Resolve absolute dates first** via `mcp__databox__get_current_datetime`. Compute:
   - `current_start`, `current_end` (the queried window, default last 14 days)
   - `prev_start`, `prev_end` (same-length previous period for PoP)

2. **Core metrics (Block 1)** — one `ask_genie` call per dataset:

   **GA4 Ecommerce** — dataset `52ab550e-8845-4ba3-80d4-9035e6bbf016`
   ```
   ask_genie(
     dataset_id="52ab550e-8845-4ba3-80d4-9035e6bbf016",
     question="Compare {current_start} to {current_end} vs {prev_start} to {prev_end}. Give me totals and PoP deltas for: revenue, transactions, sessions, conversion rate. Return as 'metric: current_value | previous_value | delta_pct'."
   )
   ```

   **Google Ads Daily** — dataset `01f567ea-8d5e-44f2-8f60-4c2b45b21a36`
   ```
   ask_genie(
     dataset_id="01f567ea-8d5e-44f2-8f60-4c2b45b21a36",
     question="Compare {current_start} to {current_end} vs {prev_start} to {prev_end}. Give me totals and PoP deltas for: spend, conversions, ROAS. Return as 'metric: current | previous | delta_pct'."
   )
   ```

   **Meta Ads Daily** — dataset `78272e0b-54e3-4fcd-a56d-4ab3ecc64135`
   ```
   ask_genie(
     dataset_id="78272e0b-54e3-4fcd-a56d-4ab3ecc64135",
     question="Compare {current_start} to {current_end} vs {prev_start} to {prev_end}. Give me totals and PoP deltas for: spend, conversions, revenue, roas. Return as 'metric: current | previous | delta_pct'."
   )
   ```

   **SEMrush Daily** — dataset `ef399c10-4729-40e1-b252-c6294203e886`
   ```
   ask_genie(
     dataset_id="ef399c10-4729-40e1-b252-c6294203e886",
     question="Compare {current_start} to {current_end} vs {prev_start} to {prev_end}. Give me averages and PoP deltas for: visibility_score, estimated_organic_traffic. Return as 'metric: current_avg | previous_avg | delta_pct'."
   )
   ```

3. **Source-confidence matrix (Block 3)** — **COMPUTED DYNAMICALLY**, not pulled from stored dataset.

   Follow `core/methodology/DYNAMIC_RELIABILITY_SCORING.md`:
   - Gather the SAME observations you already pulled in step 2 (core metrics per source)
   - For each (metric × source) cell:
     - Base rating from the canonical table in DYNAMIC_RELIABILITY_SCORING.md §Base ratings
     - Agreement factor from deviation vs cross-source median (per metric)
     - `reliability_score = base × agreement × 100`
   - Identify the row with largest variance (max − min score)
   - If variance > 40 pts → surface as the "disagreement row" with warning + action line

   **Do NOT pull from `Video 2 — Reliability Matrix` dataset for scoring.** That dataset is legacy cache / dashboard-visualization-only. The skill computes fresh from today's observations so the matrix reflects current data reality, not a past snapshot.

   Exception: if the skill cannot gather core metrics (all sources down), fall back to base ratings × 1.0 (pure prior), and note "single-source or no-variance fallback" in the footer.

4. **Narrative (Block 2)** — **COMPOSED LIVE**, not pulled.

   The Explanation Weekly dataset is **optional cache only** (legacy from DEMO build).

   For real clients, compose the narrative fresh using:
   - The observed numbers (Block 1 raw data)
   - The dynamic reliability scores (Block 3 matrix)
   - The config's measurement caveats
   - The campaign window context

   **Composition template:**

   a. **Headline** — 4–7 words, stating the bottom line. Examples:
      - *"Stabil hét, szokásos szórás"*
      - *"Meta Ads alulteljesít — audience fatigue"*
      - *"Akció lezárult — magasabb AOV, kevesebb volumen"*
      - *"Consent mode beüt — GA4 -30% kontextus"*

   b. **Body** (500-800 chars) — structured in 3 micro-sections:
      - *What the numbers show:* a 1–2 sentence summary of deltas (from Block 1)
      - *Why this is likely (or not obvious):* interpretation tied to the reliability row with largest variance, OR a caveat-driven explanation (consent mode, attribution ablak, etc.)
      - *What to verify before acting:* 2–3 concrete control questions

   c. **Overall confidence footer** — pull from the dynamic scoring computation (Section §7).

   **Rules:**
   - Must reflect the data actually pulled, not invent
   - If overall confidence < 0.5 → narrative tone shifts: *"Nem vagyunk biztosak — ellenőrzendő, mielőtt bármit állítunk."* Do not compose a confident explanation on weak data.
   - If a caveat was applied (consent mode, attribution), the body MUST mention it — trust stake
   - Cache the composed narrative back to `Explanation Weekly` dataset (optional) so it shows up on the dashboard view

   **DEMO fallback:** if the Explanation Weekly dataset exists and is fresh (<7 days old), you MAY use it verbatim. If it conflicts with freshly-pulled numbers, compose fresh and note the conflict in Block 2 body.

**Error handling per call:**
- If Genie returns an error or empty answer, note which source failed and continue. Surface the gap in Block 3 as `❌ NOT AVAILABLE` for that source.
- If a dataset is entirely missing (dataset_id invalid), render error state in that block.
- Reuse `thread_id` from prior Genie calls on the same dataset only if asking follow-up questions; otherwise each call is independent.

### 3. Compute deltas + Confidence Engine score per metric

For each core metric:
- Compute PoP delta: `(current - prev) / prev × 100`
- Render arrow: ▲ (positive), ▼ (negative), — (stable)
- **Source Confidence input:** look up reliability_score for this metric's most-trusted source. Map: >70 → HIGH (0.9), 40–70 → MEDIUM (0.6), <40 → LOW (0.3)
- **Evidence Class:** always `DATA` for Databox-sourced values → 0.9
- **Assumption Status:** assume `verified` (0.9) unless the narrative flags a gap
- **Overall Confidence for this metric:** `min(Source Confidence, Evidence Class, Assumption Status)`

### 4. Compute overall answer confidence

The overall answer confidence is the LOWEST per-metric confidence, reflecting the weakest link in the reconciliation.

If overall < 0.7 → the answer is flagged as "investigate, don't act yet" in Block 4.

### 5. Render the 4 blocks

Use the templates in §Output templates below. All boxes use ASCII box-drawing characters (┌─┐│└─┘). Maintain alignment. Emoji color coding is mandatory per the Confidence Engine mapping.

---

## Output templates

### Block 1 — A számok

**Known currency (standard case):**

```
┌─ A számok ─────────────────────────────────────────────┐
│                                                         │
│  Revenue (HUF):     957,900  ▼ 17%  [Conf: 0.9 HIGH]   │
│  Conversions:           135  ▼ 19%  [Conf: 0.9 HIGH]   │
│  Sessions:           23,215  ▼ 17%  [Conf: 0.9 HIGH]   │
│  AOV (HUF):           7,096  ▲  3%  [Conf: 0.6 MED]    │
│  ROAS:                 8.23  ▼ 27%  [Conf: 0.9 HIGH]   │
│                                                         │
│  Window:   {start} → {end}  (vs prev {N} days)         │
│  Currency: HUF (reporting_currency from CLIENT_CONFIG) │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Unknown currency (fallback, MUST include warning line):**

```
┌─ A számok ─────────────────────────────────────────────┐
│                                                         │
│  ⚠ Currency UNKNOWN — treat as unitless.               │
│    Do NOT re-report as HUF/EUR/USD.                    │
│                                                         │
│  Revenue (?):       399,446  ▲ 47%  [Conf: 0.6 MED]    │
│  Conversions:            57  ▲ 42%  [Conf: 0.9 HIGH]   │
│  Sessions:            7,840  ▼  6%  [Conf: 0.9 HIGH]   │
│  AOV (?):             7,011  ▲  3%  [Conf: 0.6 MED]    │
│  ROAS:                 9.42  ▼  5%  [Conf: 0.6 MED]    │
│                                                         │
│  Window:   {start} → {end}  (vs prev {N} days)         │
│  Currency: UNKNOWN — no reporting_currency resolved    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Rules:**

- 4–6 metrics max
- Include PoP delta for each
- Inline `[Conf: X.X LABEL]` per metric (Confidence Engine format)
- Align metric names, deltas, and conf tags in visible columns
- **Currency annotation (MANDATORY per `CURRENCY_NORMALIZATION.md`):**
  - Monetary metrics (Revenue, Spend, AOV, any value-unit metric) → append `(CUR)` to the metric name, e.g. `Revenue (HUF):`, `Spend (EUR):`
  - Dimensionless ratios (ROAS, Conv Rate) → no currency tag (unitless by definition), BUT they are ONLY comparable within one currency — cross-currency ROAS comparisons require conversion disclosed in Block 2
  - Counts (Sessions, Transactions, Conversions) → no currency tag
  - When `reporting_currency` resolved to `unknown`: use `(?)` on monetary rows AND prepend the ⚠ warning line AND drop monetary Conf to MEDIUM max
- **Cross-currency (multi-entity):**
  - If all entities share one currency → single tag, e.g. `Revenue (EUR)`
  - If entities differ → convert to reporting_currency, tag with reporting_currency, state the rate in Block 2 footer
  - Never render a Block 1 row that silently sums mixed currencies
- **Footer lines (both required):**
  - `Window:   {start} → {end}  (vs prev {N} days)`
  - `Currency: {CUR} ({source})` — e.g. `HUF (reporting_currency from CLIENT_CONFIG)`, or `mixed → HUF (ECB 2026-04-20)`, or `UNKNOWN — no reporting_currency resolved`

### Block 2 — Magyarázat

```
┌─ Magyarázat ──────────────────────────────────────┐
│                                                    │
│  {HEADLINE from Explanation Weekly}                │
│                                                    │
│  {BODY wrapped to ~52 chars/line,                  │
│  paragraph breaks preserved as blank lines}        │
│                                                    │
│  [Overall confidence: 0.6 MEDIUM]                  │
│                                                    │
└────────────────────────────────────────────────────┘
```

**Rules:**
- Pull `headline` + `body` from Explanation Weekly latest row
- Wrap body to box width (~52 chars inside padding)
- Footer: overall Confidence Engine score for the answer
- If Explanation Weekly is empty → synthesize a 2-sentence narrative from the numbers + matrix trends

### Block 3 — Megbízhatóság

```
┌─ Megbízhatóság ────────────────────────────────────┐
│                                                     │
│               GoogleAds   GA4    MetaAds   SEMrush │
│  Revenue       🟢 78     🟢 89   🟡 48    🔴 18    │
│  Conversions   🟢 85     🟢 82   🟡 46    🔴 14    │
│  Sessions      🔴 24     🟢 92   🔴 20    🟡 44    │
│  ROAS          🟢 80     🟡 60   🟡 54    🔴 10    │
│                                                     │
│  ⚠ Sessions: GA4 and paid sources disagree.        │
│    (variance 68 pts)                                │
│  → Trust GA4 for Sessions. Paid-side counts are    │
│    "sessions-after-ad-click", not total.            │
│                                                     │
│  Dynamically scored — reflects current data         │
│  variance, per DYNAMIC_RELIABILITY_SCORING.md.      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Rules:**
- 4×4 matrix: rows = metrics, cols = sources
- **Scores computed DYNAMICALLY** per `core/methodology/DYNAMIC_RELIABILITY_SCORING.md`:
  - Base rating × agreement factor × 100
  - Base rating table from the methodology doc
  - Agreement factor = 1.0 − deviation-from-median-penalty (see doc §Step 2)
- Emoji thresholds (Confidence Engine mapping):
  - score > 70 → 🟢 (HIGH)
  - 40 ≤ score ≤ 70 → 🟡 (MEDIUM)
  - score < 40 → 🔴 (LOW/UNVERIFIED)
- Compute row with max source-variance (max − min score). If variance > 40:
  - Append warning line: `⚠ {metric}: {highest-source} and {lowest-source} disagree. (variance {N} pts)`
  - Append action line: `→ Trust {highest} for {metric}.` + one-sentence WHY (e.g., attribution-ablak, consent undercount, etc.)
- If a source cannot measure a metric (base rating = 0): skip that cell (render blank or "—"), don't lie by scoring it
- If a source is missing from the account entirely: render column with `❌ NOT CONNECTED`, don't pretend to score
- Append attribution footer: "Dynamically scored — reflects current data variance, per DYNAMIC_RELIABILITY_SCORING.md."

### Block 4 — Mit tegyél

```
┌─ Mit tegyél ────────────────────────────────────────┐
│                                                      │
│  1. {first action — derived from warnings/narrative} │
│  2. {second action}                                  │
│  3. {third action — often a summary/handover item}   │
│                                                      │
│  Confidence-gated: overall answer 0.6 MEDIUM        │
│  → investigate before presenting to stakeholders.    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Rules:**
- 2–4 actions
- Derive from:
  - Megbízhatóság warnings (e.g., if Sessions row has red-red-red → "check tracking config")
  - Narrative body content (control questions surface as actions)
  - Measurement caveats from config (if consent mode flagged → first action: "grosszold fel 1.4×-rel, vagy oldd meg a consent-mode gap-et")
  - Generic hygiene: "forward summary before next meeting"
- **Voice rules (from `core/brand/arcanian/VOICE.md`):**
  - Hierarchy-neutral verbs: *továbbíts*, *ellenőrizd*, *kérdezd meg* — NOT *küldd a vezetődnek*, *jelentsd fölfelé*
  - Concrete verbs, not filler
  - Short imperative form
- **Confidence gating (Confidence Engine §Thresholds + trust-stakes tightening):**
  - Overall ≥ 0.7 → *"Act now."* — actions phrased as direct imperatives
  - 0.4–0.69 → *"Investigate before presenting."* — actions phrased as verification steps
  - 0.2–0.39 → *"Note only; verify first."* — only 1–2 action items, emphasizing data-quality check
  - **< 0.5 special trust-stakes mode:** the block STARTS with *"⚠ Alacsony megbízhatóság — a számokat ellenőrizd, mielőtt bárkinek mutatnád."* Then the usual actions, but phrased as verifications not recommendations.
  - < 0.2 → *"Internal hypothesis only; do not present."* — do not render Block 4 as actions; render as *"Nincs ship-képes javaslat ennyi adatból. Ellenőrzendő:"* + data-collection tasks only.

---

## Voice rules (HU output)

All HU text follows canonical voice rules:
- **Source:** `core/brand/arcanian/VOICE.md`
- **No EN-calque verbs:** *landol* → *érkezik meg*, *drópol* → *ejt*, *csekkol* → *ellenőriz*
- **No EN-calque idioms:** *"háttérben fut"* → *"mögötte áll"*
- **No "normál" as standalone noun** → *szokásos*, *megszokott*, *átlagos*
- **No "ágens"** → always *agent*
- **Adult-to-adult register** — no pedagogical tone, no peer-confessional ("én is")
- **Sorkin-style for narrative peaks** — paradox, inversion, earn the pause
- **No temporal pins** in reusable outputs (no "holnap reggel", no specific weekday assumptions)

## Multi-entity aggregation (Diego case)

When the user's question targets multiple entities ("cégcsoport", "összes Diego"):

1. **Iterate over entities from config** — for each entity, run the full data-pull as a sub-query
2. **Aggregation rules per metric:**
   - Revenue, Spend, Conversions, Sessions → SUM across entities (normalize currency first)
   - ROAS → weighted average by spend: `(sum_revenue / sum_spend)` not simple average
   - Visibility scores, CRs → weighted average by sessions
3. **Cross-entity reliability:**
   - Confidence score per entity per metric (each entity independently scored)
   - Aggregated confidence: `min(entity_confidences)` — the weakest entity caps the answer
4. **Rendering the aggregate:**
   - Block 1 shows the aggregated numbers
   - Block 3 matrix: ONE per entity OR a single summary row per metric
   - Block 2 narrative: must mention which entities contributed and any entity that had a gap
   - Block 4 actions: may be entity-specific ("Diego HU ellenőrzendő", "VRSoft SRL adatok hiányoznak")

**Currency normalization:** if entities use different native currencies (RON, HUF, EUR), convert to the client's `reporting_currency` (from `CLIENT_CONFIG.md` per `core/methodology/CURRENCY_NORMALIZATION.md`) using the priority chain: Databox normalized metric → platform-reported conversion → ECB daily rate → manual rate in config. Always state the rate + date in Block 2 footer. See Prerequisites §1b for the full resolution order and §Output templates Block 1 rules for currency-tag rendering.

**Per-entity gaps:** if an entity is missing a source, the aggregate for that metric is marked `[partial — excludes {entity}]` with confidence penalty applied.

## Error modes

| Situation | Response |
|---|---|
| No `.nexus-config.md` in client dir | Warn user in fallback note, proceed with generic defaults + DEMO account |
| Databox account unreachable | Render error panel: `❌ Databox connection failed. Check MCP auth.` |
| Required source missing | Render Block 3 with `❌` in that column + footer note explaining |
| No data in requested window | Render Block 1 empty state + Block 3 with available sources only + Block 4 action "Verify ingestion" |
| All-sources confidence < 0.2 | Skip Block 4 actions entirely, render only the data-collection verification items |
| Caveat-triggered penalty pushes overall < 0.5 | Block 2 shifts to uncertainty mode; Block 4 adds verification-first tone |
| Multi-entity, one entity unreachable | Aggregate from available entities, mark result `[partial]` with note |
| Ambiguous question, no default | Ask ONE disambiguation, then proceed. Don't ask twice. |
| `reporting_currency` not set in CLIENT_CONFIG | Tag monetary rows with `(?)`, prepend ⚠ Currency UNKNOWN warning, drop monetary-row Conf to MEDIUM max. Do NOT guess. Block 4 action: *"Állítsd be a `reporting_currency`-t a `CLIENT_CONFIG.md`-ben."* |
| Multi-entity, mixed currencies | Convert each to reporting_currency via CURRENCY_NORMALIZATION §Conversion source. State rate + date in Block 2 footer. Stale rate (>7 days) → -0.1 Conf penalty on aggregate monetary rows. |
| Conversion rate missing or unreachable | Render per-entity rows with native currency tags, DO NOT sum. Block 1 footer: `Currency: mixed — aggregate suppressed, no conversion rate available.` |

Never render a half-broken block. Either render fully or show the error state cleanly.

## Related
- **Skill boundary rules** (memory): `~/.claude/.../memory/feedback_skill_privacy_mcp_enumeration.md` — both Rule 1 (account enumeration) and Rule 2 (cross-client file reads)
- **Campaign Registry Standard** (canonical): `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md`
- **`/campaign` skill** (CRUD): `core/skills/campaign.md`
- **Nexus Client Config** (canonical): `core/methodology/NEXUS_CLIENT_CONFIG.md`
- **Dynamic Reliability Scoring** (canonical): `core/methodology/DYNAMIC_RELIABILITY_SCORING.md`
- **Databox Query Routing** (canonical): `core/methodology/DATABOX_QUERY_ROUTING.md`
- **Confidence Engine** (canonical framework): `core/methodology/CONFIDENCE_ENGINE.md`
- **Data Reliability Framework**: `core/methodology/DATA_RELIABILITY_FRAMEWORK.md`
- **Evidence Classification**: `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`
- **Voice rules**: `core/brand/arcanian/VOICE.md`
- **Demo dashboard**: `https://app.databox.com/databoards/view/2104163` (Mosstrail — Multi-Source Pulse)
- **VID-002 dependency**: `internal/video-production/VID-002_diego-welcome/` — SCRIPT.md Beat 2–4 capture uses this skill's live output

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-21 | Initial — integrates Confidence Engine Source Confidence dimension. Default DEMO account. 4-block output contract. |
| v1.1 | 2026-04-21 | Genie-first routing per DATABOX_QUERY_ROUTING.md. Added ask_genie to allowed-tools. Explicit dataset IDs + sample queries per block. Fixes empty-list_metrics on custom-ingested sources. |
| v1.2 | 2026-04-21 | **Dynamic reliability scoring** per DYNAMIC_RELIABILITY_SCORING.md. Block 3 matrix computed live from cross-source variance, not pulled from stored dataset. Static pushed Reliability Matrix now legacy cache / dashboard-only. Base ratings × agreement factor replaces static scores. |
| v1.3 | 2026-04-21 | **Real-data readiness:** (a) `.nexus-config.md` pattern + NEXUS_CLIENT_CONFIG.md canonical — loads entities, campaign windows, measurement caveats from client dir. (b) Multi-entity routing — entity resolution, aggregation, currency-normalized cross-entity metrics. (c) Live Claude-composed Block 2 narrative — no longer depends on pushed Explanation Weekly. (d) Trust-stakes tightening — confidence < 0.5 triggers verification-mode; < 0.2 suppresses action rendering. (e) Window disambiguation via config + ask-back. |
| v1.4 | 2026-04-21 | **Privacy hardening — CRITICAL**: removed `mcp__databox__list_accounts` from allowed-tools; added explicit rule forbidding account-enumeration in any output. Ask-back disambiguation options must not list accessible accounts — use only windows from the active `.nexus-config.md` or ask the user to name their client explicitly. Caught during shared-flavor test where option 4 previously leaked client account names (Diego, Wellis, Codeguru, etc.) visible to the practitioner's MCP auth. |
| v1.5 | 2026-04-21 | **Campaign Registry integration**: window resolution now reads CAMPAIGN_REGISTRY.md first (standardized per-client campaign registry), falling back to inline `.nexus-config.md` windows only if registry absent. Supports aliases, id-match, name_short-match, ambiguity disambiguation. When no match: offers `/campaign add` suggestion to register new campaigns. |
| v1.6 | 2026-04-21 | **Boundary hardening — CRITICAL**: added explicit Rule 2 prohibiting cross-client file reads and emergent cache-surfacing. Skill only reads `.nexus-config.md` + `CAMPAIGN_REGISTRY.md` in the CURRENT working directory. Caught during shared-flavor test where a Glamour query from hub autonomously read `clients/diego/docs/campaigns/*.md` — non-reproducible, privacy-blurring, freshness-lying. Resolution: strict CWD boundary. File-search is a separate skill's job (tbd /find-analysis). |
| v1.7 | 2026-04-22 | **DEMO virtual-client fallback**: hub/unknown context now reads `clients/_demo/.nexus-config.md` + `clients/_demo/CAMPAIGN_REGISTRY.md` as authoritative fallback, instead of hardcoded account ID. DEMO is treated like any other client (single entity, pre-registered campaigns matching synthetic data). Benefits: (a) hub queries like "Hogyan teljesített a Glamour kampány?" auto-resolve via DEMO registry, no disambiguation required, (b) synchronized between synthetic data push + campaign window references, (c) removes the need for Beat 1.5 "Visszakérdez" scene in VID-002 (script simplified). Rule 2 still applies — skill only reads the active config directory (DEMO in this case), never crosses into other clients' files. |
| v1.8 | 2026-04-22 | **Window resolution four-phase protocol + mandatory Phase C persistence**: replaced the loose 5-step resolution order with an explicit Phase A (files) → Phase B (one ask-back) → Phase C (write result to `CAMPAIGN_REGISTRY.md` BEFORE data pull) → Phase D (hard prohibition on data-pattern inference) contract. Caught during shared-flavor test where the skill inferred a 4-day "revenue plateau" as a promo window instead of asking, resulting in a fictional BLUF (script review flagged both the inference AND the fact that next session would re-ask the same question because no persistence happened). Skill §Steps §1 shorthand realigned to reference the phase numbers. Companion change: `CAMPAIGN_REGISTRY_STANDARD.md §Auto-registration from disambiguation` (canonical rule). |
| v1.9 | 2026-04-22 | **Mandatory currency annotation per `CURRENCY_NORMALIZATION.md`**: added Prerequisites §1b (reporting_currency resolution order: CLIENT_CONFIG → DOMAIN_CHANNEL_MAP → .nexus-config → DEMO → unknown); Block 1 monetary rows now REQUIRED to carry `(CUR)` tag (`(?)` + ⚠ warning when currency unresolved); unknown-currency rows take -0.2 Source Confidence penalty (HIGH → MEDIUM); Block 1 footer gets mandatory `Currency: {CUR} ({source})` line; cross-currency multi-entity aggregation must disclose rate + date in Block 2 footer; §Multi-entity aggregation updated to reference canonical `reporting_currency` field (not stale `primary_currency` alias) and CURRENCY_NORMALIZATION's conversion-source priority chain; Error modes table extended with 3 currency-related rows. Caught during shared-flavor script review where Block 1 rendered `399,446` unitless — the exact failure mode CURRENCY_NORMALIZATION §Problem describes ("summing raw numbers across currencies produces nonsense"; worse here: rendering a number without ANY currency leaves the reader to guess). |
| v1.10 | 2026-04-22 | **Rule 2 refinement — explicit-naming permits cross-client reads**: revised the strict CWD-boundary (v1.6) which proved too restrictive in practice. Added Phase A.0 "Active-client resolution" — when the question contains an explicit client name AND `clients/{slug}/` exists, that dir becomes the active scope (read its `.nexus-config.md` + `CAMPAIGN_REGISTRY.md`). Hard prohibitions retained: NO autonomous fuzzy-match auto-pick, NO multi-client merge, NO globbing for cached analyses, NO account/client enumeration. Reasoning: the original Rule 2 risks (non-reproducibility, privacy-blurring, freshness-lying) all stem from autonomous picking — explicit naming neutralizes them. The filesystem (read-permission) is the security layer, not the skill. Caught during shared-flavor test where typed query *"Mosstrail akciós időszaka"* from hub got refused with "cd clients/mosstrail" ceremony, despite the practitioner having direct read access to that dir anyway. |
