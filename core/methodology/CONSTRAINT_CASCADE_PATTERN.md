---
scope: shared
---

# Constraint Cascade Pattern

> v1.0 — 2026-04-16

## What Is a Constraint Cascade

A constraint cascade is a multi-phase audit or optimization pipeline where findings from earlier phases **gate** entry into later phases. The constraint from phase N is explicitly routed upstream before phase N+1 begins.

This is different from a simple phased pipeline:
- **Phased pipeline:** phases run in order because that's the procedural sequence. Phase 2 always follows Phase 1.
- **Constraint cascade:** phases run in order because the output of phase N determines **whether** phase N+1 should run and **with what modified scope**. Phase 2 may not run at all if Phase 1 reveals a blocking constraint.

The key property: **escalation is not failure.** When a phase discovers a constraint it cannot resolve, it routes upstream to the phase that can — then re-enters the cascade at the correct point.

## Canonical Structure

```
Phase N
  ↓
[Findings]
  ↓
Constraint Evaluation
  ↓
┌─────────────────────────────────────────┐
│ GATE: Does the finding block Phase N+1? │
├─────────────────────────────────────────┤
│ PROCEED → Phase N+1                     │
│ ESCALATE → Route to upstream phase      │
│   ↓                                     │
│   Upstream resolves                     │
│   ↓                                     │
│   Re-enter cascade at Phase N           │
│ HALT → Log constraint, stop cascade     │
└─────────────────────────────────────────┘
```

**Key properties:**
1. Each gate has **explicit pass criteria** — not "good enough" but specific conditions
2. "Escalate" routes to a **named** upstream phase or authority, not vaguely "resolve first"
3. A halted cascade **logs why** — which constraint blocked which phase
4. Cascades are **not recursive by default** — an upstream routing resolves once, then the cascade proceeds or halts
5. The constraint that triggered escalation is **tagged**: `[CONSTRAINT: {what}, Route: {upstream phase/skill}]`

## Existing Implementations in AOS

### 1. Repair planning — ACH-gated layer sequencing

The constraint map from the constraint-classification step determines which layers are locked and which repair actions are feasible.

**Cascade:** `/7layer` (diagnose) → constraint-classification (classify locks) → ACH hypothesis validation → **gate** → repair planning (plan only feasible repairs) → execute

**Gate logic:** If the leading hypothesis about root cause cannot be verified, a falsification indicator is built into Month 1 as a validation gate:
> "If [indicator] is observed by [date], STOP and reassess. Switch to repair sequence for H[Y]."

Locked layers do not halt the cascade — they are assigned parallel strategies (buffer / prove / automate / side door) while unlocked layers proceed sequentially. The cascade halts only when the deepest broken layer cannot be addressed by any available strategy.

### 2. `/measurement-audit` — Phase-gated audit pipeline

The 7-agent council runs 5 phases with explicit gates between them.

**Cascade:**
- Phase 0 (feed + sGTM) must pass → Phase 1 (consent / GDPR gate)
- Phase 1 must pass → Phase 3 (GTM audit)
- Phase 3 completes → Phase 4 (cross-system verification)
- Phase 4 completes → Phase 5 (pattern matching + recommendations)

**Gate logic:** Phase 1 is a GDPR compliance gate — if consent mode is fundamentally broken, GTM tag analysis in Phase 3 produces misleading data (tags fire but data is discarded). The cascade prevents wasting audit effort on downstream phases when the upstream constraint (consent) invalidates their findings.

### 3. `/health-check` — Sync-lag-gated anomaly detection

Step 4b checks data freshness before flagging anomalies.

**Cascade:** Load baselines → Check sync lag from DOMAIN_CHANNEL_MAP.md → **gate** → Evaluate anomaly

**Gate logic:** If data source lag exceeds the metric freshness window, the finding is routed to "awaiting sync" instead of "anomaly detected." This prevents false alarms from stale data — the constraint (data lag) gates the diagnostic (anomaly evaluation).

### 4. Confidence Engine — Evidence-quality cascade

`CONFIDENCE_ENGINE.md` implements a constraint cascade on evidence quality itself.

**Cascade:** Evidence class → Source confidence → Assumption status → **gate** → Final confidence score

**Gate logic:** `min(source_confidence, evidence_class, assumption_status)` — the weakest link determines the ceiling. An `[INFERRED]` evidence tag caps confidence regardless of how strong the data source is.

## Implementing a New Cascade

Checklist for any new audit → optimize skill:

1. **Define phases with explicit dependencies.** Which phase must complete before which? Draw the dependency graph.
2. **For each phase boundary, define three outcomes:**
   - **Pass criteria:** specific conditions (not "looks good")
   - **Escalation condition:** what triggers routing upstream, and to which named phase/skill
   - **Halt condition:** what makes the cascade stop entirely
3. **Route escalations to a named target.** Not "resolve the dependency first" — specify `/tracking-specialist` or "Phase 1 re-run with updated consent config."
4. **Log the constraint:** `[CONSTRAINT: {what blocked}, Route: {where it was sent}]`
5. **Define the re-entry point.** After upstream resolution, does the cascade restart from the beginning, from the gate that triggered escalation, or from a specific checkpoint?
6. **Halt gracefully.** A halted cascade produces a report explaining: what was completed, what was blocked, what constraint caused the halt, and what must be resolved before the cascade can resume.

## The Test

> "If I hand this cascade's output to someone else, can they tell exactly where it stopped, why, and what needs to happen to resume it?"

If the answer is no, the gates are not explicit enough.

## References

- Repair-planning skill (available in company + advanced flavours) — constraint-gated layer sequencing
- `/measurement-audit` (`core/skills/measurement-audit/measurement-audit.md`) — phase-gated audit pipeline
- `/health-check` (`core/skills/health-check.md`) — sync-lag-gated anomaly detection
- `core/methodology/CONFIDENCE_ENGINE.md` — evidence-quality cascade
