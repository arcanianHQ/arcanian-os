---
scope: shared
argument-hint: "phase — EXPLORE, PLAN, ARCHITECT, IMPLEMENT, REVIEW, MONITOR"
---

# Skill: Delivery Phase Tracker (`/delivery-phase`)

## Purpose

Tracks which phase a client engagement is in across the Arcanian delivery lifecycle. Auto-detects phase from project artifacts, or accepts a manual override. Use for status reporting, handoff planning, and ensuring nothing gets skipped.

## Trigger

Use when: user says `/delivery-phase`, "what phase are we in", "engagement status", "where is {client} at", or during client review.

## Input

| Input | Required | Default |
|---|---|---|
| `client_name` | Yes | Inferred from CLAUDE.md if in project dir |
| `phase_override` | No | Auto-detect from artifacts |

## Phase Definitions

### Phase 1: EXPLORE
**Goal:** Understand the client's world. First signal of what's broken.
- Discovery call completed
- `/7layer` diagnostic run (or in progress)
- First Signal document drafted
- **Artifacts:** `brand/7LAYER_DIAGNOSTIC.md` started, meeting notes in `takeover/correspondence/`
- **Exit criteria:** 7-Layer diagnostic complete, client agrees to proceed

### Phase 2: PLAN
**Goal:** Identify constraints and build the repair roadmap.
- `/identify-constraints` run
- `/repair-roadmap` generated
- Brand intelligence profile started (VOICE, ICP, POSITIONING)
- **Artifacts:** `brand/CONSTRAINT_MAP.md`, `brand/REPAIR_ROADMAP.md`, 3+ brand/ files have content
- **Exit criteria:** Roadmap approved by client, TASKS.md populated with execution tasks

### Phase 3: ARCHITECT
**Goal:** Design the strategy and operational structure.
- Strategy documents created
- SOPs adapted for this client's context
- Dashboard/reporting structure planned
- Agency coordination model defined
- **Artifacts:** `processes/` has files, `analysis/` has strategic docs, TASKS.md has P1+ architecture tasks
- **Exit criteria:** Strategy deck delivered, SOPs assigned, dashboards specced

### Phase 4: IMPLEMENT
**Goal:** Execute. Ship. Measure.
- TASKS.md is the heartbeat — tasks being created, completed, moved
- Audit phases running (if measurement audit)
- Agency coordination active
- Regular check-ins logged in CAPTAINS_LOG
- **Artifacts:** TASKS_DONE.md growing, `findings/` and `recommendations/` populated (audit), active CAPTAINS_LOG
- **Exit criteria:** >70% of P0+P1 tasks complete, major deliverables shipped

### Phase 5: REVIEW
**Goal:** Extract knowledge, check quality, document patterns.
- Knowledge extraction from findings
- Pattern checking against known issues
- Quality review of deliverables
- Client feedback collected
- **Artifacts:** `findings/` complete, recommendations delivered, knowledge extracted to core/
- **Exit criteria:** All findings documented, recommendations delivered, knowledge flows back to core

### Phase 6: MONITOR
**Goal:** Ongoing vigilance. The fractional CMO steady state.
- @monitor tasks active in TASKS.md
- Compliance checks running
- Performance tracking against baselines
- Regular reporting cadence established
- **Artifacts:** @monitor tasks with Check/Baseline/Target fields, recurring CAPTAINS_LOG entries
- **Exit criteria:** None — this is the ongoing state for retained clients

## Auto-Detection Logic

Read project artifacts and score each phase's completion:

```
Score per phase = (artifacts_present / artifacts_expected) * 100

Phase detection rules:
1. Find the HIGHEST phase where score > 30% (work has started)
2. Check if the PREVIOUS phase scores > 70% (prerequisites met)
3. If previous phase < 70%: WARN — "Phase {N-1} incomplete, but Phase {N} work detected"
4. Current phase = highest phase with active work
```

### Artifact checks:

| Check | How | Phase |
|---|---|---|
| 7LAYER_DIAGNOSTIC.md has content | File >5 lines | 1 |
| CONSTRAINT_MAP.md has content | File >5 lines | 2 |
| REPAIR_ROADMAP.md has content | File >5 lines | 2 |
| VOICE.md has content | File >5 lines | 2 |
| ICP.md has content | File >5 lines | 2 |
| POSITIONING.md has content | File >5 lines | 2 |
| processes/ has files | Dir not empty | 3 |
| TASKS.md has >10 tasks | Count task lines | 3-4 |
| TASKS_DONE.md has >5 completed | Count done lines | 4 |
| findings/ has files | Dir not empty | 4-5 |
| recommendations/ has files | Dir not empty | 5 |
| @monitor tasks exist | Grep TASKS.md | 6 |
| CAPTAINS_LOG >10 entries | Count `## YYYY-MM-DD` | 4+ |

### Brand intelligence completion:

```
brand_score = count(files > 5 lines) / 7
Report: "Brand intelligence: {N}/7 complete"
List missing files explicitly
```

## Output Format

```
/delivery-phase — {client_name}
═══════════════════════════════════════

Current phase: Phase 4 — IMPLEMENT
═══════════════════════════════════════

Phase progress:
  ✓ Phase 1 EXPLORE .... 100%  (7-Layer complete)
  ✓ Phase 2 PLAN ....... 85%   (missing: BELIEF_PROFILE.md)
  ✓ Phase 3 ARCHITECT .. 90%   (SOPs assigned, dashboard specced)
  ► Phase 4 IMPLEMENT .. 54%   (26 tasks, 14 done)
  · Phase 5 REVIEW ..... 0%
  · Phase 6 MONITOR .... 10%   (2 @monitor tasks created early)

Brand intelligence: 5/7 complete
  Missing: brand/BELIEF_PROFILE.md, brand/POSITIONING.md

Tasks: 26 total | 14 done | 8 P0+P1 remaining | 2 overdue

Next milestones:
  - Complete remaining P0 tasks (4 left)
  - Fill brand/BELIEF_PROFILE.md before Phase 5
  - Schedule Phase 5 review session with client

═══════════════════════════════════════
Diego is in Phase 4 (IMPLEMENT). 26 tasks, 14 done. Missing: brand/BELIEF_PROFILE.md, brand/POSITIONING.md
```

## Phase Override

If user provides a phase override:
1. Set current phase to the override value
2. Still run auto-detection and show discrepancies
3. Log phase override in CAPTAINS_LOG: `Phase manually set to {N} ({reason})`

## Notes

- Phase transitions are not strictly linear. A client can have Phase 6 @monitor tasks while still in Phase 4.
- The one-line summary at the bottom is designed for copy-paste into status updates and Slack.
- For audit-type projects, Phase 4 maps to audit execution phases (Phase 0-5 in AUDIT_TASKS.md).
- Run `/delivery-phase` during weekly client reviews to track progress over time.
