> v1.0 — 2026-04-03

# Lead Tracking Standard

> Every lead gets structured tracking — not just files in a folder.
> A lead that received materials (analysis, pitch, study) needs the same timeline discipline as a client.

---

## Lead Directory Structure

```
internal/leads/{slug}/
├── LEAD_STATUS.md           ← Current status, timeline, next action
├── sent/                    ← What WE sent (chronological, dated)
│   ├── 2026-02-08_7layer-analysis.md
│   └── 2026-02-09_clevel-pitch.md
├── received/                ← What THEY sent back (replies, docs)
├── notes/                   ← Call notes, meeting prep, research
└── data/                    ← Research data, screenshots, exports
```

## LEAD_STATUS.md (required for every lead)

```markdown
# {Lead Name} — Lead Status

> Updated: YYYY-MM-DD

## Status

| Field | Value |
|---|---|
| **Stage** | Discovery / Pitched / Waiting / Negotiating / Won / Lost / Dormant |
| **Status** | @next / @waiting / @someday |
| **Contact** | Name (role) |
| **Since** | YYYY-MM-DD (first contact) |
| **Last action** | What happened + date |
| **Next action** | What to do + deadline |
| **Waiting on** | Who + what + since when |

## Timeline

| Date | Action | Direction | Detail |
|---|---|---|---|
| YYYY-MM-DD | Discovery call | ← → | Notes in notes/ |
| YYYY-MM-DD | 7-Layer Analysis sent | → | sent/YYYY-MM-DD_7layer.md |
| YYYY-MM-DD | Pitch deck sent | → | sent/YYYY-MM-DD_pitch.md |
| YYYY-MM-DD | Reply received | ← | received/YYYY-MM-DD_reply.md |

## Sent Materials

| # | Date | What | File | Response? |
|---|---|---|---|---|
| 1 | YYYY-MM-DD | 7-Layer Analysis | sent/... | Yes/No/Pending |
| 2 | YYYY-MM-DD | C-Level Pitch | sent/... | Yes/No/Pending |

## Value

| Field | Value |
|---|---|
| **Potential** | Morsel / [Diagnostic Service] / Fractional CMO |
| **Est. value** | €X/month or one-time |
| **Probability** | Low / Medium / High |
```

## Stages

| Stage | Meaning | Next action |
|---|---|---|
| **Discovery** | First contact, learning about them | Schedule call, run Gate -0.5 homework |
| **Diagnosed** | Ran /7layer or First Signal, know their problems | Send analysis/pitch |
| **Pitched** | Materials sent, waiting for response | Follow-up on schedule |
| **Waiting** | Ball in their court | Follow-up if no reply by deadline |
| **Negotiating** | They're interested, discussing terms | Send proposal |
| **Won** | Signed → becomes a CLIENT (move to clients/) | /onboard-client |
| **Lost** | Said no or went silent >60 days | Archive or revisit in 6 months |
| **Dormant** | Warm but not now | Check in quarterly |

## When a Lead Becomes a Client

When stage = Won:
1. Run `/onboard-client` → creates `clients/{slug}/`
2. Move diagnostic files to `clients/{slug}/brand/`
3. Move sent materials to `clients/{slug}/archive/pre-engagement/`
4. Update LEAD_STATUS.md: stage = Won, link to client dir
5. Lead dir stays as historical record

## Connection to Hub

- Internal TASKS.md tracks lead follow-ups as tasks
- Each lead task references: `Lead: retail-lead` (ontology edge)
- `/morning-brief` should surface leads with overdue follow-ups
- CAPTAINS_LOG tracks strategic decisions about leads
