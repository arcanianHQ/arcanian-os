> v1.0 — 2026-04-03
> Per-client file location: `clients/{slug}/data/BASELINES.md`

# Metric Baselines — {Client Name}

> Auto-refreshed weekly by `/health-check` or scheduled agent.
> Manual override: set `override: yes` to prevent auto-refresh for that metric.
> No baseline = no anomaly detection for that metric.

---

## Baselines

| Metric | Source | 30d Avg | Std Dev | Last Updated | Sensitivity Override | Notes |
|---|---|---|---|---|---|---|
| GA4 sessions | GA4 | — | — | — | — | |
| Google Ads conversions | Google Ads | — | — | — | — | |
| Google Ads ROAS | Google Ads | — | — | — | — | |
| Meta conversions | Meta Ads | — | — | — | — | |
| Meta ROAS | Meta Ads | — | — | — | — | |
| Shopify orders | Shopify | — | — | — | — | |
| Shopify revenue | Shopify | — | — | — | — | |
| AC contacts (active) | ActiveCampaign | — | — | — | — | |
| Email open rate | ActiveCampaign | — | — | — | — | |
| Email click rate | ActiveCampaign | — | — | — | — | |

## How to Use

- **Add metrics** relevant to this client. Not every client has every source.
- **Sensitivity override:** `high`, `normal`, `low`, or blank (uses client default from CLIENT_CONFIG.md `alarm_sensitivity`).
- **30d Avg / Std Dev:** calculated from last 30 days of data via Databox or platform API.
- **Last Updated:** date of most recent baseline refresh. Baselines older than 30 days are stale — flag in `/health-check`.

## Anomaly Detection

```
alert_threshold = 30d_avg ± (std_dev × sensitivity_multiplier)
```

Multipliers (from ALARM_CALIBRATION.md):
- `high` = 1.0x
- `normal` = 1.5x (default)
- `low` = 2.0x

## References
- `core/methodology/ALARM_CALIBRATION.md`
- `core/methodology/CONFIDENCE_ENGINE.md`
- Per-client `CLIENT_CONFIG.md` (`alarm_sensitivity`)
