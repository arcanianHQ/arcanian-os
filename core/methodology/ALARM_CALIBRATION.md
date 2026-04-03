> v1.0 — 2026-04-03

# System Rule: Alarm Calibration (Mindset-Tuner)

> **SYSTEM-WIDE RULE** — applies to `/health-check`, `/morning-brief`, scheduled monitoring, and any anomaly detection.
> "A 15% drop is noise for one client and a crisis for another. Calibrate before alarming."

---

## The Problem

The system detects anomalies (metric drops, spend spikes, conversion changes) and creates tasks. But not all clients have the same tolerance:
- A volatile e-commerce brand with seasonal swings tolerates ±25% weekly variance
- A stable SaaS with predictable MRR panics at ±10%
- A new market launch expects wild swings — flagging every one wastes attention

Without calibration, the system either:
- Cries wolf (too sensitive) → client ignores alerts → misses real issues
- Stays silent (too loose) → real problems go undetected

## Client Sensitivity Configuration

Set in `CLIENT_CONFIG.md`:

```markdown
## Monitoring
alarm_sensitivity: normal
```

| Level | Threshold Multiplier | Who this is for |
|---|---|---|
| `low` | 2.0x baseline std dev | Volatile businesses, seasonal markets, new launches. Only flag dramatic changes. |
| `normal` | 1.5x baseline std dev | Default. Most established clients. |
| `high` | 1.0x baseline std dev | Stable businesses, risk-averse clients, compliance-sensitive. Flag early. |

If not set: default to `normal`.

## How It Works

1. **Baseline** provides: metric average + standard deviation (from `data/BASELINES.md`)
2. **Alarm calibration** applies the multiplier:
   ```
   alert_threshold = baseline_avg ± (std_dev × multiplier)
   ```
3. **If metric falls outside threshold:** flag it
4. **If metric is within threshold:** log it, don't alert

### Example

Metric: Weekly Google Ads conversions
Baseline: avg 120, std dev 25

| Sensitivity | Threshold | Alert if below | Alert if above |
|---|---|---|---|
| `high` (1.0x) | 120 ± 25 | < 95 | > 145 |
| `normal` (1.5x) | 120 ± 37.5 | < 82.5 | > 157.5 |
| `low` (2.0x) | 120 ± 50 | < 70 | > 170 |

## Per-Metric Override

Some metrics deserve different sensitivity than the client default. Set in `data/BASELINES.md`:

```markdown
| Metric | 30d Avg | Std Dev | Sensitivity Override | Notes |
|---|---|---|---|---|
| GA4 sessions | 12,400 | 2,100 | — | Uses client default |
| Google Ads ROAS | 6.8 | 1.2 | high | Client watches this closely |
| Email open rate | 22% | 4% | low | Naturally volatile |
```

## Tone Calibration (Report Language)

Beyond thresholds, alarm sensitivity affects how findings are written:

| Sensitivity | Language for a 20% drop |
|---|---|
| `low` | "Sessions declined 20% WoW — within expected variance for this market. Monitor next week." |
| `normal` | "Sessions declined 20% WoW — outside normal range. Investigating potential causes." |
| `high` | "Sessions declined 20% WoW — significant deviation. Immediate investigation recommended. Task created." |

This connects to `TONE_REGISTRY.md` — alarm calibration determines WHAT to say, tone registry determines HOW to say it (formal/informal, tegezés/magázás, etc.).

## Task Creation Rules

| Confidence (from CONFIDENCE_ENGINE) | Within threshold? | Action |
|---|---|---|
| HIGH + outside threshold | No | Create task automatically, flag to client |
| HIGH + within threshold | Yes | Log only, no task |
| MEDIUM + outside threshold | No | Create internal task, investigate before flagging |
| LOW + outside threshold | No | Log observation, do not create task |
| Any + within threshold | Yes | No action |

## Connection to Other Systems

- **BASELINES.md** — provides the avg and std dev. No baseline = no anomaly detection.
- **CONFIDENCE_ENGINE.md** — confidence score determines whether to act on the anomaly.
- **TONE_REGISTRY.md** — how to communicate the finding to this client/person.
- **Sync Delay Intelligence** — check if the "anomaly" is just stale data before alerting.

## References
- `core/methodology/CONFIDENCE_ENGINE.md`
- `core/methodology/TONE_REGISTRY.md`
- Per-client `CLIENT_CONFIG.md` (`alarm_sensitivity`)
- Per-client `data/BASELINES.md`
