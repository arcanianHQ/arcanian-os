---
scope: shared
argument-hint: process meeting transcripts
---

# Skill: Meeting Sync (`/meeting-sync`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Downloads ALL meetings from Fireflies via MCP, classifies by client, routes to the correct client directory, extracts action items to TASKS.md, and logs to CAPTAINS_LOG. Full ontology integration.

## Trigger

- `/meeting-sync` — pull all new meetings since last sync
- `/meeting-sync {client}` — pull only meetings for a specific client
- `/meeting-sync {date}` — pull meetings from a specific date
- Scheduled: daily at 9 AM (after /morning-brief)

## Prerequisites

- Fireflies MCP authenticated (claude.ai → Fireflies → authenticate)
- Hub session (run from `_arcanian-ops/` root)

## Process

### Step 1: Pull Meetings from Fireflies

**IMPORTANT: Batch to avoid token overflow.** Fireflies returns full summaries + action items per meeting. 30 days of meetings = 100K+ characters = will fail.

**Batching rules:**
- Pull max 5 meetings per API call (not 50)
- Use `limit: 5` + `skip: N` for pagination
- Process each batch before pulling the next
- For historical sync: go week by week, not month at once

```
# First batch
fireflies.get_transcripts(limit: 5, fromDate: "{date}", format: "json")

# Next batch
fireflies.get_transcripts(limit: 5, skip: 5, fromDate: "{date}", format: "json")
```

**For each transcript in the batch, we already get from get_transcripts:**
- Title, Date/time, Duration
- Participants (emails)
- Summary (short_summary, keywords, action_items)
- Meeting info

**Full transcript: fetch SEPARATELY and only when routing to client:**
```
fireflies.get_transcript(transcriptId: "{id}")
```
This avoids loading all transcripts at once.

**Processing order:**
1. Pull metadata batch (5 meetings) via `get_transcripts(limit: 5)`
2. Classify each by client (from metadata — no transcript needed)
3. For each classified meeting: fetch full transcript via `fireflies_fetch(id)`
4. **CRITICAL: The full transcript will auto-save to disk when too large (>10K tokens).** This is EXPECTED. Do NOT try to hold 94-min transcripts in context.
5. Copy the auto-saved file to `clients/{client}/meetings/raw/{date}_{slug}_full.json`
6. Also create a readable .md version from the JSON
7. Create the processed meeting file (summary, action items, ontology edges)
8. Extract tasks
9. Pull next batch

**Transcript handling learned from Mancsbazis 2026-03-23 (94 min = 67K chars):**
- `fireflies_fetch(id)` returns full meeting — will ALWAYS exceed token limit for meetings > 20 min
- Claude auto-saves overflow to: `.claude/projects/.../tool-results/mcp-claude_ai_Fireflies-*.txt`
- Copy that file to `meetings/raw/` as the canonical raw transcript
- Use `fireflies_get_transcripts` metadata (summary, action_items, keywords) for the processed file — this is small enough to work with
- NEVER try to read the full transcript into context — process from disk

**Three files per meeting:**
```
meetings/{date}_{slug}.md                    ← Processed: summary, actions, ontology (human-readable)
meetings/raw/{date}_{slug}_full.json         ← Raw Fireflies JSON (complete, unmodified backup)
meetings/raw/{date}_{slug}_full_readable.md  ← Plain text version of full transcript
```

### Step 2: Classify by Client

Match meeting to a client using:

| Signal | How to match |
|---|---|
| Participant email domain | `@wellis.hu` → wellis, `@diego.hu` → diego |
| Participant name | "Ricsi" → mancsbazis, "Aryan" → ah-tuning-qwallz, "Péter" → deluxe |
| Meeting title | "Wellis weekly" → wellis, "Diego GTM review" → diego |
| Calendar event | If linked to Google Calendar |

**Client mapping table** (update as clients change):

| Signal | Client |
|---|---|
| Ricsi, Kohut, mancsbazis, mancsbázis | mancsbazis |
| Aryan, ah-tuning, qwallz | ah-tuning-qwallz |
| Gábor, Wellis, BuenoSpa, Peti, Viktor, Ákos | wellis |
| Orsi, Péteri, Diego, Magdolna | diego |
| Péter (kocsibeallo context), Deluxe, Zsuzsi, Devin | deluxe |
| Fruzsi, Flora, MiniWash | flora-miniwash |
| Konrád, FelDoBox | feldobox |
| Balázs, Kohut (vrsoft context), Sanyi | vrsoft |
| Dóra, Éva (internal, no client) | internal |

If UNCLEAR → place in `internal/inbox/` with flag for manual classification.

### Step 3: Create Meeting File

For each meeting, create:

```markdown
> v1.0 — {date}

# Meeting: {title}

| Field | Value |
|---|---|
| **Date** | {YYYY-MM-DD HH:MM} |
| **Duration** | {minutes} min |
| **Participants** | {list} |
| **Client** | {classified client} |
| **Fireflies ID** | {transcript_id} |

## Summary
{Fireflies auto-summary}

## Action Items
{Fireflies auto-detected action items, formatted as task candidates}

## Key Decisions
{Extract from transcript: decisions made, commitments, deadlines}

## Key Quotes
{Notable statements that inform diagnostics or strategy}

## Full Transcript
<details>
<summary>Click to expand full transcript</summary>

{full transcript text}

</details>

## Ontology Edges
- Client: {client slug}
- Layer: {which layers were discussed — infer from topics}
- Lead: {if a lead was discussed}
- Meeting: {self-reference for task linking}

## Unverified Assumptions
| Assumption | Based on | Verification question |
|---|---|---|
{Any assumptions made in this meeting that need checking}
```

### Step 3b: Save Raw Transcript

Save the ORIGINAL unprocessed transcript as a separate file:
```
clients/{client}/meetings/raw/{YYYY-MM-DD}_{title-slug}_raw.md
```

This is the unedited Fireflies output — never modify it. The processed meeting file (Step 3) is the working version. Raw is the backup/audit trail.

### Step 4: Route to Client

Save the processed meeting file to:
```
clients/{client}/meetings/{YYYY-MM-DD}_{title-slug}.md
```

Save the raw transcript to:
```
clients/{client}/meetings/raw/{YYYY-MM-DD}_{title-slug}_raw.md
```

Create `meetings/` and `meetings/raw/` directories if they don't exist.

If internal (Dóra/Éva team meeting):
```
internal/meetings/{YYYY-MM-DD}_{title-slug}.md
internal/meetings/raw/{YYYY-MM-DD}_{title-slug}_raw.md
```

### Step 5: Extract Action Items to TASKS.md

For each action item from the meeting:

1. Check if a similar task already exists in the client's TASKS.md (avoid duplicates)
2. If new → create task with full ontology:
```markdown
- [ ] #N {action item description}
  - @next @computer
  - P{priority} | Owner: {who was assigned} | Due: {deadline if mentioned} | Effort: {estimate} | Impact: {assess}
  - Created: {today} | Updated: {today}
  - Layer: {infer from topic}
  - Meeting: {YYYY-MM-DD} {title}
  - {context from meeting}
```
3. Present to user for confirmation before adding: "Found 3 action items. Add to TASKS.md?"

### Step 6: Update CAPTAINS_LOG

For meetings with significant decisions:
```markdown
## {date} — Meeting: {title}
- Participants: {list}
- Key decisions: {list}
- Action items: {count} created in TASKS.md
- Meeting file: meetings/{filename}
```

### Step 7: Update Lead Status (if applicable)

If the meeting involved a lead:
1. Update `LEAD_STATUS.md` timeline:
```
| {date} | Meeting: {title} | ← → | meetings/{filename} |
```
2. Update stage if changed (e.g., Discovery → Pitched)

### Step 8: Sync Log

Update `.meeting-sync.log`:
```
{date} | Synced {N} meetings | Clients: wellis(2), diego(1), internal(1) | Tasks: 5 created
```

Track `last_sync_date` so next run only pulls new meetings.

## `/meeting-sync all` — Full Historical Sync

First-time setup: pull ALL Fireflies meetings, classify, route, extract.

**Strategy (MUST follow to avoid token overflow):**
1. Start from most recent week, work backwards
2. Pull 5 meetings at a time (limit: 5)
3. Process each batch completely before pulling next
4. For each meeting: classify from metadata FIRST, then fetch transcript only for that meeting
5. Show progress: "Batch 1/N: 5 meetings processed (wellis: 2, internal: 3)"
6. If a batch fails (too large): reduce to 3 per batch
7. Save progress to `.meeting-sync.log` after each batch (resume-safe)

```
Week 1: 2026-03-17 → 2026-03-24 (most recent first)
  Batch 1: limit 5, skip 0 → process → save
  Batch 2: limit 5, skip 5 → process → save
Week 2: 2026-03-10 → 2026-03-17
  ...continue backwards
```

**Never pull more than 5 meetings with summaries in one API call.**
**Never fetch full transcripts in batch — always one at a time.**

## Meeting Catalogue

After sync, update `internal/MEETING_CATALOGUE.md`:

```markdown
# Meeting Catalogue

> All meetings synced from Fireflies. Auto-updated by /meeting-sync.

| Date | Title | Client | Duration | Tasks | File |
|---|---|---|---|---|---|
| 2026-03-24 | Wellis Weekly | wellis | 45 min | 3 | clients/wellis/meetings/... |
| 2026-03-24 | Dóra-Éva standup | internal | 15 min | 1 | internal/meetings/... |
```

## Ontology Integration

Every meeting file is a node in the knowledge graph:
- Meeting → Client (which client)
- Meeting → Tasks (action items extracted)
- Meeting → Lead (if lead discussed)
- Meeting → Layer (topics mapped to L0-L7)
- Task → Meeting (backlink: "this task came from this meeting")
- LEAD_STATUS → Meeting (timeline entry)
- CAPTAINS_LOG → Meeting (decision record)

Query: `/query meeting 2026-03-24` → shows all meetings that day + connected tasks + decisions
