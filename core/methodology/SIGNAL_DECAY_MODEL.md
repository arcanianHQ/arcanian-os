---
scope: shared
---

> v1.0 --- 2026-04-10

# Signal Decay Model

> Leads go cold mathematically, not just by gut feeling.
> A signal that was hot 90 days ago is noise today. This model makes that explicit.

Inspired by Revenue Architects' GTM Engineering pattern (signal freshness curves), adapted for Arcanian's marketing ops context.

---

## Score Formula

```
lead_score = SUM( signal_weight × freshness_factor )

where:
  freshness_factor = 0.5 ^ (days_since_signal / half_life)
```

Each signal in a lead's timeline contributes to the total score. Recent, high-weight signals dominate. Old signals decay toward zero.

**Cutoff rule:** Any signal older than 3× its half_life contributes 0 (treated as expired).

---

## Signal Types & Parameters

| Signal Type | Weight (1-10) | Half-life (days) | Cutoff (3× half-life) | Example |
|---|---|---|---|---|
| Direct reply / DM | 10 | 90 | 270d | Lead replies to our email or DMs on LinkedIn |
| Funding event | 9 | 60 | 180d | Company raises a round, press release |
| Job change | 8 | 30 | 90d | Decision maker changes role or company |
| Platform mention of us | 6 | 21 | 63d | Someone tags Arcanian or shares our content |
| Content engagement (like/comment) | 3 | 14 | 42d | Likes or comments on our LinkedIn post |
| Website visit | 2 | 7 | 21d | Visits arcanian.com (if trackable) |
| Email open (no reply) | 1 | 3 | 9d | Opens our email but doesn't respond |

---

## Score Thresholds

| Score Range | Classification | Meaning |
|---|---|---|
| **> 30** | Hot | Active engagement, prioritize outreach |
| **10 -- 30** | Warm | Interest present but not urgent |
| **< 10** | Cold | Decayed or minimal engagement |

---

## P0/P1/P2 Signal Trigger Mapping

When `SIGNAL_DETECTION_RULE.md` fires on a tracked profile who also has a `LEAD_STATUS.md`:

| Signal Priority | Instantaneous Score Boost | Rationale |
|---|---|---|
| P0 | +15 | High-value relationship, every interaction counts |
| P1 | +8 | Relevant engagement, worth tracking |
| P2 | +4 | Relationship building, incremental value |

The boost is treated as a new signal entry with weight = boost value and half_life = 30 days (decays like a job change signal).

---

## Recalculation Schedule

- **Daily:** `/morning-brief` recalculates all active leads (not Won/Lost) as part of Step 5b (Lead Score Refresh)
- **On signal detection:** When SIGNAL_DETECTION_RULE fires and matches a lead, recalculate immediately
- **On manual update:** When LEAD_STATUS.md is edited, recalculate on next morning-brief

---

## Score Trend

Track the 7-day rolling direction:

| Trend | Symbol | Trigger |
|---|---|---|
| Rising | ↑ | Score increased > 5 pts in 7 days |
| Stable | → | Score change ≤ 5 pts in 7 days |
| Falling | ↓ | Score decreased > 5 pts in 7 days |

**Alert rule:** A lead whose score crosses a threshold boundary (Hot→Warm, Warm→Cold) gets flagged in `/morning-brief`.

---

## Stage Gate Integration

| Lead Stage | Minimum Score to Advance | Rationale |
|---|---|---|
| Discovery → Diagnosed | No minimum | We're investing research time, not their attention |
| Diagnosed → Pitched | ≥ 15 | Don't send materials to a cold lead |
| Pitched → Negotiating | ≥ 20 | Active engagement signals required before negotiation |
| Negotiating → Won | No minimum | Decision is theirs at this point |

**Override:** Stage gates can be overridden with explicit note: `Stage gate override: [reason]` in LEAD_STATUS.md timeline.

---

## LEAD_STATUS.md Template Addition

Add to the Status table in every LEAD_STATUS.md:

```markdown
| **Lead Score** | {number} |
| **Last Scored** | YYYY-MM-DD |
| **Score Trend** | ↑ / → / ↓ |
```

Add a Signal Log section:

```markdown
## Signal Log

| Date | Signal Type | Weight | Detail | Expires |
|---|---|---|---|---|
| 2026-04-10 | Content engagement | 3 | Liked our LinkedIn post on measurement | 2026-05-22 |
| 2026-04-05 | Direct reply | 10 | Replied to Prism pitch email | 2026-12-31 |
```

---

## Worked Example

Lead "Euronics" on 2026-04-10:
- 2026-04-05: Direct reply (weight=10, half_life=90, days_since=5) → 10 × 0.5^(5/90) = 10 × 0.962 = **9.62**
- 2026-03-20: Content engagement (weight=3, half_life=14, days_since=21) → 3 × 0.5^(21/14) = 3 × 0.354 = **1.06**
- 2026-02-01: Job change (weight=8, half_life=30, days_since=68) → 8 × 0.5^(68/30) = 8 × 0.203 = **1.62**
- 2025-12-15: Email open (weight=1, half_life=3, days_since=116) → EXPIRED (> 9d cutoff) = **0**

**Total: 12.30 → Warm ↓ (was 22.4 last week)**

---

## Integration Points

- `LEAD_TRACKING_STANDARD.md` → references this model for scoring rules
- `SIGNAL_DETECTION_RULE.md` → triggers score update on signal detection
- `/morning-brief` → Step 5b recalculates and flags threshold crossings
- `/manage-client` → can display score in client dashboard view
- `ENRICHMENT_WATERFALL.md` → stage gates reference minimum scores

---

*What did we get wrong? What signals are missing from this model? What half-lives feel off?*
