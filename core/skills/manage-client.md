# Skill: Manage Client Projects

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.
Helps manage client projects - onboarding new clients, tracking progress, switching between clients, and maintaining the client dashboard.

## Trigger
Use this skill when:
- Starting work with a new client
- Switching to work on a specific client
- Reviewing client portfolio
- Updating client status or progress
- Planning weekly client work

---

## Commands

### `/client new [name]`
Create a new client project

**Process:**
1. Generate client ID from name
2. Copy template folder
3. Fill in CLIENT.md basics
4. Add to DASHBOARD.md

**Example:**
```
/client new Acme Coaching
→ Creates: clients/acme-coaching/
→ Updates: DASHBOARD.md
```

---

### `/client [id]`
Switch to work on a specific client

**Process:**
1. Load client context from CLIENT.md
2. Show current status and progress
3. Identify recommended next actions
4. Display relevant [diagnostic profile] summary

**Example:**
```
/client acme-coaching
→ Shows: Client overview, progress, next steps
```

---

### `/client list`
Show all clients with status

**Output:**
```
ACTIVE CLIENTS:
• acme-coaching - Scaling -  in progress
• smith-fitness - Pre-launch - /validate-idea complete

ON HOLD:
• jones-consulting - since 2024-01-15

COMPLETED:
• (none)
```

---

### `/client dashboard`
Show weekly planning view

**Output:**
- This week's priorities per client
- Upcoming sessions
- Skill progress overview
- Capacity check

---

### `/client update [id]`
Update client status or progress

**Options:**
- Status change (Active/On Hold/Completed)
- Skill progress update
- Add session log entry
- Update focus areas

---

## Client Context Loading

When switching to a client, load and display:

```
═══════════════════════════════════════════════════════════════
                    CLIENT CONTEXT
═══════════════════════════════════════════════════════════════

CLIENT: [Name]
INDUSTRY: [Industry]
STAGE: [Stage]
STATUS: [Status]

───────────────────────────────────────────────────────────────
                    CURRENT STATE
───────────────────────────────────────────────────────────────

BIGGEST CHALLENGE:
> [From CLIENT.md]

KEY BELIEFS IDENTIFIED:
• [Belief 1]
• [Belief 2]
• [Belief 3]

PRIMARY PATTERN: [Pattern]

───────────────────────────────────────────────────────────────
                    PROGRESS
───────────────────────────────────────────────────────────────

MINDSET:
□ : [Status]
□ analyze-copy: [Status]
□ map-results: [Status]
□ : [Status]

STRATEGY:
□ validate-idea: [Status]
□ craft-offer: [Status]
□ build-brand: [Status]

GTM:
□ analyze-gtm: [Status]
□ plan-gtm: [Status]

───────────────────────────────────────────────────────────────
                    THIS WEEK
───────────────────────────────────────────────────────────────

FOCUS:
• [From CLIENT.md]

NEXT SESSION: [Date/Time if known]

───────────────────────────────────────────────────────────────
                    RECOMMENDED NEXT ACTION
───────────────────────────────────────────────────────────────

Based on progress, recommend: [Next skill to run]
Because: [Reasoning]

═══════════════════════════════════════════════════════════════
```

---

## New Client Onboarding Checklist

When creating new client:

```
□ Create folder from template
□ Fill CLIENT.md:
  □ Contact information
  □ Business overview
  □ Current challenges
  □ Goals
□ Collect initial assets:
  □ Website URL / copy
  □ Social media links
  □ Any existing marketing materials
□ Add to DASHBOARD.md
□ Schedule first session
□ Determine starting point:
  □ Have marketing copy? → /analyze-copy first
  □ Have business data? → /map-results first
  □ Neither? →  from stated challenge
```

---

## Client Session Workflow

Before session:
1. Load client context (`/client [id]`)
2. Review last session notes
3. Check where we left off
4. Prepare relevant skill

During session:
1. Run appropriate skill
2. Document in skill output file
3. Note key insights

After session:
1. Update skill status in CLIENT.md
2. Add to session log
3. Define next steps
4. Update DASHBOARD.md if needed

---

## Portfolio Review (Weekly)

Every week:

1. **Dashboard Review**
   - Update all client statuses
   - Check for stale clients
   - Verify upcoming sessions

2. **Capacity Check**
   - Count active clients
   - Identify overload
   - Move to On Hold if needed

3. **Priority Setting**
   - What's most urgent?
   - What's most important?
   - What can wait?

4. **Week Planning**
   - Assign clients to days
   - Set specific goals per client
   - Block time for deep work

---

## Status Definitions

| Status | Meaning | Action |
|--------|---------|--------|
| **Active** | Currently engaged | Regular sessions |
| **On Hold** | Paused temporarily | Check monthly |
| **Completed** | Engagement done | Request testimonial |

---

## Skill Status Definitions

| Status | Meaning |
|--------|---------|
| **Not Started** | Haven't run this skill yet |
| **In Progress** | Currently working on this |
| **Complete** | Finished this skill |
| **Needs Update** | Circumstances changed, re-run |

---

## Integration with Other Skills

```
/client new → Creates project
       ↓
/client [id] → Load context
       ↓
Run any skill → Output saved to client folder
       ↓
/client update → Track progress
       ↓
/client dashboard → See portfolio
```

---

## Notes

- Always load client context before working
- Keep CLIENT.md as the source of truth
- Update progress immediately after sessions
- Use DASHBOARD.md for portfolio view
- Archive completed clients quarterly
