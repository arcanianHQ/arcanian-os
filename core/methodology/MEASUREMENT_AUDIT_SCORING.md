---
scope: shared
---

> v1.0 — 2026-04-12
> Scoring rubrics for measurement audit agents. Progressive 6-phase audit.

# Measurement Audit Scoring Rubrics

## Phase Structure

The audit runs in phases. Each phase has agents that can run in parallel WITHIN the phase, but phases are sequential (Phase 0 before Phase 1, etc.).

```
Phase 0: CLI Baseline (parallel: feed-auditor, sgtm-auditor)
Phase 1: Browser Verification (parallel: consent-auditor, tracking-auditor)
Phase 3: Container Audit (sequential: gtm-auditor → gtm-architect)
Phase 4: Cross-Verification (cross-verifier — uses all prior findings)
Phase 5: Diagnosis (pattern-matcher — matches against KNOWN_PATTERNS)
```

Phase 2 (Platform Dashboards) is manual — requires login to GA4, Meta, Google Ads. Not automatable via agents.

## Status Thresholds

| Score | Status | Meaning |
|---|---|---|
| ≥80 | Pass | Measurement stack healthy |
| 60-79 | Warning | Issues found, monitoring recommended |
| <60 | Fail | Critical issues, fix before trusting data |

---

## 1. Feed Audit (audit-feed)

| Check | Points | Criteria |
|---|---|---|
| Feed accessible (HTTP 200) | 15 | Accessible = 15, 4xx/5xx = 0 |
| Well-formed (parseable XML/CSV) | 15 | Valid = 15, parse errors = 0 |
| Required fields present | 20 | All 9 required fields = 20, per missing = -3 |
| Item count stable (vs baseline) | 10 | Within 10% of baseline = 10, >10% change = 5, no baseline = 0 |
| Data quality (no duplicates/empties) | 15 | Clean = 15, per issue type = -5 |
| GTIN/MPN coverage | 10 | >80% = 10, >50% = 7, <50% = 3 |
| Pipeline trace (test products match) | 15 | All match = 15, per mismatch = -5 |

---

## 2. sGTM Diagnosis (audit-sgtm)

| Check | Points | Criteria |
|---|---|---|
| Endpoint responds (HTTP 200) | 10 | Responds = 10 |
| SSL certificate valid | 5 | Valid = 5 |
| Custom domain resolves | 10 | Resolves = 10, no custom domain = 5 |
| Events reach sGTM (PAT-036) | 20 | Verified in Preview = 20, unverified = 0 (CRITICAL) |
| First-party cookies set correctly | 15 | _ga with 2yr expiry + SameSite = 15 |
| Tag responses all 2xx | 20 | All success = 20, per failed tag = -5 |
| Deduplication configured | 10 | Event IDs present = 10, missing = 0 |
| No dual-firing | 10 | Clean = 10, dual-firing detected = 0 |

---

## 3. Consent Check (audit-consent)

**7-test protocol — each test is pass/fail:**

| Test | Points | Criteria |
|---|---|---|
| 1. Default state = denied | 15 | Denied = 15, Granted = 0 (CRITICAL — GDPR violation) |
| 2. Pre-consent tracking blocked | 15 | Blocked = 15, Fires before consent = 0 (CRITICAL) |
| 3. Consent grant updates state | 15 | Updates = 15, No change = 0 |
| 4. Post-consent tracking fires | 15 | Fires = 15, Still blocked = 5 |
| 5. Consent persists on navigation | 10 | Persists = 10, Resets = 0 |
| 6. Rejection blocks tracking | 15 | Blocks = 15, Still fires = 0 (CRITICAL) |
| 7. GCS parameters correct | 15 | Correct = 15, Incorrect = 5 |

**CRITICAL threshold:** Tests 1, 2, 6 must pass. Any failure = overall score capped at 30.

---

## 4. GTM Container Audit (audit-gtm)

| Check | Points | Criteria |
|---|---|---|
| Tag inventory complete | 15 | All tags documented = 15 |
| All tags consent-gated | 20 | 100% gated = 20, per ungated = -5 (CRITICAL if tracking tag) |
| GA4 disableAutoConfig set | 10 | Set = 10, not set = 0 |
| No duplicate GA4 config tags | 10 | Single = 10, multiple = 0 |
| Trigger naming conventions | 10 | Consistent = 10, inconsistent = 5 |
| Variable naming conventions | 10 | Consistent = 10, inconsistent = 5 |
| No unused triggers/variables | 10 | Clean = 10, per unused = -2 |
| Custom HTML reviewed | 15 | All reviewed, safe = 15, security concerns = 0 |

---

## 5. GTM Architecture (audit-gtm-architect)

**Scored by the 6 Core Container Decisions:**

| Decision Area | Points | Criteria |
|---|---|---|
| Consent architecture | 20 | GREEN = 20, YELLOW = 12, RED = 5 |
| Data Layer | 15 | GREEN = 15, YELLOW = 9, RED = 3 |
| Tag strategy | 15 | GREEN = 15, YELLOW = 9, RED = 3 |
| Trigger logic | 10 | GREEN = 10, YELLOW = 6, RED = 2 |
| Variable management | 10 | GREEN = 10, YELLOW = 6, RED = 2 |
| sGTM routing | 15 | GREEN = 15, YELLOW = 9, RED = 3 |
| Governance | 15 | GREEN = 15, YELLOW = 9, RED = 3 |

---

## 6. Cross-Verifier (audit-cross-verifier)

| Check | Points | Criteria |
|---|---|---|
| ID consistency (page → dataLayer → network → feed → platform) | 25 | All match = 25, per break = -8 |
| Value consistency (price on page = dataLayer = network = feed) | 25 | All match = 25, per mismatch = -8 |
| Event completeness (all required events fire) | 25 | All fire = 25, per missing = -5 |
| Schema validation (JSON-LD matches page content) | 15 | Valid = 15, mismatches = 5 |
| GA4 ↔ Shopify/WooCommerce reconciliation | 10 | <5% gap = 10, 5-10% = 7, >10% = 3 |

---

## 7. Pattern Matcher (audit-pattern-matcher)

This agent doesn't score numerically. It matches findings against `KNOWN_PATTERNS.md` and generates:
- Pattern matches with PAT-xxx IDs
- Recommendations with REC-xxx IDs
- Priority ranking (P0 → P3)
- Knowledge extraction for `KNOWN_PATTERNS.md` updates

---

## Aggregation

**Overall audit score:**

```
overall = (
  feed_score × 0.10 +
  sgtm_score × 0.20 +
  consent_score × 0.25 +
  gtm_score × 0.15 +
  gtm_architect_score × 0.10 +
  cross_verifier_score × 0.20
)
```

**CRITICAL override:** If consent tests 1/2/6 fail, overall score capped at 30 regardless of other scores.

**Phase 2 (platform dashboards):** Manual — not scored by agents. Findings logged as FNDs.

## References
- `core/methodology/CONFIDENCE_ENGINE.md`
- `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`
- `core/methodology/KNOWN_PATTERNS.md`
- `core/methodology/RECOMMENDATION_DEDUP_RULE.md`
