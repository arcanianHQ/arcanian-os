---
scope: shared
---

> v1.0 — 2026-04-03

# System Rule: Recommendation Deduplication

> **SYSTEM-WIDE RULE** — applies to ALL skills and agents that create recommendations (REC).
> "A consultant who gives the same advice twice without checking if it worked the first time is not a consultant."

---

## The Rule

Before creating any recommendation (REC), check `RECOMMENDATION_LOG.md` in the client directory:

1. **Has this been recommended before?** Search by metric targeted, topic, or similar phrasing.
2. **If yes — what happened?**
   - `confirmed` → Recommend again with evidence it works. "Previously recommended (REC-042), confirmed effective."
   - `no effect` → Do NOT recommend again without new evidence. "Previously recommended (REC-042) with no measurable effect. Consider alternative approach."
   - `too early` → Note it's in progress. "Already in progress (REC-042), awaiting results."
   - `invalidated` → Do NOT recommend. "Previously tried (REC-042) and invalidated."
   - `open` → Flag duplicate. "Already recommended (REC-042), not yet executed."
3. **If no prior recommendation:** Create normally.

## Output Format

When a recommendation has prior history:

```markdown
### REC-058: Increase PMAX budget for medencevasar.hu
**Previously recommended:** REC-034 (2026-02-15) — status: no effect
**What changed:** New creative assets available, seasonal demand shift
**Why this time is different:** [specific evidence]
[Confidence: MEDIUM — prior attempt failed, new conditions may change outcome]
```

## Which Skills/Agents Must Check

Any skill or agent that outputs RECs:
- `/analyze-gtm`, `/plan-gtm`
- Repair-planning runs
- `/health-check` (when creating follow-up tasks)
- `/7layer`, `/7layer-hu`
- Council deliberations
- `channel-analyst-*.md` agents
- `outcome-tracker.md` agent

## Dismissal Tracking (MANDATORY for no_effect/invalidated)

When marking a REC as `no effect` or `invalidated`:
1. **`Detected Pattern` field is MANDATORY** — what triggered this REC (e.g., "missing consent mode", "ROAS below threshold")
2. **`Dismissed Reason` field is MANDATORY** — why it didn't work (e.g., "already handled by agency", "false positive — seasonal effect")
3. These fields feed `/output-review` Step 5b — systematic false positive detection
4. If the same `detected_pattern` appears dismissed 3+ times across clients → the detecting agent/skill prompt needs improvement

**Anti-pattern:** "no effect" with empty `dismissed_reason` = lost learning. Every dismissal is data.

## References
- Per-client `RECOMMENDATION_LOG.md`
- `core/methodology/CONFIDENCE_ENGINE.md`
