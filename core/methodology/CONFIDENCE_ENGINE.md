> v1.0 — 2026-04-03

# Confidence Engine (Unified Scoring Pipeline)

> **SYSTEM-WIDE RULE** — applies to ALL findings, recommendations, and analysis output.
> Unifies: DATA_RELIABILITY_FRAMEWORK.md + EVIDENCE_CLASSIFICATION_RULE.md + UNVERIFIED_ASSUMPTIONS_RULE.md
> "One score per insight. The team sees it before they act."

---

## The Problem

Three guardrails exist independently:
1. **Data Reliability Framework** — rates source systems (GA4 = MEDIUM, Google Ads API = HIGH)
2. **Evidence Classification** — classifies evidence type (DATA / OBSERVED / STATED / NARRATIVE / INFERRED / HEARSAY)
3. **Unverified Assumptions** — flags gaps where "not mentioned ≠ doesn't exist"

They work. But they produce three separate signals that the reader must synthesize themselves. A finding can have HIGH source confidence, be based on NARRATIVE evidence, and rely on an UNVERIFIED assumption — and all three guardrails pass independently.

## The Rule

Every finding (FND), recommendation (REC), or significant analytical claim gets a **single confidence score** computed from all three inputs.

## Scoring Formula

```
Confidence = min(Source Confidence, Evidence Class, Assumption Status)
```

The weakest link determines the score. A finding based on HIGH-confidence data but resting on an UNVERIFIED assumption scores UNVERIFIED — not HIGH.

### Input 1: Source Confidence (from DATA_RELIABILITY_FRAMEWORK.md)

| Level | Score | Meaning |
|---|---|---|
| HIGH | 0.9 | Direct measurement, validated, <10% error |
| MEDIUM | 0.6 | Reasonable measurement, known gaps, 10-40% error |
| LOW | 0.3 | Estimated, inferred, structurally unreliable |
| UNVERIFIED | 0.1 | Not measured, only inferred |

### Input 2: Evidence Class (from EVIDENCE_CLASSIFICATION_RULE.md)

| Class | Score | Can support action? |
|---|---|---|
| DATA | 0.9 | Yes — system number with timestamp |
| OBSERVED | 0.9 | Yes — directly verified by us |
| STATED | 0.5 | Only after verification |
| NARRATIVE | 0.2 | Context only — cannot drive decisions |
| INFERRED | 0.3 | Hypothesis only |
| HEARSAY | 0.1 | Cannot drive decisions |

### Input 3: Assumption Status (from UNVERIFIED_ASSUMPTIONS_RULE.md)

| Status | Score |
|---|---|
| Verified (confirmed with client or data) | 1.0 |
| Partially verified (some evidence) | 0.6 |
| Unverified (assumed, not confirmed) | 0.2 |
| Contradicted (evidence against) | 0.0 |

## Output Format

Every significant finding or recommendation includes:

```markdown
[Confidence: 0.6 — Source: GA4 MEDIUM (consent gaps), Evidence: DATA, Assumptions: verified]
```

Short form for inline use:

```markdown
[Confidence: HIGH — 3 sources corroborate, all DATA class]
[Confidence: LOW — single STATED source, unverified assumption about developer availability]
[Confidence: MEDIUM — GA4 data reliable but 48h sync lag on Shopify source]
```

## Confidence Thresholds for Action

| Score | Label | Can we... |
|---|---|---|
| ≥ 0.7 | HIGH | Act on it. Create tasks. Recommend to client. |
| 0.4–0.69 | MEDIUM | Flag it. Investigate further. Don't create client-facing tasks yet. |
| 0.2–0.39 | LOW | Note it. Include in "What Could Invalidate" section. Verify before discussing. |
| < 0.2 | UNVERIFIED | Do not present as finding. Internal hypothesis only. |

## Which Skills/Agents Must Use This

Every skill or agent that produces findings or recommendations:

| Skill/Agent | How it integrates |
|---|---|
| `/analyze-gtm` | Confidence score on every channel finding |
| `/health-check` | Confidence score on every anomaly flag |
| `/morning-brief` | Confidence score on every alert |
| `` | Already uses Data Reliability — add unified score |
| `` | Confidence on every performance claim |
| `/7layer` | Confidence per layer assessment |
| Council deliberations | Each agent's position gets a confidence score; consensus weighs by confidence |
| `channel-analyst-*.md` | Per-platform findings scored |
| `audit-checker.md` | Already has confidence — align to this scale |

## Relationship to Existing Guardrails

The three source guardrails **remain as-is**. This engine reads their output and produces a unified score. It does not replace them — it sits on top.

```
DATA_RELIABILITY_FRAMEWORK.md  ──┐
EVIDENCE_CLASSIFICATION_RULE.md ──┼──► CONFIDENCE_ENGINE.md ──► [Confidence: 0.7]
UNVERIFIED_ASSUMPTIONS_RULE.md ──┘
```

## References
- `core/methodology/DATA_RELIABILITY_FRAMEWORK.md`
- `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`
- `core/methodology/UNVERIFIED_ASSUMPTIONS_RULE.md`
