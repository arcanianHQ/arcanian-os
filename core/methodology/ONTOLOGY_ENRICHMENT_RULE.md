---
scope: shared
---

# Ontology Enrichment Rule — Automatic Palantir-Style Linking

> Every object in the system (task, finding, file, deliverable, meeting, lead) MUST be linked
> to every related object via typed, bidirectional edges. This is NOT optional documentation —
> it is what makes /query, /task-oversight, and cross-client pattern detection work.
> This is an ALWAYS-ON behavior, not a slash command.

## When Enrichment Happens (Automatically)

### 1. On Task Create / Update

When `/tasks create` or `/tasks update` runs, BEFORE saving:

**Auto-detect and add these edges from task content:**

| If the task mentions... | Auto-add edge | Example |
|------------------------|---------------|---------|
| A finding number (FND-NNN) | `FND: FND-039` | "fix the issue from FND-039" → adds `FND: FND-039` |
| A recommendation (REC-NNN) | `REC: REC-039` | "implement REC-039" → adds `REC: REC-039` |
| An SOP name or number | `SOP: {sop-name}` | "follow the campaign SOP" → adds `SOP: 05-CAMPAIGN-MANAGEMENT` |
| A meeting date | `Meeting: {date} {label}` | "from Monday's meeting" → adds `Meeting: 2026-03-24 weekly` |
| A person who requested it | `From: {person}` | "Ákos asked for this" → adds `From: Ákos` |
| A domain name | `Domain: {domain}` | "on buenospa.com" → adds `Domain: buenospa.com` |
| A goal reference | `Goal: {goal}` | "for the Q1 website launch" → adds `Goal: Q1-website-live` |
| A lead reference | `Lead: {slug}` | "for the Euronics pitch" → adds `Lead: euronics` |

**Auto-create backlinks:**

| When task gets this edge | Also update the target | How |
|-------------------------|----------------------|-----|
| `FND: FND-039` | Finding file FND-039 → add `Tasks: #{N}` | Read + Edit finding file |
| `REC: REC-039` | Recommendation file REC-039 → add `Tasks: #{N}` | Read + Edit rec file |
| `Lead: euronics` | LEAD_STATUS.md → add `#{N}` to euronics Tasks section | Read + Edit lead file |
| `Goal: Q1-website-live` | (soft — no backlink needed, queryable via grep) | — |

### 2. On File Intake (from Downloads, inbox, etc.)

When a file is routed via FILE_INTAKE_RULE.md, auto-add:
- `Client:` edge (which client project)
- `Domain:` edge (which domain if detectable)
- `Layer:` edge (which layer this file relates to)
- `Meeting:` edge (if it's meeting notes, link to the meeting)
- `From:` edge (who provided the file)

### 3. On Deliverable Save

When save-deliverable runs, the ontology block is ALREADY part of the template:
```markdown
## Ontology
- Client: {slug}
- Layer: {layers}
- Meeting: {if from meeting}
- Lead: {if for lead}
- Task: {if fulfilling task}
```

**Additionally:** If the deliverable creates tasks (Step 7 extraction), those tasks auto-get `From:` = deliverable source.

### 4. On Task Complete

When `/tasks complete #N` runs:
- If task has `FND:` edge → check: is the finding now fully resolved? Update finding status.
- If task has `Lead:` edge → update LEAD_STATUS.md timeline.
- If task has `Inform:` → show notification reminder.
- If task has `Blocks:` → check: are blocked tasks now unblocked? Suggest moving to @next.

### 5. On Data Analysis Completion (Auto-Extract Events)

When any analysis skill (`/7layer`, `/analyze-gtm`, `/council`, `/measurement-audit`, results-mapping runs, channel-analyst agents) completes:

**Scan output for dated inflection points and auto-append to EVENT_LOG.md:**

| If the analysis discovers... | Auto-create | Source tag |
|------------------------------|-------------|------------|
| Budget change with date (from spend data) | EVT row: type=`budget` | `[DATA: Databox]` |
| Account/property start/stop date | EVT row: type=`platform` | `[DATA: Databox]` or `[OBSERVED: {platform}]` |
| Campaign launch/kill date | EVT row: type=`campaign` | `[DATA: Databox]` or `[OBSERVED: {platform}]` |
| Tracking deployment date (GTM version, sGTM change) | EVT row: type=`tracking` | `[OBSERVED: GTM]` |
| Agency handover date (from meeting/email) | EVT row: type=`agency` | `[STATED: {person}]` |
| Unexplained inflection point (>15% change, cause unknown) | EVT row: type=inferred from data | `[INFERRED]` + create verification task |

**Dedup check:** Before appending, scan EVENT_LOG.md for existing entries with same date + type. If found, update Impact column instead of creating duplicate.

**Backlink:** If the analysis produced a Finding (FND-NNN), add `Events: EVT-YYYY-MM-DD-NNN` to the finding's Links section.

### 6. On Meeting Sync / Inbox Process (Auto-Extract Events)

When `/meeting-sync` or `/inbox-process` processes content:

**Scan for operational event statements:**
- "We changed the budget" → EVT type=`budget`, source=`[STATED: {speaker}]`
- "The new agency starts" → EVT type=`agency`, source=`[STATED: {speaker}]`
- "We launched the campaign" → EVT type=`campaign`, source=`[STATED: {speaker}]`
- "We migrated to..." → EVT type=`migration`, source=`[STATED: {speaker}]`

**Convert relative dates to absolute** (per TEMPORAL_AWARENESS_RULE.md) before saving.

### 7. On Council / Pipeline Output

Council and pipeline outputs auto-include:
- `stage-result` block with structured data (already implemented)
- Ontology block linking to client, layers, agents, tasks
- Any tasks extracted from ACT table get `From: /council {type} {date}`

## What the Hook Enforces

The `post-tool-use-ontology-check.sh` hook fires on Write/Edit and checks:

**For TASKS.md edits:**
- Task has Layer → YES/NO (already checked by format hook)
- Task references a FND → does the FND file have a backlink to this task? → WARN if not
- Task references a Lead → does LEAD_STATUS have this task? → WARN if not

**For Finding file edits:**
- Finding has `Tasks:` section → YES/NO → WARN if missing
- Finding has `Related: REC-NNN` → does the REC file exist and backlink? → WARN if not
- Finding has `Pattern: PAT-NNN` → does KNOWN_PATTERNS have a `Seen in:` entry? → WARN if not

**For Deliverable edits:**
- File has `## Ontology` section → YES/NO → WARN if missing
- Ontology has `Client:` → YES/NO → WARN if missing
- Ontology has `Layer:` → YES/NO → WARN if missing

## How It Connects to the 7-Layer Framework

Every object in the system exists AT a layer:
- Tasks have `Layer: L5`
- Findings have `Layer: L5`
- Deliverables have `Layer: L5, L7` in their ontology
- Leads are worked at specific layers

This means you can query: "Show me everything at L5 for Wellis" and get:
- Tasks tagged L5
- Findings at L5
- Deliverables touching L5
- Meetings where L5 was discussed

**This is the Palantir model:** objects + typed edges + layer as the coordinate system.

## Coverage Targets

| Edge Type | Current | Target | Enforcement |
|-----------|:-------:|:------:|:-----------:|
| Task → Layer | ~82% | 100% | Hook (format check) — ACTIVE |
| Task → Domain | ~0% | >50% (multi-domain clients) | Hook (format check) — ACTIVE |
| Task → From/Inform | ~0% | >80% | Hook (soft warn) — ACTIVE |
| Task → FND (with backlink) | ~35 | All FND-referencing tasks | Hook (ontology check) — NEEDS WIRING |
| Finding → Task (backlink) | 0 | All findings | Hook (ontology check) — NEEDS WIRING |
| Lead → Task | 0 | All lead-related tasks | Hook (ontology check) — NEEDS WIRING |
| Deliverable → Ontology block | ~60% | 100% | Hook (ontology check) — NEEDS WIRING |
