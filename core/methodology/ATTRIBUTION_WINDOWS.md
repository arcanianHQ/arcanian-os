> v1.0 — 2026-04-03

# System Rule: Attribution Window Awareness

> **SYSTEM-WIDE RULE** — applies to ALL cross-platform conversion comparisons.
> "Google Ads 'conversions' and Meta 'conversions' are not the same number measured differently. They are different numbers measuring different things."

---

## The Problem

Each ad platform uses a different default attribution window. When you compare "Google Ads conversions" to "Meta conversions," you're comparing:
- Google: 30-day click + 1-day view (default)
- Meta: 7-day click + 1-day view (default)
- GA4: session-based or data-driven (no fixed window)

A conversion attributed to Google Ads on day 28 post-click would never appear in Meta's numbers even if the user saw a Meta ad first. Cross-platform conversion totals will always exceed actual conversions due to double-counting.

## Platform Default Windows

| Platform | Default Click Window | Default View Window | Model | Notes |
|---|---|---|---|---|
| **Google Ads** | 30 days | 1 day (display/video) | Last-click or data-driven | Can be changed per conversion action |
| **Meta Ads** | 7 days | 1 day | Last-touch within window | Changed from 28d→7d in 2021. Clients may have custom settings |
| **GA4** | 90 days (acquisition), 30 days (other) | None | Data-driven, last-click, or first-click | Depends on attribution model selected |
| **Shopify** | Session-based | None | Last-click (built-in) | Only counts direct session conversions |
| **TikTok Ads** | 7 days | 1 day | Last-touch | Similar to Meta |
| **Pinterest Ads** | 30 days | 1 day | Last-touch | |
| **Microsoft Ads** | 30 days | 1 day | Last-click | |
| **ActiveCampaign** | N/A | N/A | Email-attributed | Uses UTM or direct link click |

## How to Check Client Overrides

Clients may have changed default windows. Always verify:

| Platform | Where to check |
|---|---|
| Google Ads | Admin → Conversions → each conversion action → Attribution settings |
| Meta | Events Manager → each event → Attribution setting |
| GA4 | Admin → Attribution settings → Reporting/Acquisition windows |
| TikTok | Events → each event → Attribution window |

Document client-specific overrides in `CLIENT_CONFIG.md`:

```markdown
## Attribution Windows (verified 2026-04-03)
- Google Ads: 30d click / 1d view (default)
- Meta: 7d click / 1d view (default)
- GA4: 30d acquisition, data-driven model
```

## Rules for Cross-Platform Analysis

### 1. Never sum platform conversions
```
WRONG: Google conversions (450) + Meta conversions (280) = 730 total conversions
RIGHT: GA4 total conversions: 520. Google claims 450, Meta claims 280.
       Overlap estimated at ~30% based on attribution window differences.
```

### 2. Always state the window when comparing ROAS
```
WRONG: Google ROAS 8.2x vs Meta ROAS 4.1x → Google wins
RIGHT: Google ROAS 8.2x (30d click) vs Meta ROAS 4.1x (7d click).
       If Meta used 30d window, its ROAS would likely be higher.
       [Confidence: MEDIUM — window difference makes direct comparison unreliable]
```

### 3. Use GA4 as the arbitrator (with caveats)
GA4 provides a single attribution model across all traffic sources. Use it as the cross-platform comparison baseline — but note:
- GA4 has its own attribution model (data-driven or last-click)
- Consent mode may undercount by 30-66%
- GA4 may not see all conversions that platforms self-attribute

### 4. Flag window mismatches in output
When any analysis compares conversions or ROAS across platforms:

```markdown
⚠️ **Attribution window mismatch:** Google Ads (30d click) vs Meta (7d click).
Direct ROAS comparison is unreliable. Use GA4 as cross-platform baseline.
```

## Connection to Confidence Engine

Attribution window mismatch reduces Source Confidence for cross-platform claims:
- Same window or single platform: no penalty
- Different windows, acknowledged: MEDIUM confidence cap
- Different windows, not acknowledged: analysis is invalid

## References
- `core/methodology/CONFIDENCE_ENGINE.md`
- `core/methodology/DATA_RELIABILITY_FRAMEWORK.md`
- `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`
- Per-client `CLIENT_CONFIG.md` (attribution window overrides)
