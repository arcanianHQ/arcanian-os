> v1.0 — 2026-04-03

# Data Reliability Framework (MANDATORY)

> Every data analysis deliverable must include confidence ratings and measurement error impact.
> This is an extension of the Discovery Not Pronouncement guardrail.
> "Would the team trust this number enough to act on it?"

## When to Apply
- Any deliverable with data-driven conclusions
- Skills: /analyze-gtm, , /health-check, /morning-brief
- Databox queries, GA4 analysis, competitive analysis, financial projections
- Client reports, business analysis documents

## Required Sections

### 1. Data Reliability Summary (top of document)

```markdown
## Data Reliability

| Source | Confidence | Known Issues |
|--------|-----------|--------------|
| GA4 (example-retail.com) | MEDIUM | Consent mode misconfigured (#61), ~30-66% data loss |
| Google Ads | HIGH | Direct API, minimal sampling |
| Databox | MEDIUM | Depends on upstream source quality |
| Manual reports | LOW | Self-reported, no validation |
```

### 2. Inline Confidence Markers

Every major finding gets a confidence tag:

```markdown
Premium laminate accounts for 37-42% of Glamour promo revenue.
[Confidence: MEDIUM — GA4 e-commerce data, consent mode may undercount by 30-66%]
```

### 3. Confidence Levels

| Level | Meaning | When to use |
|-------|---------|-------------|
| **HIGH** | Direct measurement, validated, <10% error margin | API data, verified transactions, audited numbers |
| **MEDIUM** | Reasonable measurement, known gaps, 10-40% margin | GA4 with consent issues, sampled data, modeled conversions |
| **LOW** | Estimated, inferred, or structurally unreliable | Cross-device attribution, assisted conversions, self-reported data |
| **UNVERIFIED** | Not measured, only inferred | Assumptions, industry benchmarks applied to client |

### 4. Measurement Error Types

Always check which apply:

| Error Type | Impact | Check |
|-----------|--------|-------|
| **Consent loss** | Undercounts events by 30-66% | Is consent mode properly configured? |
| **Attribution model** | Shifts credit between channels | Which model? Last-click vs data-driven? |
| **Sampling** | GA4 samples at >500K sessions | Check for green shield icon in GA4 |
| **Cross-device** | Misses multi-device journeys | User ID implemented? |
| **Ad blocker** | 15-30% of users invisible | Server-side tracking in place? |
| **Bot traffic** | Inflates pageviews/sessions | Bot filtering enabled? |
| **Currency/tax** | Revenue includes/excludes VAT | Consistent across sources? |
| **Time zone** | Day boundaries shift metrics | All sources same timezone? |
| **Deduplication** | Same conversion counted 2x+ | Multiple tags firing? |

### 5. "What Could Invalidate These Findings?" (end of document)

```markdown
## What Could Invalidate These Findings?

1. **Consent mode fix (#61)** could reveal 30-66% more data, changing all percentages
2. **Attribution model change** could shift channel credit significantly
3. **Seasonal factors** not accounted for (elections, holidays, competitor promos)
4. **Self-selection bias** — promo buyers ≠ non-promo buyers (different populations)

**What did we get wrong? What's missing?**
```

## Integration with Existing Guardrails

- **Discovery Not Pronouncement:** Confidence ratings = the team can check the math
- **Unverified Assumptions:** UNVERIFIED confidence = must verify before acting
- **Evidence Classification Rule:** Every evidence item must be classified (DATA/OBSERVED/STATED/NARRATIVE/INFERRED/HEARSAY). Source system confidence (this framework) is not the same as evidence class. A GA4 number is HIGH confidence DATA. "[Former Team Member] caused the drop" is NARRATIVE — even if repeated in 5 documents.
- **Assumption Guard Hook:** Now also checks for missing confidence markers

## Examples

See: `clients/example-retail/docs/analysis/EXAMPLE_BUSINESS_ANALYSIS_V5.md` — first implementation with full reliability framework.
