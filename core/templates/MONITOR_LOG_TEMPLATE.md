> v1.0 — 2026-04-03
> Per-client file location: `clients/{slug}/data/MONITOR_LOG.md`

# Monitor Log — {Client Name}

> Log of all scheduled monitoring runs. Append-only.
> Each entry: what ran, what it found, what it did.

---

## Log

| Date | Agent/Skill | Scope | Anomalies Found | Tasks Created | Notes |
|---|---|---|---|---|---|
| YYYY-MM-DD HH:MM | /health-check | all domains | 0 | 0 | Clean run |

## Entry Format

For runs that find anomalies, expand below the table:

```markdown
### 2026-04-03 08:00 — /health-check (daily)

**Anomalies:**
- GA4 sessions (solarnook.com): 8,200 — baseline avg 12,400, threshold 10,300 (normal sensitivity)
  [Confidence: MEDIUM — checked sync lag: GA4 current, no delay]
  → Task created: #142 "Investigate solarnook.com session drop"

- Google Ads ROAS (example-pool.com): 4.2 — baseline avg 6.8, threshold 5.6
  [Confidence: LOW — Shopify sync lag 48h, revenue may be incomplete]
  → No task created (confidence too low, recheck after sync)

**No anomalies:** Meta ROAS, Shopify orders, AC contacts, email rates — all within thresholds.
```

## References
- `core/methodology/ALARM_CALIBRATION.md`
- `core/methodology/CONFIDENCE_ENGINE.md`
- Per-client `data/BASELINES.md`
