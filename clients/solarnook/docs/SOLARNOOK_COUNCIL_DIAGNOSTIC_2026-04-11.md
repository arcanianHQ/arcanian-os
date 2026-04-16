# Council Deliberation: Why did Google Ads conversion value drop 74% on March 18?

> v2.0 — 2026-04-11
> Type: Council Deliberation | Council: Diagnostic
> Client: solarnook | Domain: solarnook-us.com | Agents: 4/4 responded
> Peer Review: no | Stages: collect, warning_intel, ach, synthesis, bluf_ooda
> Engine: Arcanian Council Runner

---

## BLUF

**The March 18 Google Ads conversion value collapse (-74%) is a compound measurement failure, not a business event.** [Confidence: 62%] A consent mode configuration push on March 14 degraded the conversion signal pool available to Google Ads; with a 4-day propagation lag, Smart Bidding entered a throttled state on March 18, and a simultaneous brand terms budget cut (-50%) eliminated the remaining high-ROAS fallback traffic. Revenue continued uninterrupted — Shopify recorded 11 orders ($66,599) and GA4 recorded 12 conversions ($73,722) on the same day Google Ads saw only $2,420.

**Falsification:** Pull GTM workspace 45 diff. If `ad_storage` was firing `granted` normally on Mar 14-18, the consent-tag chain (H1/H3/H5) collapses and the root cause shifts to the budget cut + Smart Bidding interaction alone.

---

## OBSERVE

| # | Finding | Sources | Evidence Class | Confidence |
|---|---------|---------|----------------|------------|
| 1 | March 18 is a measurement failure — Shopify and GA4 confirm revenue continued normally | All 4 agents | [DATA] | 82% |
| 2 | Consent mode push (Mar 14) introduced signal degradation with 4-day lag to impact | Audit, KE, Channel | [INFERRED] | 72% |
| 3 | Smart Bidding entered throttled state — account spent $294 vs $850/day cap | GAds, Audit, KE | [INFERRED] | 68% |
| 4 | Brand terms budget cut (-50% on Mar 18) removed fallback conversion volume | All 4 agents | [DATA] | 85% |
| 5 | 5 overlapping platform changes in 15 days make clean root cause isolation impossible without GTM diff | All 4 agents | [OBSERVED] | 91% |

## ORIENT

**Leading analysis (H5 — Compound Failure, 62%):** No single factor explains the full magnitude. The consent mode update degraded tag firing, Smart Bidding reacted by throttling spend, and the brand budget cut removed the highest-converting traffic simultaneously. All three factors must be present to produce a -74% conversion value drop against stable Shopify/GA4.

**Strongest challenge (H2 — Budget Cut Only, eliminated):** The Google Ads analyst initially weighted the budget cut as primary. However, ACH revealed 5 inconsistencies — critically, GA4 and Shopify both show stable revenue, which is fatal to any demand-side explanation. Budget cuts compress volume but do not destroy efficiency; the ROAS collapse from 11.24 to 8.23 requires a measurement explanation.

**Unknowns:**
- Geo-scope of consent mode change (US-only vs global) — determines signal pool impact magnitude
- Whether GA4 Enhanced Conversions (enabled Mar 19, one day after drop) was a **reactive fix** or coincidence
- Whether the Mar 22 attribution window change (30d->7d) retroactively restated Mar 18-21 data
- Shopify revenue Mar 19-21 — unverified ground truth for the "gap window"

## DECIDE

**Primary recommendation:** Treat this as a measurement remediation, not a performance problem. Do NOT pause Google Ads campaigns or reduce budget further — that would compound the issue. Instead, execute the GTM diff audit to confirm the consent mode hypothesis, then fix the tag chain.

**Alternative if H5 is falsified:** If GTM diff shows consent was not the issue, shift focus to Smart Bidding signal health and the budget cut interaction. Schedule a re-council contingent on diff results.

**Separate workstream needed:** The broader 30-day all-channel session decline (-38% to -70%) is a real demand/visibility issue being obscured by the Mar 18 noise. Once measurement is confirmed clean, run a separate /7layer diagnostic on organic + direct channels.

## ACT

| # | Action | Who | By When | Success Metric | From |
|---|--------|-----|---------|----------------|------|
| 1 | Pull GTM workspace 45 diff; confirm `ad_storage` grant/deny rate Mar 14-18 | Dev / GTM Admin | Apr 14 | Diff retrieved, consent state documented | /council diagnostic 2026-04-11 |
| 2 | Audit Smart Bidding status log for brand campaigns Mar 17-22 | Google Ads Manager | Apr 14 | Throttle entry date confirmed or ruled out | /council diagnostic 2026-04-11 |
| 3 | Verify Shopify order-level data Mar 19-21 vs GA4 purchase events | Dev / Analytics | Apr 13 | Gap quantified for the "gap window" | /council diagnostic 2026-04-11 |
| 4 | Restore brand terms budget to pre-cut level (or document strategic reason) | Google Ads Manager | Apr 12 | Brand Terms budget at $850/day | /council diagnostic 2026-04-11 |
| 5 | Confirm GA4 Enhanced Conversions active as conversion signal fallback | Dev / Analytics | Apr 18 | EC verified firing on all purchase events | /council diagnostic 2026-04-11 |
| 6 | Establish weekly Shopify-GA4-GAds conversion reconciliation check | Analytics Lead | Apr 18 | Baseline gap documented, <10% variance target | /council diagnostic 2026-04-11 |

## RISK ASSESSMENT

| Risk | Probability | Impact | Mitigation | Decision Trigger |
|------|-------------|--------|------------|------------------|
| GTM diff shows ad_storage firing normally -> H5 collapses, no clear root cause | 25% | HIGH — council output invalidated | Pre-schedule re-council contingent on diff result | Diff retrieved by Apr 14 |
| Smart Bidding remains throttled even after tag fix -> 2-4 week recovery lag | 50% | HIGH — ROAS suppressed during recovery | Temporarily switch to Manual CPC, re-enter Smart Bidding after 14d signal rebuild | If ROAS <5x for 7+ days post-fix |
| Broader 30-day session decline is real demand shift, not measurement noise | 40% | CRITICAL — current plan addresses wrong problem | Run /7layer on organic + direct once measurement confirmed clean | If Shopify orders decline >20% in next 14 days |

## SUCCESS METRICS

| Metric | Current | Target | Timeline | Owner |
|--------|---------|--------|----------|-------|
| Google Ads reported conversion value (US) | -74% vs baseline | Within 20% of Shopify-verified revenue | Apr 25 | Dev / Analytics |
| Shopify-GA4-GAds conversion gap | Unknown (not reconciled) | <10% variance across all three | Apr 18 | Analytics Lead |
| Smart Bidding signal health | Throttled (est.) | Return to pre-Mar 14 CPA level | May 2 | Google Ads Manager |

---

## Warning Intelligence (Grabo)

### Convergent Signals

| Signal | Sources | Confidence | Implication |
|--------|---------|------------|-------------|
| Mar 18 is measurement failure, not business failure | All 4 | 82% | Revenue intact; Google Ads reporting is wrong |
| Consent mode update (Mar 14) broke Google Ads tag with 4-day lag | Audit, KE, GAds (partial), Channel | 72% | Primary measurement break vector |
| Brand terms budget cut is compounding factor, not root cause | Audit, GAds, KE | 84% | Volume fell; efficiency collapse requires separate explanation |
| 5 overlapping changes create unresolvable confound | All 4 | 91% | Clean root cause impossible without GTM diff |

### Weak Signal Clusters

Three minor observations combine: **the Mar 22 "recovery" (ROAS 13.24) may be fabricated data, not real recovery.**
- Attribution window change (30d->7d) on Mar 22 [Channel, 41%]
- GA4 Enhanced Conversions enabled Mar 19 — possibly reactive fix [KE]
- Smart Bidding would self-correct once conversion signals resumed [GAds]

Together: the account may have "recovered" because the attribution window restatement backdated conversions, Smart Bidding restabilized on new Enhanced Conversions signals, and the drop window closed before anyone noticed. **The recovery is not independently verified.**

### Blind Spots

- **Geo-scope of consent change** — EU-only vs site-wide. If EU-only, US conversion data should be unaffected.
- **Impression share on non-brand campaigns Mar 18** — key falsification test, no data available.
- **Shopify revenue Mar 19-21** — the "gap window" ground truth, unverified.
- **GTM workspace 45 actual diff** — all four analysts cite this as decisive. None have seen it.

### Contradictions

| Source A | Source B | Conflict | Investigation Needed |
|----------|----------|----------|---------------------|
| GAds: budget cut is primary | Audit/KE: budget cut is secondary | ROAS degradation: volume loss or signal loss? | ROAS at matched spend levels |
| GAds: Smart Bidding throttle is main mechanism | Audit: consent tag severance is main mechanism | Different failure modes, different fixes | GTM diff + impression share data |
| Channel: recovery is restatement artifact (41%) | GAds: recovery is Smart Bidding restabilizing | Recovery authenticity unknown | Shopify Mar 19-25 as ground truth |

---

## ACH — Competing Hypotheses

| # | Hypothesis | Inconsistencies | Confidence |
|---|-----------|:---------------:|:----------:|
| H5 | **Compound Failure** — consent mode degraded signals + Smart Bidding throttled + budget cut removed fallback | 0 | **62%** |
| H3 | Smart Bidding Signal Degradation — consent mode gradually degraded conversion signal pool | 0 | 25% |
| H1 | Consent Tag Break — GTM consent update broke Google Ads conversion tag firing | 0 | 13% |
| H4 | Attribution Restatement — 30d->7d window change retroactively depressed historical data | 3 | <5% |
| H2 | ~~Brand Budget Cut Only~~ — manual cut caused spend and conversion collapse | 5 | **Eliminated** |

**Leading:** H5 — Compound Failure. Only hypothesis with zero inconsistencies AND highest confirmation count (11/14 evidence items consistent).

**Falsification:** GTM workspace 45 diff showing `ad_storage` firing normally Mar 14-18 collapses the consent-tag chain that underpins H1, H3, and H5.

**Sensitivity:** Removing E3+E4 (GA4/Shopify stability) makes H2 viable (1 inconsistency). These are the load-bearing evidence items — independent verification critical.

### Inconsistency Matrix

| Evidence | H1 | H2 | H3 | H4 | H5 |
|----------|:--:|:--:|:--:|:--:|:--:|
| E1 Spend -66% | N | C | C | N | C |
| E2 Conv -77% | C | C | C | C | C |
| E3 GA4 stable | C | I | C | N | C |
| E4 Shopify stable | C | I | C | N | C |
| E5 GTM Mar 14 | C | N | C | N | C |
| E6 Brand budget -50% | N | C | N | N | C |
| E7 Enhanced Conv Mar 19 | N | N | N | N | N |
| E8 Attribution 30d->7d Mar 22 | N | N | N | C | N |
| E9 Paid Search sessions slight decline | C | I | C | I | C |
| E10 Partial recovery Mar 22 | N | N | C | I | C |
| E11 Under-delivery vs cap | C | I | C | N | C |
| E12 4-day lag | C | I | N | N | C |
| E13 Smart Bidding throttle | C | N | C | N | C |
| E14 30-day session decline | N | N | N | I | N |

---

## Specialist Perspectives

### Audit Checker — Measurement & Tracking [Confidence: 68%]

Primary: The drop is a measurement attribution failure, not business failure. GTM consent mode update (Mar 14) severed Google Ads' tag firing path while GA4 continued via first-party. 4-day lag consistent with cookie expiry/geo-rollout. GA4 Enhanced Conversions was NOT active until Mar 19 — no fallback existed. Brand terms budget cut explains spend drop but NOT the ROAS collapse (ROAS dropped 27% with only 3 conversions — volume loss exceeds budget cut alone). Recommended: Audit GTM workspace 45 diff against workspace 44 — check consent initialization trigger firing order.

### Google Ads Channel Analyst [Confidence: 74%]

Primary: Most likely a direct consequence of Brand Terms budget cut (-50%), compounded by Smart Bidding entering restricted-spend state. $294 spend vs $850/day cap = significant under-delivery beyond the budget cut alone. Consent mode is candidate secondary factor (55% confidence). The account under-delivered its budget by 65%, suggesting portfolio-wide suppression, not just brand term reduction. Recommended: Restore brand terms budget immediately, pull Search Terms report Mar 15-22 to confirm whether brand query volume dropped.

### Channel & Market Analyst — L4-L7 [Confidence: 68%]

Primary: Mar 18 is measurement artifact, not demand failure. But the broader 30-day all-channel session decline (-38% to -70%) is a SEPARATE real demand/visibility problem being obscured. Sessions down 40-70% but Shopify only -16% = fewer visitors, same conversion rate = top-of-funnel problem (L6-L7). Mar 22 "recovery" may be attribution restatement artifact (41% confidence). Recommended: Fix tracking first, then diagnose demand decline separately.

### Knowledge Extractor — Pattern Recognition [Confidence: 72%]

Primary: Textbook "Consent-Gated Tag Failure Masked by Simultaneous Budget Event" pattern. 4-day lag is canonical for consent mode surfacing. Budget cuts compress volume but don't destroy efficiency — ROAS degradation is the signal. 5 overlapping changes in 15 days make clean root cause structurally impossible. Recommended: Add to KNOWN_PATTERNS.md as "False Recovery" warning — ROAS normalization after tracking break =/= performance recovery.

---

## Prior Recommendations (Dedup Check)

| REC ID | Date | Relevance | Status |
|--------|------|-----------|--------|
| REC-001 | 2026-03-20 | GTM tag break on EU domain — **different domain** (solarnook.eu), separate GTM container. Does not apply to US. | confirmed |
| REC-002 | 2026-03-22 | Consent mode compliance on EU — related but EU-only. US domain consent state unknown. | in_progress |
| REC-003 | 2026-03-25 | Email session drop — separate issue (automation flow broken). Explains part of 30-day Email -70% decline. | open |

**Note:** This council's actions are NEW — they apply to solarnook-us.com (GTM-EXAMPLE-US / AW-EXAMPLE-101), not the EU domain previously addressed.

---

```stage-result
stage_id: council
council_type: diagnostic
success: true
confidence: 62
client: solarnook
question: "Why did Google Ads conversion value drop 74% on March 18, while GA4 and Shopify show stable?"
agents_responded: 4
peer_review: false
ach:
  leading: H5
  hypotheses:
    - id: H1
      description: "Consent mode tag break — GTM update broke Google Ads conversion tag firing"
      inconsistencies: 0
      confidence: 13
    - id: H2
      description: "Brand budget cut only — manual 50% reduction caused collapse"
      inconsistencies: 5
      confidence: 0
    - id: H3
      description: "Smart Bidding signal degradation — consent mode gradually degraded signal pool"
      inconsistencies: 0
      confidence: 25
    - id: H4
      description: "Attribution window retroactive restatement — 30d to 7d change rewrote history"
      inconsistencies: 3
      confidence: 5
    - id: H5
      description: "Compound failure — consent mode + Smart Bidding throttle + budget cut"
      inconsistencies: 0
      confidence: 62
  falsification: "GTM workspace 45 diff showing ad_storage firing normally Mar 14-18"
convergent_signals:
  - signal: "Mar 18 is measurement failure, not business failure"
    sources: [audit-checker, channel-analyst-google-ads, channel-analyst, knowledge-extractor]
    confidence: HIGH
  - signal: "Brand terms budget cut is compounding, not root cause"
    sources: [audit-checker, channel-analyst-google-ads, knowledge-extractor]
    confidence: HIGH
blind_spots:
  - "Geo-scope of consent mode change (EU-only vs site-wide)"
  - "Impression share on non-brand campaigns Mar 18"
  - "Shopify revenue Mar 19-21 ground truth"
  - "GTM workspace 45 actual diff — decisive but unread"
metadata:
  council: diagnostic
  agents: [audit-checker, channel-analyst-google-ads, channel-analyst, knowledge-extractor]
  stages_run: [collect, warning_intel, ach, synthesis, bluf_ooda]
  date: 2026-04-11
```

---

## Ontology

- Client: solarnook
- Domain: solarnook-us.com
- Layer: L5 (Channels — measurement subsystem)
- Task: #1 (Google Ads conversion tracking)
- Council: diagnostic
- Agents: audit-checker, channel-analyst-google-ads, channel-analyst, knowledge-extractor
- REC: REC-001 (related, different domain), REC-002 (related, EU consent)

---

What did we get wrong? What's missing?
