> v1.0 — 2026-04-03

# File Intake Rule — Auto-Route External Files

> When a user references a file from outside the project (Downloads, Desktop, Documents, inbox/),
> the system MUST route it to the correct location, rename it, add ontology, and extract tasks.
> This is an ALWAYS-ON behavior, not a slash command.

## Trigger

When the user:
- Pastes a file path from `~/Downloads/`, `~/Desktop/`, `~/Documents/`, or any location outside the project
- Says "this file", "look at this", "I got this from...", "here's the..." with a file reference
- Drops a file into `inbox/` and asks about it
- References an attachment from a meeting, email, or Slack

## Process

### Step 1: Identify the File

Read the file. Determine:
- **What is it?** (meeting notes, email, data export, screenshot, PDF, spreadsheet, proposal, contract, GTM export, etc.)
- **Which client?** (from content, filename, or ask)
- **Which domain?** (if multi-domain client)
- **Who sent it / where from?** (the `From:` for any extracted tasks)

### Step 2: Determine Destination

| File Type | Destination | Naming Convention |
|-----------|-------------|-------------------|
| Meeting notes/transcript | `clients/{slug}/meetings/` | `YYYY-MM-DD_{meeting-title}.md` |
| Meeting recording (raw) | `clients/{slug}/meetings/raw/` | Original filename |
| Email / message | `clients/{slug}/takeover/correspondence/` | `{sender}-{topic}-{date}.md` |
| GTM container export | `clients/{slug}/data/gtm-exports/` | `GTM-{ID}_workspace{N}.json` |
| GA4 / analytics export | `clients/{slug}/data/` | `{source}_{date}_{description}.csv` |
| Screenshot | `clients/{slug}/audit/evidence/` or `assets/` | `YYYY-MM-DD_{description}.png` |
| PDF report | `clients/{slug}/presentations/` | `YYYY-MM-DD_{title}.pdf` |
| Spreadsheet (data) | `clients/{slug}/data/` | `{description}_{date}.xlsx` |
| Spreadsheet (planning) | `clients/{slug}/docs/` or relevant subdir | `{CLIENT}_{TOPIC}.xlsx` |
| Proposal / contract | `clients/{slug}/proposals/` or `takeover/` | `{client}-{type}-v{N}.md` |
| Article / reference | `clients/{slug}/archive/` (if not actionable) | `YYYY-MM-DD_{title}.md` |
| Client-provided data (UPD) | `clients/{slug}/upd/` | Original filename + README note |
| Internal doc | `internal/{relevant_dir}/` | Per internal conventions |
| Unknown | `clients/{slug}/inbox/` (for manual triage) | Original filename |

### Step 3: Move & Rename

```bash
# Move from source to destination
mv "{source_path}" "{destination_path}"

# If the source is in ~/Downloads — it was likely temporary
# If the source is in inbox/ — it was staged for processing
```

### Step 4: Add Ontology Header (for .md files)

If the file is markdown or can be converted, add/update the header:

```markdown
> v1.0 — {date}
> Type: {meeting-notes|email|report|data-export|reference}
> Client: {slug}
> Domain: {domain if applicable}
> From: {who sent/created it}
> Original: {original filename if renamed}

---
## Ontology
- Client: {slug}
- Layer: {which layers this touches}
- Meeting: {if from a meeting}
- Task: {if related to a task}
```

### Step 5: Extract Action Items → TASKS.md

Scan the file for action items:
- Explicit: "TODO", "action", "kell", "szükséges", "elküldeni", "megcsinálni", deadlines
- Commitments: "I'll send", "we agreed to", "by Friday"
- Questions needing answers: "can you check", "please confirm"

For each action item:
1. Create task in TASKS.md (full format per TASK_FORMAT_STANDARD.md)
2. `From:` = source of the file (person who sent it, meeting where it was discussed)
3. `Inform:` = relevant stakeholders
4. `Domain:` = from the file's context
5. Auto-sync to [Task Manager] (per `/tasks create` auto-sync)
6. Link task back to the file: `Source: {destination_path}`

### Step 6: Log to CAPTAINS_LOG

Append to CAPTAINS_LOG.md:
```
### {date} — File Intake
- Received: {original filename} from {source}
- Moved to: {destination_path}
- Tasks extracted: {count} (#{N1}, #{N2})
- Client: {slug} | Domain: {domain}
```

### Step 7: Confirm to User

```
✓ Filed: {filename}
  → {destination_path}
  Type: {type} | Client: {slug} | Domain: {domain}
  Tasks extracted: {count}
  #{N1} {task title} — {priority}
  #{N2} {task title} — {priority}
  Logged to CAPTAINS_LOG.md
```

## Examples

**User:** "look at this file ~/Downloads/examplebrand-gabor-meeting-2026-03-25.pdf"
```
✓ Filed: examplebrand-gabor-meeting-2026-03-25.pdf
  → clients/example-ecom/presentations/2026-03-25_gabor-meeting.pdf
  Type: meeting-notes (PDF) | Client: examplebrand | Domain: all
  Tasks extracted: 0 (PDF — manual review needed)
  Logged to CAPTAINS_LOG.md
```

**User:** "I got this GTM export" + pastes path to ~/Downloads/GTM-XXXXX_workspace12.json
```
✓ Filed: GTM-XXXXX_workspace12.json
  → clients/example-ecom/data/gtm-exports/GTM-XXXXX_workspace12.json
  Type: GTM export | Client: examplebrand | Domain: example-d2c.com
  Updated GTM_CHANGELOG.md
  Tasks extracted: 0
  Logged to CAPTAINS_LOG.md
```

**User:** "[Team Member] sent this Shopify report" + path to ~/Documents/shopify-export-march.csv
```
✓ Filed: shopify-export-march.csv
  → clients/example-ecom/data/shopify-export-2026-03.csv
  Type: data export | Client: examplebrand | Domain: example-d2c.com
  Tasks extracted: 1
    #193 Review Shopify March export — P2 | Owner: [Owner]
    From: [Team Member] (email) | Inform: [Name]
  Logged to CAPTAINS_LOG.md
```

## Edge Cases

- **File already exists at destination:** Rename with `-v2`, `-v3` suffix. Never overwrite.
- **Can't determine client:** Ask: "Which client is this for?"
- **Can't determine type:** Move to `inbox/` and flag: "Filed to inbox — needs manual classification."
- **Large binary (>50MB):** Don't move, just note the path. Suggest: "This file is large. Keep it at {path} and add a reference in the project?"
- **Sensitive/NDA file:** Check DATA_RULES.md. If PII detected, warn before moving.
