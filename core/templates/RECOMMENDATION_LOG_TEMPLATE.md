> v1.0 — 2026-04-03
> Per-client file location: `clients/{slug}/RECOMMENDATION_LOG.md`

# Recommendation Log — {Client Name}

> Every REC created by any skill or agent is logged here.
> Outcome Tracker agent updates status weekly.
> Skills check this before recommending — see `core/methodology/RECOMMENDATION_DEDUP_RULE.md`.

---

## Log

| REC ID | Date | Metric Targeted | Expected Impact | Created By | Executed By Task | Status | Outcome Date | Notes |
|---|---|---|---|---|---|---|---|---|
| REC-001 | YYYY-MM-DD | metric name | what we expected | skill/agent | #task-id | open | — | |

## Status Values

| Status | Meaning |
|---|---|
| `open` | Recommended, not yet executed |
| `in_progress` | Task created, work underway |
| `confirmed` | Metric improved as expected — recommendation worked |
| `no effect` | Executed, but metric did not change meaningfully |
| `too early` | Executed, but not enough time has passed to measure |
| `invalidated` | Evidence shows recommendation was wrong or conditions changed |
| `superseded` | Replaced by a newer recommendation |

## Outcome Tracking

The `outcome-tracker` agent (weekly):
1. Pulls current metric value for each `in_progress` or `too early` REC
2. Compares against baseline (from `data/BASELINES.md`) and expected impact
3. Updates status: `confirmed` / `no effect` / `too early` / `invalidated`
4. Links outcome date and notes

## References
- `core/methodology/RECOMMENDATION_DEDUP_RULE.md`
- `core/methodology/CONFIDENCE_ENGINE.md`
- `core/agents/outcome-tracker.md`
- Per-client `data/BASELINES.md`
