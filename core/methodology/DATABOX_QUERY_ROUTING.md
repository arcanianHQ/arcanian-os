---
scope: shared
---

> v1.0 — 2026-04-21

# Databox Query Routing

> **Canonical rule** — every skill, agent, or workflow that queries Databox data must follow this routing. Duplicating the logic inline is fine; *deviating from it* means you've probably missed a corner case.

> **Position in the routing stack**: this rule applies AFTER `core/methodology/QUESTION_ROUTING.md` has classified the question and decided that Databox is the applicable tool. Routing is a top-down concern:
> 1. `QUESTION_ROUTING.md` — which category, which MCP tools, which data sources
> 2. This rule — within Databox, which query method (ask_genie vs load_metric_data)
> 3. `DYNAMIC_RELIABILITY_SCORING.md` — after data arrives, how to score the sources
>
> Don't invert. Don't skip layers.

---

## The Problem

Databox has **three data-source topologies** that present different access patterns:

| Topology | How data arrives | How to query |
|---|---|---|
| **OAuth-integrated source** (GA4, Meta Ads via Meta connector, Shopify connector) | Databox pulls on a schedule via platform API | `load_metric_data(metric_key=...)` with well-defined metric_keys |
| **Custom ingested source** (Push custom data type) | You push raw rows via `ingest_data` into a dataset | `load_metric_data` only works if a Custom Metric has been created on the dataset; otherwise use `ask_genie(dataset_id, question)` |
| **Hybrid** (OAuth source with Custom Metrics layered on top) | Mixed | Try `load_metric_data` first using Custom Metric keys, fall back to `ask_genie` on the underlying dataset |

The failure mode: calling `load_metric_data` on a Custom ingested source with no Custom Metrics returns empty, and skills misdiagnose as "no data" when the data is actually there.

---

## Routing decision tree

```
query Databox
│
├─ data source type?
│
├─ OAuth-integrated (e.g. GoogleAnalytics4)
│   ↓
│   list_metrics(data_source_id) → non-empty
│   ↓
│   use load_metric_data(metric_key from list_metrics)
│
└─ Custom "Push custom data" (ingestion type)
    ↓
    list_metrics(data_source_id) → empty OR returns only Custom Metrics
    ↓
    ├─ Custom Metric exists for the desired slice?
    │   ↓
    │   use load_metric_data(metric_key = Custom Metric's key)
    │
    └─ No Custom Metric exists for this slice
        ↓
        use ask_genie(dataset_id, natural-language question)
        │
        └─ If you'll need this slice repeatedly across skills:
            → create a Custom Metric (manually in Databox Designer)
            → future calls can use load_metric_data
```

---

## Detection — which topology am I dealing with?

**Quick check:**

```python
# Pseudocode
metrics = list_metrics(data_source_id)
if metrics is not empty:
    # OAuth-integrated OR has Custom Metrics
    # Check source type via list_data_sources metadata
    source = find_source(data_source_id)
    if source.type == "ingestion":
        # Custom ingested with Custom Metrics — use those metric_keys
        path = "custom_with_metrics"
    else:
        # OAuth-integrated — use native platform metric_keys
        path = "oauth"
else:
    # Custom ingested, no Custom Metrics defined yet
    path = "genie_fallback"
```

**Confirmed signals:**

- `list_data_sources` returns objects with `.type = "ingestion"` → custom push
- `list_data_sources` returns objects with `.type != "ingestion"` → OAuth/native integration
- `list_metrics` returns empty on an ingestion source → no Custom Metrics yet
- `list_data_source_datasets` returns datasets with IDs → custom data is queryable via `ask_genie(dataset_id, ...)`

---

## Path 1 — OAuth-integrated source

```
metric_key format: "{PlatformName}@{metric_name}"
example:           "GoogleAnalytics4@sessions"
                   "FacebookAds@spend"
                   "Shopify@total_sales"

load_metric_data(
    data_source_id=...,
    metric_key="GoogleAnalytics4@sessions",
    start_date="2026-02-01",
    end_date="2026-04-01",
    granulation_time_unit=2  # daily
)
```

Returns structured series data directly. Best for known metrics.

---

## Path 2 — Custom ingested source with Custom Metrics

When a Custom Metric has been defined in Databox UI:

```
metric_key format: "{data_source_id}|custom_query_{N}"
                   "{data_source_id}|script_{N}"
example:           "4952873|custom_query_17"

list_metrics(data_source_id=4952873)
→ [{metric_key: "4952873|custom_query_17", name: "Megbízhatóság — Score", ...}]

load_metric_data(data_source_id=4952873, metric_key="4952873|custom_query_17", ...)
```

The Custom Metric embeds its own aggregation + dimension logic (LATEST, breakdown, filters). You query it as a named metric.

---

## Path 3 — Custom ingested source WITHOUT Custom Metrics (Genie fallback)

This is the fallback for freshly-pushed datasets, or when the Custom Metric you need doesn't exist yet.

```
# Get dataset_id from list_data_source_datasets or from the ingest_data response
dataset_id = "78272e0b-54e3-4fcd-a56d-4ab3ecc64135"  # Meta Ads Daily

# Query in natural language
ask_genie(
    dataset_id=dataset_id,
    question="What is the total spend, conversions, revenue, and ROAS for 2026-03-19 to 2026-04-01? Also give me the same for 2026-03-05 to 2026-03-18 for comparison."
)
# Returns { answer: "Total spend was $5,614.89 in the 14-day promo window... ROAS = ...", thread_id: "..." }
```

**Genie best practices:**

1. **Resolve relative dates FIRST** via `get_current_datetime()` — Genie needs absolute dates
2. **Ask for structured output** — "Give me: X = value, Y = value" beats "How did we perform?"
3. **Request comparisons in one call** — "period A vs period B" saves round-trips
4. **Use `thread_id`** for follow-ups on the same dataset (avoid re-exploring schema each time)
5. **Genie can do SQL** — complex pivots, filters, aggregations all work

**Anti-patterns:**

- Don't start with "what columns are there" every time — Genie re-explores schema. Ask the specific question directly.
- Don't ask multiple datasets in one call — Genie takes one `dataset_id`.

---

## Output normalization

Whatever path you take, normalize the response into a common structure so downstream code doesn't care which route you used:

```python
# Target structure
{
    "metric": "spend",
    "source": "MetaAds",
    "current_period": {"start": "2026-03-19", "end": "2026-04-01", "value": 5614.89},
    "previous_period": {"start": "2026-03-05", "end": "2026-03-18", "value": 6900.04},
    "delta_pct": -18.6,
    "source_confidence": 0.6,   # from Confidence Engine mapping
}
```

This makes it trivial for skills to render the data in their own formats (ASCII boxes, markdown tables, inline prose, etc.).

---

## Confidence Engine integration

Every data point returned through this routing carries a **Source Confidence** score derived from the Reliability Matrix (if available) or canonical DATA_RELIABILITY_FRAMEWORK.md defaults.

Skills consuming this data:
- Must surface the confidence score (inline `[Conf: X.X]` tag)
- Must gate actions by Confidence Engine thresholds (≥0.7 act, 0.4-0.69 flag, <0.4 note, <0.2 do not present)

See: `core/methodology/CONFIDENCE_ENGINE.md`

---

## Skills using this pattern

| Skill | Databox query purpose |
|---|---|
| `/nexus-answer` | Full 4-block data answer for business performance queries |
| `/morning-brief` | Daily metric summaries + anomaly flags |
| `/health-check` | Cross-client threshold scanning |
| `/map-results` | Performance mapping per client |
| `/measurement-audit` | Data integrity verification |
| `/analyze-gtm` | Channel-level analysis |

Add new skills to this list as they're built.

---

## Future: elevation to dedicated skill

If >3 skills duplicate this routing inline, promote it to `/databox-fetch` — a shared skill that:
- Takes a high-level request (data_source, metric, time window, comparison)
- Applies this routing internally
- Returns normalized output
- Consumed by other skills via the Skill tool

Don't elevate early. The current scope (3-5 skills at initial build) is fine with inline pattern + this canonical doc.

---

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-21 | Initial — extracted from /nexus-answer build while solving empty `list_metrics` on ingested sources. Covers 3 paths: OAuth, Custom with Metrics, Genie fallback. |
