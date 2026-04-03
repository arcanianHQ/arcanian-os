> v1.0 — 2026-04-03

# SOP-08: Quarterly Review

> Client engagement health check and renewal decision every 90 days.

---

## 1. Purpose

Every active client engagement gets a structured health check every 90 days. This prevents drift, catches stale work, validates that the diagnostic profile is still accurate, and forces an explicit renewal or expansion decision. No engagement runs on autopilot.

## 2. Trigger

- First week of each calendar quarter (Q1: Jan, Q2: Apr, Q3: Jul, Q4: Oct)
- Or: 90 days from engagement start date (whichever comes first for new clients)

## 3. RACI

| Activity | Founder | Research Lead | Delivery Lead | Analyst |
|----------|---------|---------------|---------------|---------|
| Intelligence profile review | A | R | C | C |
| Task completion review | A | I | R | C |
| CAPTAINS_LOG trajectory review | A, R | C | C | I |
| Delivery phase check | A | I | R | I |
| Client satisfaction check | A, R | I | I | I |
| Renewal/expansion decision | A, R | C | C | I |
| PROJECT_REGISTRY update | A | I | R | I |

## 4. Systems & Tools

- Client `brand/` directory (7-file intelligence profile)
- Client TASKS.md
- Client CAPTAINS_LOG.md
- `/delivery-phase` skill
- PROJECT_REGISTRY.md

## 5. Steps

### 5.1 Intelligence Profile Review

- Pull up all 7 files in the client's `brand/` directory (see SOP-06)
- For each file, ask: "Is this still accurate? Has anything changed?"
- Specific checks:
  - 7LAYER_DIAGNOSTIC.md: have any layers improved or deteriorated?
  - CONSTRAINT_MAP.md: is the primary constraint still the primary constraint?
  - .md: have decision-maker patterns shifted?
  - REPAIR_ROADMAP.md: are we on track with the sequencing?
- Update any files that are stale or inaccurate

### 5.2 Task Completion Review

- Review client TASKS.md
- Calculate: completion rate (tasks completed / tasks assigned)
- Identify: stale tasks (assigned but not progressing for 30+ days)
- Identify: tasks that were assigned but never made sense (scope creep signals)
- Clean up: archive completed tasks, flag stale ones for discussion

### 5.3 CAPTAINS_LOG Trajectory Review

- Read through the quarter's CAPTAINS_LOG entries
- Look for: trajectory (are we moving forward, plateauing, or regressing?)
- Look for: recurring themes (same issue coming up repeatedly = not resolved at root)
- Look for: decisions that were made but not executed (DIAMOND "O" gap signal)

### 5.4 Delivery Phase Check

- Run `/delivery-phase` to assess current engagement phase
- Confirm: are we in the phase we expected to be in by now?
- If behind: why? What blocked progression?
- If ahead: what accelerated? Can we capture that pattern?

### 5.5 Client Satisfaction Check

- Direct conversation with client decision-maker (preferred) or structured check-in
- Questions:
  - "What's been most valuable so far?"
  - "What's not working or feels off?"
  - "Has anything changed in your business that we should factor in?"
  - "On a scale of 1-10, how confident are you in the direction we're heading?"
- Document responses honestly (including critical feedback)

### 5.6 Renewal / Expansion Decision

Based on all inputs above, make an explicit decision:

| Decision | Criteria |
|----------|----------|
| **Renew** (same scope) | Profile still accurate, tasks progressing, client satisfied, current phase appropriate |
| **Expand** (increase scope/tier) | New layers uncovered, client ready for deeper work, trust established |
| **Reduce** (decrease scope) | Core work complete, client can maintain independently, diminishing returns |
| **End** (conclude engagement) | Objectives met, or engagement not producing value despite efforts |

- Decision must be documented with rationale
- Founder makes final call after team input

### 5.7 Update PROJECT_REGISTRY.md

- Update engagement status (active, expanding, winding down, concluded)
- Update phase and health score
- Log renewal decision and rationale
- Note any significant changes to scope or approach

## 6. Escalation

- If client satisfaction score < 6/10 --> Founder schedules immediate 1:1 with client to address concerns
- If task completion rate < 50% --> Team review: is scope wrong, or is execution blocked?
- If intelligence profile is significantly outdated --> Prioritize profile refresh before continuing delivery
- If renewal decision is contested within team --> Founder makes final call but documents dissenting view

## 7. KPIs

| Metric | Target |
|--------|--------|
| Quarterly review completed | Within first week of quarter |
| All active clients reviewed | 100% coverage |
| Renewal decision documented | For every client, every quarter |
| Profile updates completed | Same week as review |
| Client satisfaction recorded | Every review cycle |

## 8. Review Cadence

- **Quarterly:** This IS the review cadence (self-referential by design)
- **Annually:** Review the quarterly review process itself -- is it catching what it should?

## 9. Related SOPs

- SOP-06: Client Intelligence Profile (profile accuracy)
- SOP-07: Knowledge Sharing (patterns from reviews feed standups)
- SOP-01: Client Onboarding (for new engagements post-expansion decision)
