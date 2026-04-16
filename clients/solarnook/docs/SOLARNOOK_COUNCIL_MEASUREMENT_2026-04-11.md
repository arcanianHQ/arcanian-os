# Council Deliberation: Why did Google Ads conversion value drop 74% on March 18?

> v2.0 — 2026-04-11
> Type: Council Deliberation | Council: Measurement
> Client: solarnook | Domain: solarnook-us.com | Currency: USD
> Agents: 4/4 responded (audit-checker, channel-analyst, data-rules-checker, knowledge-extractor)
> Peer Review: no | Stages: collect, warning-intel (Grabo), ACH (Heuer), synthesis
> Engine: Arcanian Council Runner

---

## BLUF

The March 18 Google Ads conversion value crash (-74%) is a **measurement break, not a business event.** Shopify recorded 11 orders / $66,599 and GA4 recorded 12 conversions / $73,722 on the same day Google Ads saw only 3 conversions / $2,420. The leading hypothesis (H1, 65% confidence) is that the March 17 GTM change broke the Google Ads conversion tag or Conversion Linker on the US domain — structurally identical to the confirmed EU incident (REC-001). The budget cut to "Brand Terms" on March 18 compounded the damage via Smart Bidding throttle but is eliminated as primary cause (8 inconsistencies in ACH). **The GTM workspace diff is the single action that resolves all competing hypotheses.**

**Data confidence:** HIGH — three independent sources (Shopify, GA4, Google Ads) from Databox
**Causal confidence:** MEDIUM — GTM change is [STATED] not [OBSERVED]; mechanism is inferred from pattern match
**If wrong:** GTM diff shows Google Ads conversion tag and Conversion Linker were untouched on Mar 17

---

## OBSERVE

1. **Google Ads Mar 18:** 3 conversions, $2,420 value, $294 spend (vs Mar 17: 13 conv, $9,652, $858 spend) — conversion value -75%, spend -66% `[DATA: Databox ds:4942423, Mar 14-22 2026]`
2. **GA4 Mar 18:** 12 conversions, $73,722 revenue — NO DROP from Mar 17 (12 conv, $75,113) `[DATA: Databox ds:4942418, Mar 14-22 2026]`
3. **Shopify Mar 18:** 11 orders, $66,599 — stable (Mar 17: 13 orders, $83,201) `[DATA: Databox ds:4942419, Mar 14-22 2026]`
4. **Sessions by channel:** Stable across all channels Mar 17->18 — no traffic collapse `[DATA: Databox ds:4942417, Mar 14-22 2026]`
5. **Platform changes Mar 18:** Google Ads "Brand Terms" search budget reduced 50% (Manual) `[DATA: Databox ds:4942425]`
6. **Platform changes Mar 19:** PMax "Spring Sale" reactivated; GA4 Enhanced Conversions enabled `[DATA: Databox ds:4942425]`
7. **Google Ads conversion value anomaly:** 3 conversions at $2,420 total = ~$807/conversion — inconsistent with $3K-$7K AOV products `[DATA: Databox ds:4942423]`
8. **Post-drop spend suppression:** avg $460/day Mar 19-30 vs $860/day pre-drop — never recovered `[DATA: Databox ds:4942423]`
9. **30-day tracking gap:** GA4 161 conversions vs Shopify 185 orders = 13% structural undercount `[DATA: Databox ds:4942418 + ds:4942419]`
10. **REC-001 (confirmed):** EU domain had identical symptom Mar 2026 — GTM config tag change broke GA4 purchase event. Fixed in 5 days. Agency was about to pause campaigns — would have been wrong action. `[OBSERVED: confirmed via tag fix + recovery]`

---

## ORIENT

### Leading analysis: H1 — GTM Tag Break (REC-001 Repeat) `[INFERRED, 65%]`

The March 17 GTM change broke the Google Ads conversion tag or Conversion Linker on solarnook-us.com, replicating the exact pattern confirmed on the EU domain (REC-001). The mechanism: when the Conversion Linker stops firing or is resequenced, gclid is not stored in cookies, breaking Google Ads attribution even though GA4 continues to track purchases independently. Smart Bidding, receiving degraded conversion signals, throttled spend from $858 to $294 — a rational response to broken inputs, not a budget problem.

The $807/conversion value anomaly (vs $6K+ AOV) is the strongest evidence: a budget cut cannot change per-conversion value, only volume. Wrong values mean the tag is passing incorrect data, not that fewer purchases occurred.

### Alternative interpretation: H4 — Compound Failure `[INFERRED, 55%]`

Multiple simultaneous causes: (a) GTM change partially degraded conversion tag, (b) manual budget cut reduced volume, (c) Smart Bidding amplified both effects. No single cause explains every detail. This hypothesis has zero ACH inconsistencies but is the least falsifiable — it absorbs all evidence by assigning each piece to a different sub-component.

### Challenge (from Channel Analyst)

"If tracking broke completely, ROAS should have collapsed to zero, not held at 8.23." ROAS surviving at 8.23 (down from 11.24 but not zero) suggests partial tracking — some conversions recorded, just not all. Counter-explanation: the 3 recorded conversions may be from a different source (imported conversions, phone calls, or sGTM parallel path) while the client-side purchase tag was broken.

### Eliminated hypotheses

| Hypothesis | Inconsistencies | Why eliminated |
|---|:---:|---|
| **H2 — Budget Cut Primary** | 8 | GA4/Shopify stable (real orders didn't drop), $807/conv value anomaly unexplained, sessions stable, EU precedent contradicts, team's own response was to fix tracking not restore budget |
| **H5 — Smart Bidding Self-Correction** | 6 | Cannot explain wrong conversion values ($807 vs $6K AOV), timing coincidence with GTM change, EU precedent contradicts, team enabled Enhanced Conversions (measurement fix, not algo response) |

### Unverified claims in this analysis

- GTM change on March 17 `[STATED by user]` — verification: pull GTM workspace version history
- Conversion Linker was the specific broken component `[INFERRED]` — verification: GTM container diff
- Enhanced Conversions on Mar 19 was reactive, not pre-planned `[INFERRED]` — verification: check change management records

### What we don't know

1. **What exactly changed in GTM on March 17** — the most important unknown. Without the diff, all hypotheses remain at [INFERRED].
2. **Whether the US and EU domains share a GTM workspace** — if shared, one config error breaks both domains
3. **Whether consent mode was introduced on the US domain (not just EU)** — changes H3/H4 viability
4. **Campaign-level conversion breakdown** — was the drop uniform across all campaigns or concentrated in one?
5. **Whether the Brand Terms budget has been restored** — if not, the compound effect continues 24 days later

---

## DECIDE

**Primary:** Audit the GTM container version deployed March 17 — diff against the prior version. Specifically check: (1) Conversion Linker tag firing order, (2) Google Ads purchase conversion tag trigger, (3) consent mode interaction with ad_storage. This is the same repair path that resolved REC-001 in 5 days.

**Alternative A:** If GTM diff shows no conversion tag changes -> investigate consent mode deployment scope (US vs EU-only) and Google Ads conversion action configuration.

**Alternative B:** If all tag infrastructure checks clean -> segment Google Ads data by campaign type to determine if the drop is concentrated in specific campaigns, suggesting a Smart Bidding / budget governance issue rather than tracking.

**Why not alternatives first:** The EU precedent (REC-001) provides strong prior probability for GTM tag break. Starting anywhere else is lower expected value per hour of investigation.

**DO NOT** pause campaigns or further reduce budgets. The EU incident proved this would compound the damage. Smart Bidding is already starved of signal — removing budget headroom makes recovery slower.

---

## ACT

| # | Action | Who | By When | Success Metric | From |
|---|--------|-----|---------|----------------|------|
| 1 | Pull GTM workspace diff (version before/after Mar 17). Inspect Conversion Linker, Google Ads conversion tag, trigger sequencing. | You (+ dev/agency if needed) | 2026-04-14 | Diff reviewed, root cause confirmed or H1 falsified | From: /council measurement 2026-04-11 |
| 2 | Verify GA4 property isolation — confirm GA4-EXAMPLE-US only tracks solarnook-us.com, no EU bleed | You | 2026-04-14 | GA4 property settings screenshot, domain filter confirmed | From: /council measurement 2026-04-11 |
| 3 | Check Google Ads conversion actions — confirm purchase event is primary, identify any micro-conversions counted | You | 2026-04-14 | Conversion action list with type, value source, and counting method | From: /council measurement 2026-04-11 |
| 4 | Restore "Brand Terms" budget to pre-Mar 18 level (if not already done) | You / agency | 2026-04-14 | Daily spend returns to $800+ range within 5 days | From: /council measurement 2026-04-11 |
| 5 | After tag fix: monitor Google Ads conversion count vs Shopify orders daily for 7 days | You | 2026-04-21 | Google Ads conversions within 15% of Shopify orders | From: /council measurement 2026-04-11 |
| 6 | If ROAS <5x for 7+ days post-fix, switch to Manual CPC temporarily while Smart Bidding re-learns | You / agency | 2026-04-28 | ROAS recovery to >7x within 14 days of fix | From: /council measurement 2026-04-11 |

---

## RISK ASSESSMENT

| Risk | Probability | Impact | Mitigation | Decision Trigger |
|------|:-----------:|:------:|------------|-----------------|
| Smart Bidding learning period extends 2-4 weeks post-fix | HIGH | MEDIUM | Set Manual CPC floor bid as safety net; don't change targets during learning | ROAS <5x for 7 consecutive days |
| GTM diff reveals consent mode, not tag break — different fix path | MEDIUM | LOW | Follow Alternative A — consent mode audit adds ~2 days | GTM diff clean on conversion tags |
| Agency panics and pauses campaigns (same near-miss as EU) | MEDIUM | HIGH | Brief agency NOW: this is measurement, not performance; do NOT pause | Any campaign pause proposal before GTM audit completes |
| Third domain (dealers.solarnook.com) has same undetected break | LOW | MEDIUM | Extend GTM audit scope to all domains in same workspace | Any GTM workspace shared across domains |
| GA4 property has EU data bleed — Observe items 2-3 are contaminated | LOW | CRITICAL | Verify property isolation (ACT #2) before proceeding with any fix | GA4 property serves multiple domains |

---

## SUCCESS METRICS

| Metric | Current | Target | Timeline | Owner |
|--------|---------|--------|----------|-------|
| Google Ads daily conversions | 3-9 (post-drop) | 10-14 (pre-drop level) | 7 days post-fix | You |
| Google Ads daily spend | $460 avg | $800+ (pre-drop level) | 5 days post-budget restore | You / agency |
| Google Ads ROAS | ~8.0 (degraded) | >10.0 (pre-drop level) | 14-21 days post-fix | You |
| GA4-Shopify tracking gap | 13% | <10% | 30 days | You |
| Google Ads conversion value per conversion | ~$807 | $3,000-$7,000 (product AOV) | Immediate post-fix | You |

---

## Warning Intelligence (Grabo)

### Convergent Signals

| Signal | Sources | Confidence | Implication |
|--------|---------|:----------:|-------------|
| This is a measurement failure, not a demand failure | All 4 agents | 82-92% | Any action treating this as demand (pausing campaigns, further budget cuts) will compound the damage |
| GTM change on Mar 17 is the most probable trigger | All 4 agents | 78-85% | Undisputed timing correlation; disagreement is only on mechanism (tag break vs consent mode) |
| Budget cut is compounding, not primary cause | Audit Checker, Channel Analyst, Knowledge Extractor | 71-85% | Budget cuts compress volume but don't destroy per-conversion value |
| Smart Bidding amplified a measurement error into a real spend problem | Audit Checker, Channel Analyst, Knowledge Extractor | 68-78% | Automated systems with no cross-source circuit breaker convert tag errors into budget errors — structural vulnerability |
| 5 platform changes in 15 days makes clean root-cause isolation impossible without GTM diff | All 4 agents | 91% | Change management failure, not analysis failure |

### Weak Signal Clusters

**Cluster A — The recovery may not be real:**
Enhanced Conversions changed the signal source (Mar 19). If attribution window also changed, the post-Mar 22 ROAS "improvement" may be a reporting artifact. Recovery has not been verified against Shopify ground truth for Mar 19-25.

**Cluster B — Systemic infrastructure process problem:**
REC-001 (EU domain GTM break) + this incident (US domain) + REC-002 (EU consent mode still unresolved) = same team, same workspace, recurring pattern. A third incident on another domain is not unlikely.

**Cluster C — The consent mode pre-crash window:**
If consent mode v2 was deployed Mar 14, there may be 4 days of invisible signal degradation before the Mar 17 tag break made it visible. Smart Bidding's learning state may have been compromised before the visible incident.

### Blind Spots

1. **Per-campaign conversion breakdown** — never pulled. Would immediately clarify if break was tag-wide or campaign-specific.
2. **Shopify orders Mar 19-25** — the "gap window" ground truth was verified for Mar 18 but not the following days.
3. **Server-side GTM (sGTM) architecture** — if active, may explain why ROAS survived at 8.23 rather than crashing to zero.
4. **Competitor auction behavior** — during SolarNook's Smart Bidding throttle, competitors may have captured branded traffic.
5. **Brand Terms budget restoration status** — unknown if still at -50% after 24 days.

### Contradictions

| Source A | Source B | Conflict | Investigation |
|----------|----------|----------|---------------|
| Channel Analyst: ROAS 8.23 argues against total tracking break | Audit Checker: ROAS collapse from 11.24->8.23 requires measurement explanation | Whether 8.23 is "stable" or "degraded" depends on baseline at matched spend levels | Pull ROAS at $300/day spend historically |
| Data Rules Checker: GA4 over-counted Shopify by 10.7% on Mar 18 (12 vs 11) — anomalous direction | Audit Checker, Channel Analyst: GA4/Shopify agreement is load-bearing evidence | If GA4 includes EU data, the entire "not a demand problem" consensus degrades | Verify GA4 property domain filter (ACT #2) |
| Knowledge Extractor: Post-recovery ROAS gap is Smart Bidding re-learning (temporary) | Channel Analyst: ROAS gap may be attribution window change (permanent) | Different mechanisms, different recommended actions | Compare 7d vs 30d attributed conversions Mar 23-Apr 10 |

---

## ACH — Competing Hypotheses (Heuer Method)

### Inconsistency Matrix

| Evidence | H1 GTM Tag Break | H2 Budget Cut | H3 Consent Mode | H4 Compound | H5 Smart Bidding |
|----------|:-:|:-:|:-:|:-:|:-:|
| E2 GA4 stable (12 conv, $73K) | C | **I** | C | C | C |
| E3 Shopify stable (11 orders) | C | **I** | C | C | C |
| E4 ROAS held at 8.23 | C | C | C | C | C |
| E5 GTM change Mar 17 [STATED] | C | N | C | C | **I** |
| E6 Brand Terms budget -50% | N | C | N | C | **I** |
| E7 EC + PMax enabled Mar 19 | C | **I** | C | C | **I** |
| E8 Sessions stable | C | **I** | C | C | C |
| E9 Spend suppressed 12+ days | C | **I** | C | C | C |
| E10 13% GA4/Shopify structural gap | N | N | C | N | N |
| E11 REC-001 EU identical symptom | C | **I** | C | C | **I** |
| E12 EC as signal-loss acknowledgment | C | **I** | C | C | **I** |
| E13 $807/conv vs $6K AOV | C | **I** | C | C | **I** |
| **INCONSISTENCIES** | **0** | **8** | **0** | **0** | **6** |

### Ranking

| Rank | Hypothesis | Inconsistencies | Confidence | Notes |
|:---:|-----------|:-:|:-:|---|
| **1** | **H1 — GTM Tag Break** | 0 | 65% | Most parsimonious. Strongest historical support (REC-001). Explains value anomaly cleanly. |
| 2 | H4 — Compound Failure | 0 | 55% | Absorbs all evidence but least falsifiable. Operationally equivalent to H1 for immediate fix. |
| 2 | H3 — Consent Mode | 0 | 50% | Zero inconsistencies but requires sub-mechanism for $807 value anomaly. |
| 4 | H5 — Smart Bidding Self-Correction | 6 | 15% | Cannot explain wrong conversion values or EU precedent. Eliminated. |
| 5 | H2 — Budget Cut Primary | 8 | 10% | Eliminated. Only 1 direct confirming evidence item (E6). |

**Leading:** H1 — GTM Tag Break / Conversion Linker Break
**Falsification:** GTM workspace diff shows Google Ads conversion tag and Conversion Linker were untouched on March 17
**Sensitivity:** Removing E11 (EU precedent) makes H1 and H3 co-equal — the historical pattern match is what breaks the tie

### Most Diagnostic Evidence

| Evidence | Discriminating Power | Separates |
|----------|---------------------|-----------|
| **E13** — $807/conv vs $6K+ AOV | STRONGEST | Eliminates H2, H5. Only tag malfunction explains wrong values. |
| **E11** — EU precedent (REC-001) | STRONG | Eliminates H2, H5. Confirms H1 pattern. |
| **E7** — EC enabled Mar 19 (reactive) | STRONG | Team's own response = they diagnosed signal problem, not budget problem. |
| E4 — ROAS 8.23 | NON-DIAGNOSTIC | Consistent with all hypotheses. |

---

## Specialist Perspectives

### Audit Checker (Chairman) — Measurement/Tracking

**Primary finding:** Google Ads conversion tracking tag almost certainly stopped firing March 18 following March 17 GTM change. Structurally identical to confirmed REC-001 (EU domain). Confidence: HIGH.

Key observations:
1. Three-platform divergence (Shopify 11 / GA4 12 / Google Ads 3) = tracking-only signature — 92% [DATA]
2. EU domain had exact same pattern, same infra team, resolved by GTM tag fix — 78% [INFERRED]
3. Spend drop is Smart Bidding throttle responding to broken signal, not a cause — 85% [INFERRED]

Would change if: GTM diff shows no trigger changes on Google Ads conversion tag.

### Channel & Market Analyst — L4-L7 Performance

**Primary finding:** Spend collapse primarily explained by manual budget cut triggering Smart Bidding cascade. ROAS holding at 8.23 (not zero) argues against total tracking break. Confidence: MEDIUM-HIGH (72%).

Key observations:
1. ROAS 8.23 on Mar 18 is within normal range — argues against total tag failure — 82% [DATA]
2. 50% brand budget cut insufficient for 66% total drop — Smart Bidding amplification — 68% [INFERRED]
3. Spend never recovered — classic post-disruption Smart Bidding learning pattern — 75% [INFERRED]

Key challenge: "If tracking broke, ROAS should have collapsed to zero." Suggests micro-conversions or sGTM parallel path kept partial signal alive.

### Data Rules Checker — Cross-Platform Integrity

**Primary finding:** GA4 and Shopify agree (12 vs 11), isolating break to Google Ads pipeline specifically. Points to Conversion Linker or gclid attribution chain failure. Confidence: MEDIUM (65-70%).

Key observations:
1. GA4/Shopify agreement proves break is Google Ads-specific — 85% [DATA]
2. 13% chronic GA4/Shopify gap is a pre-existing structural problem separate from Mar 18 — 90% [DATA]
3. GTM change is most probable trigger but is [STATED] not [OBSERVED] — 70% [INFERRED]

Critical point: Verify GA4 property isolation before trusting GA4 as ground truth.

### Knowledge Extractor — Pattern Matching

**Primary finding:** Matches REC-001 with high structural fidelity. Same symptom signature, same infrastructure team, different domain. Distinguishing factor: simultaneous spend drop (not present in EU incident). Confidence: HIGH (82%).

Key observations:
1. REC-001 pattern: identical cross-platform discrepancy, same team, 24h GTM->crash lag — 82% [INFERRED from pattern]
2. Spend cut is likely CONSEQUENCE not cause — someone saw crash and panicked — 71% [INFERRED]
3. Enhanced Conversions on Mar 19 = implicit acknowledgment of signal loss — 68% [INFERRED]

Systemic risk flag: Same team broke EU tracking, now US tracking. Third incident is predictable.

---

```stage-result
stage_id: council
council_type: measurement
success: true
confidence: 65
client: solarnook
question: "Why did Google Ads conversion value drop 74% on March 18 while GA4 and Shopify showed stable revenue?"
agents_responded: 4
peer_review: false
ach:
  leading: H1
  hypotheses:
    - id: H1
      description: "GTM Tag Break / Conversion Linker failure — REC-001 repeat on US domain"
      inconsistencies: 0
      confidence: 65
    - id: H4
      description: "Compound failure — GTM change + budget cut + Smart Bidding amplification"
      inconsistencies: 0
      confidence: 55
    - id: H3
      description: "Consent mode introduction suppressed gclid/ad_storage for non-consenting users"
      inconsistencies: 0
      confidence: 50
    - id: H5
      description: "Smart Bidding self-correction after anomalous high-spend period"
      inconsistencies: 6
      confidence: 15
    - id: H2
      description: "Brand Terms budget cut was the primary cause"
      inconsistencies: 8
      confidence: 10
  falsification: "GTM workspace diff shows Google Ads conversion tag and Conversion Linker untouched on Mar 17"
convergent_signals:
  - signal: "This is a measurement failure, not a demand failure"
    sources: [audit-checker, channel-analyst, data-rules-checker, knowledge-extractor]
    confidence: HIGH
  - signal: "GTM change on Mar 17 is the most probable trigger"
    sources: [audit-checker, channel-analyst, data-rules-checker, knowledge-extractor]
    confidence: HIGH
  - signal: "Budget cut is compounding, not primary"
    sources: [audit-checker, channel-analyst, knowledge-extractor]
    confidence: HIGH
blind_spots:
  - "Per-campaign conversion breakdown never pulled"
  - "Shopify ground truth for Mar 19-25 not verified"
  - "sGTM architecture not assessed — may explain ROAS survival at 8.23"
  - "Competitor auction behavior during Smart Bidding throttle unknown"
  - "Brand Terms budget restoration status unknown"
metadata:
  council: measurement
  agents: [audit-checker, channel-analyst, data-rules-checker, knowledge-extractor]
  stages_run: [collect, warning_intel, ach, synthesis]
  date: 2026-04-11
```

---

## Ontology

- Client: solarnook
- Domain: solarnook-us.com
- Layer: L5 (Channels/Measurement)
- Task: #1 (Google Ads conversion tracking)
- Council: measurement
- Agents: audit-checker, channel-analyst, data-rules-checker, knowledge-extractor
- FND: Google Ads conversion tag or Conversion Linker failure post-GTM change
- REC: REC-004, REC-005, REC-006
- Prior: REC-001 (EU domain identical pattern, confirmed)

---

What did we get wrong? What's missing?
