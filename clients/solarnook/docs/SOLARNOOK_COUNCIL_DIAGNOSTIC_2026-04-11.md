> v1.0 — 2026-04-11

# Council Deliberation: Why did Google Ads conversion value drop 74% on March 18?

> Type: Council Deliberation | Council: Diagnostic
> Client: solarnook | Agents: 5/5 responded (+ Google Ads specialist as 6th)
> Peer Review: no | Stages: collect, warning_intel, ach, synthesis, bluf_ooda
> Engine: Arcanian Council Runner

---

## BLUF

The 74% conversion value drop on March 18 is almost certainly a **measurement failure in the tag layer**, not a real revenue event — confidence **77%** (H1+H2+H3 combined). The GTM change logged March 17 is the proximate cause. Smart Bidding responded to phantom zero-value signals by cutting spend, creating the secondary symptom. **The single falsification test that decides everything: pull the GTM version diff and compare conversion COUNT vs VALUE in Google Ads for March 18-present.** If count held steady and only value dropped, H1 is confirmed. If both dropped, H2. The EU near-zero conversion precedent (existing P0 task) confirms this system has failed silently before.

**Falsification:** If the GTM diff shows no changes to conversion tags, triggers, or consent configuration, this hypothesis collapses — investigate in-platform conversion action changes (H4).

---

## OBSERVE

| # | Finding | Source | Tag |
|---|---------|--------|-----|
| F1 | Conversion value dropped 74% on March 18; spend dropped same day as lagging symptom | Ads platform data | [DATA] |
| F2 | GTM change logged March 17 in GTM-EXAMPLE-US container — one day before the drop | Client-reported change log | [STATED] |
| F3 | GA4 revenue shows a divergent pattern from Google Ads conversion value | GA4 vs Ads comparison | [OBSERVED] |
| F4 | EU account (AW-EXAMPLE-102) has existing P0: near-zero conversions despite stable orders — same symptom profile | Active task record | [OBSERVED] |
| F5 | 4 of 5 analysts independently reached the same diagnosis: GA4/Ads divergence = tag-layer failure, Smart Bidding cascade = lagging symptom | Council synthesis | [INFERRED] |

**Convergent signal (4/5 analysts):** GA4 continuing to show revenue while Ads shows value collapse means the business ran normally — only the measurement layer broke.

---

## ORIENT

### Leading Hypothesis: H1 — GTM broke the VALUE variable (confidence 42%)

The tag fires, Google Ads records a conversion event, but the dynamic value variable (likely `{{DLV - ecommerce.purchase.value}}` or equivalent) returns null, undefined, or 0. This explains:
- Conversion count potentially stable (tag still fires)
- Conversion value collapses
- GA4 unaffected (separate tag or direct dataLayer read)
- Smart Bidding sees ROAS collapse -> reduces spend

**Why H1 edges H2:** Value breaks are silent. The system appears functional — tags fire, no console errors — but the dollar figure is wrong. The EU precedent demonstrates exactly this failure mode.

### Strongest Challenge

The GTM diff has not been retrieved. [UNKNOWN] If the March 17 change touched consent configuration rather than conversion tags, H3 (Consent Mode v2 misconfiguration) becomes the leading hypothesis. Consent Mode blocking `ad_storage` would suppress conversion value reporting while leaving GA4 intact.

### Critical Unknowns (ranked by decision impact)

1. GTM version diff (what actually changed March 17) — blocks all hypothesis ranking
2. Conversion COUNT in Google Ads for March 18-present (H1 vs H2 separator)
3. Whether Google Ads conversion action imports from GA4 or uses native tag
4. Smart Bidding target ROAS and current status
5. Conversion backfill lag (raw March 18 data may shift)

---

## DECIDE

**Primary recommendation:** GTM rollback of the March 17 change — today — before spending another day on a broken measurement signal.

Rollback is low-risk (reverting a recent change), immediately testable (conversion value should recover within the next conversion event), and buys time for proper diagnosis without Smart Bidding degrading further on bad data.

**Do not wait for full diagnosis before acting.** Every day Smart Bidding trains on zero-value conversions, the bidding model degrades. Recovery from Smart Bidding retraining takes 2-4 weeks.

**Alternative paths:**

| Scenario | Action |
|----------|--------|
| GTM diff shows the change was cosmetic | Shift to H4 — audit Google Ads conversion action settings directly |
| GTM diff shows consent configuration change | H3 path: restore previous Consent Mode settings, verify ad_storage grants |
| Rollback causes business-critical regression | Fix forward: re-implement the intended change correctly with QA on conversion value before publishing |

---

## ACT

| # | Action | Who | By When | Success Metric | From |
|---|--------|-----|---------|----------------|------|
| 1 | Pull GTM-EXAMPLE-US version diff: compare published version before and after March 17. Check: conversion tags, trigger conditions, variable definitions, consent configuration | Dev/GTM admin | Today, 2h | Diff retrieved and reviewed | From: /council diagnostic 2026-04-11 |
| 2 | Pull Google Ads conversion action report segmented by date, showing BOTH conversion count AND conversion value, March 15-today | Ads manager | Today, 2h | Count vs value pattern identified | From: /council diagnostic 2026-04-11 |
| 3 | Confirm: does primary conversion action import from GA4 or use native Google tag? Check: Conversions -> action -> Source | Ads manager | Today, 2h | Architecture documented | From: /council diagnostic 2026-04-11 |
| 4 | If diff confirms conversion tag/value change: rollback GTM-EXAMPLE-US to pre-March 17 version | Dev/GTM admin | Today, 4h after diff | GTM reverted to known-good state | From: /council diagnostic 2026-04-11 |
| 5 | Test transaction (or GTM Preview + Tag Assistant) to confirm conversion value fires correctly post-rollback | Dev/GTM admin | Same day as rollback | Value appears in Ads within 3h | From: /council diagnostic 2026-04-11 |
| 6 | Switch Smart Bidding to Manual CPC or conservative tROAS temporarily — halt model degradation | Account strategist | End of business today | Spend stabilized, no further bid erosion | From: /council diagnostic 2026-04-11 |
| 7 | Log incident in RECOMMENDATION_LOG.md. Cross-reference EU P0 task. Flag shared structural fragility | Account strategist | Today | Documented for future reference | From: /council diagnostic 2026-04-11 |
| 8 | Audit GTM-EXAMPLE-EU with same checklist — EU P0 task may share root cause | Dev/GTM admin | By April 14 | EU tracking validated or fixed | From: /council diagnostic 2026-04-11 |
| 9 | After measurement restored: submit conversion data correction if eligible (ad_conversion_adjustments API) | Account strategist | By April 15 | Historical data corrected | From: /council diagnostic 2026-04-11 |

---

## RISK ASSESSMENT

| Risk | Probability | Impact | Mitigation | Decision Trigger |
|------|-------------|--------|------------|------------------|
| Smart Bidding continues degrading on zero-value signal | HIGH | HIGH — 2-4 week retraining cost | Switch to Manual CPC today | Every day without fix = deeper model damage |
| GTM rollback causes unrelated regression | LOW-MED | MED | Review diff before rollback; test immediately after | Rollback + test within same session |
| EU and US share same root cause (dual incident) | MED | HIGH — doubles exposure | P3 EU audit this week | If EU diff shows similar changes |
| Conversion data unrecoverable in Ads | MED | MED — model quality, reporting | Conversion adjustment API | After measurement confirmed fixed |
| H3 is correct and rollback doesn't fix it (consent) | LOW (18%) | MED — adds 1-2 days | Consent Mode audit as parallel track if rollback fails | If post-rollback test still shows zero value |

**Recovery timeline:**
- Measurement fix: same day (rollback) to 48h (fix-forward)
- Conversion value visible in Ads: within 1-2 conversions post-fix
- Smart Bidding model recovery: 2-4 weeks minimum
- Full performance recovery: 3-6 weeks (PMAX particularly sensitive)

---

## SUCCESS METRICS

| Metric | Current | Target | Timeline | Owner |
|--------|---------|--------|----------|-------|
| Google Ads conversion value | -74% from baseline | Pre-March 17 baseline +/- 15% | 24h post-fix | Ads manager |
| Conversion count:value ratio | Unknown (needs ACT #2) | Value per conversion = AOV $3K-$7K range | 24h post-fix | Ads manager |
| GA4 vs Ads revenue delta | ~74% gap | Within attribution window variance (<20%) | 48h post-fix | Dev/GTM admin |
| Smart Bidding spend | Depressed | Stabilized within 5 biz days, upward trend in 2 weeks | 2-4 weeks | Account strategist |
| Test transaction value | Broken/unknown | Correct $ amount in Tag Assistant + Ads | Same day as fix | Dev/GTM admin |

---

## Warning Intelligence (Grabo)

### Convergent Signals

| Signal | Sources | Confidence | Implication |
|--------|---------|------------|-------------|
| GA4/Ads divergence = tag-layer failure, not revenue event | Audit Checker, Channel Analyst, Google Ads Specialist, Copy Analyst | HIGH (4/5) | Root cause is measurement. Revenue intact. |
| GTM change (Mar 17) broke Google Ads tag while GA4 survived on separate path | Audit Checker, Google Ads Specialist, Client Explorer | HIGH (3/5) | GTM diff is the single most critical artifact. |
| Smart Bidding cascade caused spend drop as lagging symptom | Audit Checker, Channel Analyst, Google Ads Specialist | HIGH (3/5) | Spend will not recover until signal restored AND model relearns. |
| March 18 timing inconsistent with real demand collapse | Channel Analyst, Client Explorer | MED (2/5) | No market-side investigation warranted. |

### Weak Signal Clusters

**Cluster 1: Pre-existing Structural Fragility**
- EU task #1 (near-zero conversions) may share root cause [Audit Checker]
- Shared Google Ads account = single point of failure [Client Explorer]
- PMAX has no secondary signal fallback [Google Ads Specialist]

-> Prediction: if GTM diff reveals consent or Enhanced Conversions change, EU task #1 and March 18 collapse share one root cause. This was preventable.

**Cluster 2: Recovery Timeline Underestimated**
- 2-4 weeks for Smart Bidding relearn [Audit Checker]
- Spend drop is lagging symptom [Google Ads Specialist]
- No analyst explicitly called for manual bid strategy intervention during relearning

-> Action gap: need manual CPC or conservative tROAS during recovery period.

### Blind Spots

- GTM version diff not retrieved (the #1 gap — all analysis is [INFERRED] without it)
- Whether Google Ads imports GA4 conversions or uses native tag (changes fix path entirely)
- Conversion COUNT vs VALUE breakdown unknown (H1 vs H2 separator)
- Smart Bidding target ROAS and current performance unknown
- Conversion backfill may make 74% figure inaccurate

### Contradictions

| Source A | Source B | Conflict | Resolution |
|----------|----------|----------|------------|
| Copy Analyst (LP edit possible, 58%) | Channel Analyst (cliff rules out gradual causes) | LP as contributor? | LP copy quality: ruled out. LP hard failure (404/redirect): not ruled out. Check LP state. |
| Client Explorer (Q1 platform update, 55%) | No other analyst addresses | Platform-side change? | Weak signal, single source. Worth noting but not primary. |

---

## ACH — Competing Hypotheses

| # | Hypothesis | Inconsistencies | Confidence |
|---|-----------|:---------------:|:----------:|
| H1 | GTM broke VALUE variable (tag fires, value=0) | 0 | 42% |
| H2 | GTM broke TAG TRIGGER (tag doesn't fire at all) | 0 | 35% |
| H3 | Consent Mode v2 misconfiguration blocked ad_storage | 0 | 18% |
| H4 | In-platform conversion action change (demoted/broken) | 2 | 4% |
| H5 | Real demand/revenue drop | 4 | 1% |

**Leading:** H1 — GTM broke value variable. Tag fires but passes $0/null. Silent failure mode consistent with EU precedent.

**Falsification:** If conversion COUNT also dropped to near-zero -> H2 takes over. If GTM diff shows consent change -> H3. If GTM diff shows NO conversion tag changes -> H4.

**Sensitivity:** Removing E2 (GTM change March 17) is the most destabilizing single evidence removal — all Tier 1 hypotheses lose their causal anchor, H4 becomes the lead.

### Diagnostic Decision Tree

```
Step 1: Pull GTM version diff for March 17 change
  +-- Does it touch conversion tag or value variable?
       YES -> H1/H2 confirmed as candidates -> go to Step 2
       NO  -> H3 or H4; check Consent Mode config

Step 2: Check Google Ads conversion action detail
  +-- Did CONVERSION COUNT also drop?
       YES -> H2 (tag not firing)
       NO  -> H1 (tag fires, value broken)

Step 3: If H3 suspected -- check Consent Mode settings in GTM
  +-- Is ad_storage set to denied by default without modeling enabled?
       YES -> H3 confirmed; also explains EU structural issue
```

---

## Specialist Perspectives

### Audit Checker — Measurement & Tracking
**Primary finding:** GTM change corrupted Google Ads purchase conversion tag (value variable or firing conditions) while GA4 continued via separate path. Divergence = fingerprint of tag-layer failure.
**Key insight:** Four specific failure modes identified (value variable, trigger, consent, enhanced conversions). EU P0 task may be same root cause.
**Confidence:** 72% MED-HIGH

### Channel & Market Analyst — L4-L7
**Primary finding:** Spend+value lockstep drop = Smart Bidding signature response to broken conversion signal. Measurement artifact, not revenue event.
**Key insight:** Attribution window mismatch causes gradual divergence, not cliff. Seasonal context favorable — no market explanation for 74% single-day drop.
**Confidence:** 70% MED-HIGH

### Google Ads Channel Analyst — Platform Specialist
**Primary finding:** GTM change broke Google Ads conversion tag while GA4 remained intact. Smart Bidding cascade followed within 24h.
**Key insight:** PMAX amplifies risk (no secondary signal fallback). If PMAX active, spend collapse would be more severe and faster.
**Confidence:** 80% HIGH

### Copy & Voice Analyst — Messaging
**Primary finding:** Structural fingerprint = measurement failure, not messaging. LP-copy interface should not be dismissed until LP state confirmed.
**Key insight:** Same-day co-drop inconsistent with copy-driven quality shift. Seasonal creative refresh plausible but doesn't produce overnight cliff.
**Confidence:** 45% LOW-MED (honest self-demotion — limited lens for this incident)

### Client Explorer — External/Environmental
**Primary finding:** Internal tracking event, not external market shift. Shared account architecture is single point of failure.
**Key insight:** Q1 Smart Bidding/conversion dedup updates could interact with dual-tag setup. Mid-March seasonal softening = 10-20% over weeks, not 74% overnight.
**Confidence:** 60% MED

---

```stage-result
stage_id: council
council_type: diagnostic
success: true
confidence: 77
client: solarnook
question: "Why did Google Ads conversion value drop 74% on March 18?"
agents_responded: 5
peer_review: false
ach:
  leading: H1
  hypotheses:
    - id: H1
      description: "GTM broke VALUE variable — tag fires but passes $0/null"
      inconsistencies: 0
      confidence: 42
    - id: H2
      description: "GTM broke TAG TRIGGER — tag doesn't fire at all"
      inconsistencies: 0
      confidence: 35
    - id: H3
      description: "Consent Mode v2 misconfiguration blocked ad_storage"
      inconsistencies: 0
      confidence: 18
    - id: H4
      description: "In-platform conversion action change"
      inconsistencies: 2
      confidence: 4
    - id: H5
      description: "Real demand/revenue drop"
      inconsistencies: 4
      confidence: 1
  falsification: "If GTM diff shows no changes to conversion tags, triggers, or consent — H1/H2/H3 collapse to H4"
convergent_signals:
  - signal: "GA4/Ads divergence = tag-layer failure"
    sources: [audit-checker, channel-analyst, google-ads-specialist, copy-analyst]
    confidence: HIGH
  - signal: "Smart Bidding cascade caused spend drop"
    sources: [audit-checker, channel-analyst, google-ads-specialist]
    confidence: HIGH
  - signal: "GTM March 17 change is proximate cause"
    sources: [audit-checker, google-ads-specialist, client-explorer]
    confidence: HIGH
blind_spots:
  - "GTM version diff not retrieved"
  - "Google Ads conversion import vs native tag unknown"
  - "Conversion count vs value breakdown unknown"
  - "Smart Bidding target ROAS unknown"
metadata:
  council: diagnostic
  agents: [audit-checker, channel-analyst, channel-analyst-google-ads, copy-analyst, client-explorer]
  stages_run: [collect, warning_intel, ach, synthesis, bluf_ooda]
  date: 2026-04-11
```

---

## Ontology
- Client: solarnook
- Layer: L5 (Channels — conversion tracking)
- Task: #1 (EU near-zero conversions — related)
- Council: diagnostic
- Agents: audit-checker, channel-analyst, channel-analyst-google-ads, copy-analyst, client-explorer

---

What did we get wrong? What's missing?
