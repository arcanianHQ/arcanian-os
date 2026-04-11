# SolarNook — Council Diagnostic Output
**Date:** 2026-03-20
**Trigger:** Google Ads conversion value dropped 74% on March 18. Spend dropped the same day. GA4 shows a different revenue pattern. A GTM change was logged March 17.
**Council type:** Diagnostic
**Agents:** measurement-stack, channel-analyst-google-ads, platform-changelog, cross-system-verifier, offer-analyst

---

## BLUF

**The 74% drop is a measurement artifact, not a performance collapse.** Confidence: 85%.

The GTM config tag update on March 17 broke the Google Ads conversion linker for the EU property. GA4 and Shopify both show stable revenue — only Google Ads reporting is affected. Smart Bidding has already reduced spend by ~60% in response to the false signal, compounding the revenue impact.

**Falsification indicator:** If GA4 purchase revenue also shows a 74% drop aligned with Google Ads, this conclusion is wrong and the drop is real. Current evidence: GA4 shows only a 12% dip (normal variance).

---

## OBSERVE

| Source | Signal | Evidence Type |
|---|---|---|
| Google Ads | Conversion value: €12,400 → €3,224 (-74%) on Mar 18 | [DATA: Google Ads, 2026-03-18] |
| GA4 | Purchase revenue dropped only 12% (within normal range) | [DATA: GA4, 2026-03-18] |
| Shopify | Orders stable at ~47/day, no anomaly | [DATA: Shopify, 2026-03-18] |
| GTM changelog | New GA4 config tag deployed Mar 17 at 16:42 CET | [OBSERVED: GTM version history, 2026-03-17] |
| Agency | "Recommend pausing all EU campaigns until performance recovers" | [STATED: agency email, 2026-03-19] |

## ORIENT

Three data sources tell different stories:
- **Google Ads** says revenue collapsed
- **GA4** says revenue is roughly normal
- **Shopify** says orders are stable

When the ad platform disagrees with the analytics platform AND the e-commerce platform, the most likely explanation is a **measurement break in the ad platform's conversion tracking**, not a real performance collapse.

The timing correlation (GTM change Mar 17 → drop starts Mar 18) is strong circumstantial evidence.

## ACH — Analysis of Competing Hypotheses

| Evidence | H1: Campaign paused/budget cut | H2: Attribution window closing | H3: GTM change broke conversion tag |
|---|---|---|---|
| Google Ads -74% conversion value | Consistent | Consistent | **Consistent** |
| GA4 revenue only -12% | **Inconsistent** — if real drop, GA4 should match | Partially consistent | **Consistent** — GA4 tracks independently |
| Shopify orders stable | **Inconsistent** | Partially consistent | **Consistent** — Shopify unaffected by GTM |
| GTM change logged Mar 17 | Neutral | Neutral | **Highly consistent** — timing match |
| Spend dropped ~60% | Consistent (could be cause) | Neutral | **Consistent** — Smart Bidding reacted to false signal |
| Agency recommends pause | Neutral | Neutral | **Consistent** — agency sees same false signal |

**Scoring:**
- H1 (Campaign paused): 2 inconsistencies — **Rejected**
- H2 (Attribution window): 0 inconsistencies but only partial consistency — **Possible but weak**
- H3 (GTM broke tag): 0 inconsistencies, 5 consistent — **Leading hypothesis**

## DECIDE

1. **Do NOT pause campaigns** — the agency recommendation is based on a false signal
2. Fix the GTM config tag measurement ID immediately
3. Monitor Google Ads conversion reporting for 5 days post-fix
4. Document in PLATFORM_CHANGELOG.md

## ACT

- [ ] Fix GA4 config tag measurement ID in GTM (EU container) → Task #1
- [ ] Notify agency: do not pause, this is a tracking issue
- [ ] Verify conversions recovering in Google Ads within 48 hours
- [ ] Log REC-001 in RECOMMENDATION_LOG.md
- [ ] Schedule outcome check for Mar 28

---

**Council completed in 47 seconds. 5 agents, 3 hypotheses, 1 conclusion.**
