---
scope: shared
argument-hint: triage inbox files
---

# Skill: Inbox Process (`/inbox`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

Processes all unprocessed files in `inbox/`. Identifies each file, renames per naming conventions, moves to the correct location, extracts action items to TASKS.md, and logs everything.

## Trigger

- `/inbox` — process current project's inbox
- `/inbox all` — process ALL inboxes across the hub (hub session only)
- User says "process inbox", "triage inbox", "what's in the inbox"

## Process

### Step 1: Enumerate

List all files in `inbox/` (excluding `.gitkeep`, `.DS_Store`).
If empty → "Inbox is empty." and stop.

Show summary:
```
Inbox: 5 files to process
1. 2026-03-20_aryan-meeting-notes.md (4.2KB)
2. GTM-TCBKRN76_workspace53.json (12KB)
3. screenshot-consent-banner.png (450KB)
4. email-from-ricsi.md (1.1KB)
5. random-article-about-seo.md (8KB)
```

### Step 2: Classify Each File

For each file, determine:

| Classification | Where it goes | Naming |
|---|---|---|
| **Meeting notes/transcript** | `notes/` or `takeover/correspondence/` | `YYYY-MM-DD_meeting-title.md` |
| **Email/message** | `takeover/correspondence/` | `{sender}-{topic}-{sent/received}.md` |
| **GTM/sGTM export** | `data/gtm-exports/` | `GTM-{ID}_workspace{N}.json` — see GTM_DATA_STANDARD.md |
| **Screenshot** | `audit/data/screenshots/` or `data/screenshots/` | `YYYY-MM-DD_description.png` |
| **Article/reference** | `archive/` (if not actionable) or relevant dir | `YYYY-MM-DD_title.md` |
| **Proposal/ajánlat** | Root or `proposals/` | `{client}-arajanlat-v{N}.md` |
| **Finding draft** | `audit/findings/` | `FND-NNN_slug.md` |
| **Client data** | `data/` | Per data type naming |
| **Action item** | Extract to TASKS.md, file to relevant dir | Task format |
| **Unknown** | Leave in inbox, flag for manual review | — |

### Step 3: Extract Action Items

For each file, check if it contains action items:
- Explicit: "TODO", "kell", "szükséges", "elküldeni", "megcsinálni"
- Implicit: questions needing answers, decisions pending, deadlines mentioned
- Meeting action items: "Ricsi megígérte", "Éva ellenőrzi"

For each action item found:
1. Create a task in TASKS.md with proper format
2. Link back to the source file: `Email: {filename}`
3. Set appropriate GTD label (@next, @waiting, etc.)

### Step 3b: GTM Export Special Handling

When a `.json` file is detected as a GTM container export:

1. **Parse container ID + workspace number** from the JSON:
   ```python
   container_id = data["containerVersion"]["container"]["publicId"]  # e.g., "GTM-5F544SR3"
   workspace = data["containerVersion"]["containerVersionId"]         # e.g., "52"
   ```

2. **Rename** to standard: `GTM-{container_id}_workspace{workspace}.json`

3. **Move** to `data/gtm-exports/`

4. **Update GTM_CHANGELOG.md** (create if doesn't exist):
   ```markdown
   | {today} | {container_type} | ws{prev} | ws{workspace} | New export from inbox | — |
   ```

5. **Run inventory** if `gtm-tag-inventory.py` is available:
   ```bash
   python3 ../../core/scripts/analysis/gtm-tag-inventory.py data/gtm-exports/GTM-{ID}_workspace{N}.json > data/gtm-exports/GTM_INVENTORY.md
   ```

6. **Update CLIENT_CONFIG.md** if container ID is new (not yet listed)

7. **Log**: `MOVED: inbox/{original_name} → data/gtm-exports/GTM-{ID}_workspace{N}.json (container: {type}, workspace: {N})`

See: `core/methodology/GTM_DATA_STANDARD.md` for full standard.

### Step 4: Move and Rename

Move each classified file to its destination with proper naming.
Log every move:
```
MOVED: inbox/email-from-ricsi.md → takeover/correspondence/ricsi-taplista-kerdes-received.md
MOVED: inbox/GTM-TCBKRN76_workspace53.json → audit/data/gtm-exports/GTM-TCBKRN76_workspace53.json
CREATED TASK: #15 "Reply to Ricsi taplista question" (@next, P2)
SKIPPED: inbox/random-article.md → left in inbox (unclear relevance — review manually)
```

### Step 5: Update CAPTAINS_LOG

Append entry:
```markdown
## YYYY-MM-DD — Inbox processed
- X files processed, Y tasks created, Z left for manual review
- Key items: [list significant items]
```

### Step 6: Report

```
INBOX PROCESSED — {project}

Processed: 4/5 files
Tasks created: 2
Left for review: 1 (random-article.md — unclear relevance)

Moves:
  email-from-ricsi.md → correspondence/
  GTM export → audit/data/gtm-exports/
  screenshot → audit/data/screenshots/
  meeting notes → notes/

New tasks:
  #15 Reply to Ricsi taplista question (@next, P2)
  #16 Review GTM workspace 53 changes (@next, P1)
```

## `/inbox all` Mode (Hub Session)

When run from hub root:
1. Scan ALL `clients/*/inbox/` + `internal/inbox/`
2. Process each project's inbox separately
3. Cross-project summary:
```
INBOX SWEEP — 2026-03-24

diego: 57 files (47 processed, 8 tasks created, 2 manual review)
ah-tuning: 2 files (2 processed, 1 task)
internal: 4 files (3 processed, 1 task)
wellis: 1 file (1 processed)
All others: empty

Total: 64 files processed, 10 tasks created, 2 need manual review
```

## Triage Rules

| Age | Action |
|---|---|
| < 7 days | Process normally |
| 7-14 days | Flag as "aging — process soon" |
| 14-30 days | Flag as "stale — still relevant?" |
| > 30 days | Move to `archive/` unless explicitly kept |

## What Does NOT Go in Inbox

- Files that have a clear destination → put them there directly
- TASKS.md edits → edit TASKS.md directly
- CAPTAINS_LOG entries → append directly
- Git files, .env, secrets → NEVER in inbox
