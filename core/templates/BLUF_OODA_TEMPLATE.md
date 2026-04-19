---
scope: shared
---

# BLUF+OODA Deliverable Template

> Source: Pentagon briefing format + the observe-orient-decide-act decision loop
> Adapted from Marketing Council v12 (Karpathy LLM Council derivative)
> Added to Arcanian Ops: 2026-03-25

## When to Use

Use this format for:
- Executive summaries of diagnostic outputs (/7layer, constraint mapping, repair planning)
- Client-facing recommendation documents
- Internal decision memos
- Health check and morning brief summaries
- Any deliverable where the reader needs to decide, not just understand

## Template

```markdown
## BLUF (Bottom Line Up Front)

[Conclusion first. 2-3 sentences. Include confidence level as percentage.]
[What we recommend and why, in plain language.]

**Data confidence:** [HIGH/MED/LOW] — [source systems]
**Causal confidence:** [HIGH/MED/LOW] — [evidence class: DATA/OBSERVED/INFERRED/NARRATIVE]
**If wrong:** [What would invalidate this conclusion — the falsification indicator]

---

## OBSERVE (Key Intelligence)

What we found (facts only, no interpretation). Every item MUST have evidence tag:

- [Observation 1] `[DATA: source, date]`
- [Observation 2] `[DATA: source, date]`
- [Observation 3] `[OBSERVED: method, date]`
- [Observation 4] `[STATED: who, when]`
- Only DATA and OBSERVED items here. NARRATIVE/INFERRED → Orient section.

---

## ORIENT (Analysis)

How we interpret these observations. NARRATIVE and INFERRED evidence belongs here — classified, not in Observe:

**Leading analysis:** [Primary interpretation] `[evidence class]`

**Alternative interpretation:** [Competing explanation] `[evidence class]`

**Challenge:** [Strongest argument against the leading analysis]

**Unverified claims in this analysis:**
- [Claim 1] `[NARRATIVE]` — verification: [what data would confirm/deny]
- [Claim 2] `[INFERRED]` — verification: [what data would confirm/deny]

**What we don't know:** [Key unknowns that could change the picture]
**What platform-side data is missing:** [Meta Ads Manager / Google Ads / etc.]

---

## DECIDE (Recommendation)

**Primary:** [Recommended course of action]

**Alternative A:** [Second option — when to choose this instead]
**Alternative B:** [Third option — when to choose this instead]

**Why not the alternatives:** [Brief reasoning]

---

## ACT (Immediate Actions)

| # | Action | Who | By When | Success Metric |
|---|--------|-----|---------|----------------|
| 1 | [specific action] | [name/role] | [date] | [how to measure] |
| 2 | [specific action] | [name/role] | [date] | [how to measure] |
| 3 | [specific action] | [name/role] | [date] | [how to measure] |

---

## RISK ASSESSMENT

| Risk | Probability | Impact | Mitigation | Decision Trigger |
|------|-------------|--------|------------|-----------------|
| [risk 1] | [H/M/L] | [H/M/L] | [what to do] | [when to act] |
| [risk 2] | [H/M/L] | [H/M/L] | [what to do] | [when to act] |

---

## SUCCESS METRICS

| Metric | Current | Target | Timeline | Owner |
|--------|---------|--------|----------|-------|
| [metric 1] | [now] | [goal] | [when] | [who] |
| [metric 2] | [now] | [goal] | [when] | [who] |
```

## Rules

1. **Max 700 words** — if it's longer, cut. Brevity is respect for the reader's time.
2. **BLUF is the first thing they read** — no preamble, no context-setting before it.
3. **Always include falsification indicator** — "if X happens, this conclusion is wrong."
4. **Show alternatives in DECIDE** — one truth is pronouncement, alternatives are discovery.
5. **ACT must have WHO and WHEN** — actions without owners are wishes.
6. **Decision triggers in RISK** — not just risks, but when to change course.
7. **Confidence is honest** — 60% is fine. Don't inflate to sound certain.
8. **Split confidence** — data confidence ≠ causal confidence. "Sessions -38% [DATA: HIGH]" and "because X [INFERRED: LOW]" are separate.
9. **Evidence classification mandatory** — every item in OBSERVE tagged. Every causal claim in ORIENT classified. See `EVIDENCE_CLASSIFICATION_RULE.md`.
10. **Platform-side data** — GA4 alone is insufficient for causal diagnosis. Always check: did we also look at Meta Ads Manager, Google Ads, Criteo, etc.?

## Integration with Arcanian Deliverables

This template slots into the existing save-deliverable flow:

```
Step 0: Load recipient tone
Step 1: Generate content using BLUF+OODA structure
Step 2: Route to correct location (per save-deliverable)
Step 3: Add ontology edges
Step 4: Save + open in Typora
Step 5: Confirm draft/final
Step 6: If final → extract tasks from ACT table
```

The ACT table maps directly to TASKS.md entries:
- Each row becomes a task
- "Who" → Owner
- "By When" → Due
- "Success Metric" → exit criteria in task description

## Compatibility

Works alongside existing output formats:
- **Constraint Map** (constraint-mapping stage) → add BLUF+OODA as executive summary section
- **Repair Roadmap** (repair-planning stage) → add BLUF+OODA as opening section
- **7-Layer Diagnosis** (/7layer) → add BLUF+OODA for client-facing summary
- **Health Check** (/health-check) → BLUF+OODA replaces flat summary section
- **Morning Brief** (/morning-brief) → BLUF+OODA structures the brief
