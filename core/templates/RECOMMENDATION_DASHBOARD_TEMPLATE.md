> v1.0 — 2026-04-03
> Databox dashboard design for recommendation effectiveness tracking.

# Recommendation Effectiveness Dashboard — Template

> **Purpose:** Make the closed-loop feedback system visible. Show whether recommendations actually moved the numbers.
> **Data source:** AOS Recommendation Outcomes (create via `create_data_source` — see `core/agents/outcome-tracker.md`)
> **Datasets:** Recommendation Outcomes + REC Hit Rate Summary (create via `create_dataset`)

---

## Dashboard Layout (Databox Datawall)

### Row 1: Summary KPIs (4 number blocks)

| Block | Metric | Source | Filter |
|---|---|---|---|
| **Total RECs** | Count of all rec_id | Dataset 1 | client = {current} |
| **Hit Rate** | cumulative_hit_rate_pct | Dataset 2 | Latest week, client = {current} |
| **Avg Impact** | avg(change_pct) where status = confirmed | Dataset 1 | client = {current} |
| **Open RECs** | Count where status = open or in_progress | Dataset 1 | client = {current} |

### Row 2: Hit Rate Over Time (line chart)

| Field | Value |
|---|---|
| **Metric** | hit_rate_pct |
| **Dimension** | week |
| **Filter** | client = {current} |
| **Goal line** | 40% (industry baseline for marketing recommendations) |

### Row 3: REC Status Breakdown (pie/donut chart)

| Field | Value |
|---|---|
| **Metric** | Count of rec_id |
| **Dimension** | status |
| **Filter** | client = {current} |
| **Colors** | confirmed = green, no_effect = red, too_early = amber, open = grey, invalidated = dark red |

### Row 4: Individual RECs (table)

| Column | Source |
|---|---|
| REC ID | rec_id |
| Metric Targeted | metric_targeted |
| Status | status |
| Before | metric_before |
| After | metric_after |
| Change % | change_pct |
| Confidence | confidence |
| Created | created_date |
| Outcome Date | outcome_date |

Sort by: outcome_date desc. Filter: client = {current}.

### Row 5: Cross-Client Comparison (if hub view)

| Block | Metric |
|---|---|
| **Client Hit Rate Ranking** | cumulative_hit_rate_pct by client, latest week |
| **Most Effective REC Type** | metric_targeted dimension, filtered to status = confirmed, count |

---

## Setup Instructions

1. In Databox, create a new Datawall
2. Add data source: "AOS Recommendation Outcomes" (the one you created via outcome-tracker setup)
3. For each block above, add a Datablock and configure metric + filter
4. Set date range: Last 90 days (rolling)
5. Share with client (optional — hide confidence column for client-facing view)

## When to Use

- During `/client-report` — embed hit rate KPI
- During Council deliberations — check which recommendation types work best
- During `/day-start` and `/morning-brief` — surface any newly confirmed or invalidated RECs
- Quarterly reviews — trend analysis of recommendation effectiveness

## References
- `core/agents/outcome-tracker.md` — pushes data to these datasets
- `core/methodology/RECOMMENDATION_DEDUP_RULE.md` — uses hit rate data
- `core/templates/RECOMMENDATION_LOG_TEMPLATE.md` — source of truth per client
