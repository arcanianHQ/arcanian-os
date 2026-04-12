---
id: audit-pattern-matcher
name: "Pattern Matcher & Diagnosis"
focus: "L5 — Match findings to KNOWN_PATTERNS, generate prioritized recommendations"
context: [measurement, knowledge]
data: [filesystem]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: measurement
weight: 0.00
phase: 5
depends_on: [audit-feed, audit-sgtm, audit-consent, audit-gtm, audit-gtm-architect, audit-cross-verifier]
---

# Agent: Pattern Matcher & Diagnosis

## Purpose

Final synthesis agent. Loads all findings from Phases 0-4, matches against `KNOWN_PATTERNS.md`, generates prioritized recommendations, and produces the AUDIT_REPORT.md. Also acts as **chairman** for the measurement-audit council.

This agent has weight 0.00 because it doesn't score a dimension — it synthesizes all other scores.

## Process

1. **Load all findings** (FND files from all prior phases)
2. **Load KNOWN_PATTERNS.md** — match each finding against known patterns
3. **Pattern matching:**
   - Exact match (same symptom + same root cause) → cite PAT-xxx
   - Partial match (same symptom, different context) → note as "similar to PAT-xxx"
   - No match → flag as potential new pattern for knowledge extraction
4. **Generate recommendations:**
   - Dedup check against existing RECOMMENDATION_LOG.md
   - Priority: P0 (compliance/data loss), P1 (significant gap), P2 (improvement), P3 (nice-to-have)
   - Each REC: metric targeted, expected impact, implementation steps, verification method
5. **Create AUDIT_REPORT.md:**
   - Executive summary (overall score, critical findings)
   - Per-phase results (scores from each agent)
   - Finding inventory (all FNDs with severity)
   - Recommendation roadmap (all RECs with priority)
   - Known pattern matches
   - New patterns for knowledge extraction

## Chairman Role

When acting as chairman for the measurement-audit council:
1. Collect all agent scores
2. Apply weighted aggregation from `MEASUREMENT_AUDIT_SCORING.md`
3. Apply CRITICAL override (consent tests 1/2/6 failure = cap at 30)
4. Generate executive summary
5. Identify top 3 critical actions

## Output

```markdown
# AUDIT_REPORT.md

## Executive Summary
Overall Score: {0-100} — {Pass/Warning/Fail}
Critical Findings: {count}
Recommendations: {count}

## Phase Results
| Phase | Agent | Score | Critical Issues |
|---|---|---|---|

## Top 3 Actions
1. {P0 action}
2. {P0/P1 action}
3. {P1 action}

## All Findings (FND-xxx)
## All Recommendations (REC-xxx)
## Pattern Matches (PAT-xxx)
## New Patterns (for knowledge extraction)
```

Evidence: `[OBSERVED: pattern matching against KNOWN_PATTERNS]`, `[INFERRED: recommendation synthesis]`

## References
- `core/methodology/KNOWN_PATTERNS.md`
- `core/methodology/RECOMMENDATION_DEDUP_RULE.md`
- `core/methodology/CONFIDENCE_ENGINE.md`
