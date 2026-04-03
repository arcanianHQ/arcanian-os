> v1.0 — 2026-03-24

# 11 — Memo-to-Tasks Extraction

> When a memo, email, or proposal is finalized and accepted, extract ALL action items into client TASKS.md with full ontology.
> **Owner:** Whoever sends the deliverable | **Tier:** 1 | **Review:** Per deliverable

## Purpose
No action item in a sent deliverable should exist ONLY in the deliverable. Every commitment becomes a tracked task.

## Trigger
- A memo/email/proposal is marked as final (user says "ok, send it" / "this is final" / "accepted")
- A deliverable file status changes from `-draft.md` to `-sent.md`
- User says "extract tasks from this"

## Process

### 1. Scan the Deliverable
Read the finalized .md file. Look for:
- Explicit action items: "megcsináljuk", "elküldünk", "beállítjuk", "elkészítjük"
- Promises: "you'll receive", "we'll deliver", "we will", "mi fogjuk"
- Deadlines: "by Friday", "this week", "within 3 days", "péntekig"
- Commitments to people: "{name} will...", "{name} fogja..."
- Numbered deliverables in proposals
- Meeting action items referenced
- Guarantees

### 2. For Each Action Item, Create a Task

```markdown
- [ ] #N {action item — specific, actionable}
  - @next @computer
  - P{priority} | Owner: {who committed} | Due: {deadline if mentioned} | Effort: {estimate} | Impact: {assess}
  - Created: {today} | Updated: {today}
  - Layer: {which L0-L7 layer}
  - Email: {deliverable filename} — line {N}
  - Client: {client}
  - Meeting: {if from a meeting}
  - Lead: {if lead-related}
  - {context from the deliverable}
```

### 3. Deduplicate
Before adding, check if a similar task already exists in TASKS.md:
- Same action + same client = duplicate → update existing, don't create new
- Similar action, different scope = separate tasks
- Present: "Found 3 new tasks, 2 already exist. Add the 3 new ones?"

### 4. Get Confirmation
**Show the extracted tasks to the user BEFORE adding:**
```
Extracted from: [client-contact]-tapvalaszto-spec-sent.md

NEW tasks to add to clients/examplelocal/TASKS.md:
  #42 Set up AC email campaign for 2,114 list (P1, @next, L5)
  #43 Brief developer on tápválasztó spec (P1, @next, L3)
  #44 Send [Name] the jóváhagyásra items (P2, @next, L1)

EXISTING (won't duplicate):
  #20 Fix GAds conversion priorities (already tracked)

Add these 3 tasks? [confirm]
```

### 5. Add Tasks + Update Deliverable
After confirmation:
1. Add tasks to client TASKS.md in the correct priority sections
2. Add a `## Tasks Extracted` section at the bottom of the deliverable:
```markdown
## Tasks Extracted (2026-03-24)
- #42 AC email campaign → TASKS.md
- #43 Developer brief → TASKS.md
- #44 [Name] jóváhagyás → TASKS.md
```
3. Update deliverable version: `v1.0 → v1.1 — tasks extracted`

### 6. Update Ontology Backlinks
For each new task:
- If task references a meeting → check meeting file has task backlink
- If task references a lead → update LEAD_STATUS.md timeline
- If task references a finding → update finding with task backlink

### 7. Rename Deliverable
When the memo transitions from draft to sent:
```
[client-contact]-tapvalaszto-spec-draft.md → [client-contact]-tapvalaszto-spec-sent.md
```
Update `Updated:` date.

## Escalation

| Condition | Action |
|---|---|
| Deliverable has vague commitments ("we'll handle it") | Ask: "What specifically does 'handle it' mean? Break it into tasks." |
| Deadline conflict with existing tasks | Warn: "Task #42 due Friday conflicts with #38 also due Friday. Prioritize." |
| Action item has no clear owner | Ask: "Who does this — [Owner], [Team Member 1], [Team Member 2], or the client?" |

## KPIs

| Metric | Target |
|---|---|
| Tasks extracted from 100% of sent deliverables | 100% |
| No orphan commitments (in deliverable but not in TASKS.md) | 0 |
| Task extraction within 5 min of finalization | 100% |
