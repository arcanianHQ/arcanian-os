---
scope: shared
argument-hint: file path to save
---

# Skill: Auto-Save Deliverable

## Purpose

When Claude generates a deliverable (memo, email, LinkedIn post, answer, letter, proposal, brief, report), it MUST auto-save as .md, place in the correct location, add ontology edges, and open in Typora.

## IMPORTANT — This is NOT a slash command

This is a **BEHAVIOR RULE** embedded in CLAUDE.md. Claude should do this AUTOMATICALLY whenever it generates deliverable content. No `/save-deliverable` needed — it's always-on.

## Trigger (auto-detect)

When the user asks for ANY of these:
- "write an email to..."
- "draft a memo..."
- "LinkedIn post about..."
- "answer to..."
- "reply to..."
- "letter to..."
- "proposal for..."
- "brief for..."
- "summary of..."
- "report on..."
- "ajánlat..."
- "levél..."
- "válasz..."
- "összefoglaló..."

AND when Claude PRODUCES any of these (even without explicit save request):
- Data analysis with tables/findings (Databox, GA4, Ads, SEO, any MCP query)
- Diagnostic output (/7layer, /health-check, constraint maps, repair plans)
- Audit findings or measurement reports
- Channel/funnel/attribution analysis
- Any output > 50 lines with structured findings

**Rule: if it took > 2 minutes of MCP queries to build, it MUST be saved. Never just print to conversation.**

## Process

### Step 0: Load recipient tone (BEFORE writing)

Before generating ANY content:
1. Identify the recipient (person, platform, or audience)
2. Read `CONTACTS.md` → find recipient by Name or Nickname → load Language, Tegező/Magázó, preferred channel
3. Look up tone in:
   - `PROJECT_GLOSSARY.md` → People & Roles → Tone column (for client contacts)
   - `LEAD_STATUS.md` → Tone field (for leads)
   - `core/brand/arcanian/VOICE.md` (for Arcanian's own voice on LinkedIn/Substack)
   - `core/methodology/TONE_REGISTRY.md` → Per-Platform defaults
3. If tone found → MATCH IT throughout the deliverable
4. If tone NOT found → run **Tone Discovery Process:**

#### Tone Discovery Process (when no tone on file)

**Step A: Search meetings for the person**
```
Search clients/{client}/meetings/ for files mentioning {name}
Search internal/meetings/ for files mentioning {name}
```
From meeting transcripts, extract:
- How they speak (formal/informal, long/short sentences, Hungarian/English)
- What language register they use (tegező/magázó/Önöző)
- Topics they respond to (numbers, stories, practical, strategic)
- What they ignore or push back on
- Email/message style if correspondence exists in `takeover/correspondence/`

**Step B: Generate a tone hypothesis**
```
Based on 3 meetings with {name}, their communication style appears to be:
- Register: tegező
- Language: Hungarian
- Style: short, practical, avoids abstractions
- Responds to: ROI numbers, concrete next steps
- Ignores: strategic frameworks, brand language
- Email preference: max 3-4 sentences, bullet points

Does this match your experience? Anything to adjust?
```

**Step C: Wait for verification**
Do NOT proceed with the deliverable until the user confirms or adjusts the tone.

**Step D: Save to glossary**
Once confirmed, add to `PROJECT_GLOSSARY.md` → People & Roles → Tone column.
If no glossary exists, create one from template.

**Step E: Then generate the deliverable**
Only now write the content, matching the verified tone.

**This is a stored process — once tone is discovered + verified + saved, it's permanent. Never discover the same person's tone twice.**

### Step 0b: Load prior context on the TOPIC (BEFORE writing)

Before generating ANY content, traverse the ontology by three axes:

#### Axis 1: By TOPIC
Search for what we already know about the subject matter:
1. **Prior correspondence:** `takeover/correspondence/` and `takeover/emails/` for prior exchanges on this topic
2. **Related tasks:** `TASKS.md` for tasks referencing the topic, related systems
3. **Audit findings:** `audit/` for findings (FND-xxx) related to the topic (e.g., AC audit for AC questions, GTM audit for tracking)
4. **Meeting notes:** `meetings/` for transcripts mentioning the topic
5. **Process docs:** `processes/` for SOPs or plans related to the topic
6. **Decision log:** `CAPTAINS_LOG.md` for prior decisions on this topic

#### Axis 2: By PERSON
Search for what we know about the recipient and anyone mentioned:
1. **Contact record:** `CONTACTS.md` → resolve full name, role, what they own, preferred channel
2. **Prior correspondence:** search `correspondence/` by name/nickname — what have we discussed with them before?
3. **Task involvement:** `TASKS.md` where they are Owner, From, Waiting on, or Inform
4. **Meeting participation:** `meetings/` where they spoke or were referenced
5. **Access/responsibility:** `ACCESS_REGISTRY.md` or system access docs — what do they control?

#### Axis 3: By DOMAIN (multi-domain clients)
If the topic relates to a specific domain:
1. **Channel map:** `DOMAIN_CHANNEL_MAP.md` → which tools/accounts/properties connect to this domain
2. **Domain-scoped tasks:** filter `TASKS.md` by `Domain:` field
3. **Domain-specific findings:** audit findings tagged to this domain
4. **Domain-specific processes:** domain-referenced SOPs or plans

#### What to extract:
- What questions have we already asked (and answered)?
- What did we learn from prior correspondence/meetings?
- What findings/recommendations exist?
- What tasks are already created for this?
- What decisions were already made?
- What does this person own/control?
- What domain-specific context applies?

**Why:** The system has extensive per-client knowledge (audit files, meeting transcripts, correspondence history, task ontology). Writing an email asking questions we already have answers to wastes credibility and the client's time. "Not loaded ≠ not known."

**Rule: never write a deliverable about a topic without first traversing the ontology by topic, person, and domain.**

### Step 1: Generate the content

**For decision-oriented deliverables** (recommendations, reports, memos, briefs, proposals):
Use the BLUF+OODA format from `core/templates/BLUF_OODA_TEMPLATE.md`.
Structure: BLUF → OBSERVE → ORIENT → DECIDE → ACT → RISK → SUCCESS METRICS.

**For other deliverables** (emails, LinkedIn posts, answers, letters):
Use standard format appropriate to the type.

Write the deliverable matching the recipient's tone. Include at the top:
```markdown
> v1.0 — {today}
> Type: {memo|email|linkedin-post|answer|letter|proposal|brief|report|summary}
> For: {recipient or audience}
> Client: {client if applicable}
> Author: {who requested it}
```

### Step 2: Determine save location

| Type | Location | Naming |
|---|---|---|
| **Email** (client) | `clients/{client}/takeover/correspondence/` | `{recipient}-{topic}-draft.md` |
| **Email** (internal) | `internal/correspondence/` | `{recipient}-{topic}-draft.md` |
| **Email** (lead) | `internal/leads/{lead}/sent/` | `{date}_{topic}.md` |
| **LinkedIn post** | `internal/content/linkedin/posts/` | `LINKEDIN_POST_NN_{TITLE}.md` |
| **LinkedIn comment** | `internal/content/linkedin/comments/` | `LINKEDIN_COMMENT_NN_{DESC}.md` |
| **Memo** (client) | `clients/{client}/` | `{date}_memo_{topic}.md` |
| **Memo** (internal) | `internal/` | `{date}_memo_{topic}.md` |
| **Proposal / Ajánlat** | `clients/{client}/proposals/` or `internal/leads/{lead}/sent/` | `{client}-arajanlat-v{N}.md` |
| **Brief** | `clients/{client}/` or relevant subdir | `{date}_brief_{topic}.md` |
| **Report** | `clients/{client}/reports/` | `{date}_report_{topic}.md` |
| **Summary** | Same dir as source material | `{date}_summary_{topic}.md` |
| **Answer / Reply** | `clients/{client}/takeover/correspondence/` | `{recipient}-{topic}-draft.md` |
| **Data Analysis** | `clients/{client}/docs/` | `{CLIENT}_ANALYSIS_{TOPIC}_{PERIOD}.md` |
| **Data Analysis** (hub) | `internal/analyses/` | `ANALYSIS_{TOPIC}_{DATE}.md` |
| **Diagnostic** | `clients/{client}/docs/` | `{CLIENT}_{SKILL}_{DATE}.md` |
| **Audit / Measurement** | `clients/{client}/audit/` | `{CLIENT}_AUDIT_{TOPIC}_{DATE}.md` |

### Step 3: Add ontology edges

At the bottom of every deliverable:
```markdown
---
## Ontology
- Client: {client slug}
- Layer: {which layers this touches}
- Meeting: {if generated from a meeting}
- Lead: {if related to a lead}
- Task: {if fulfilling a specific task}
- input_context: {what triggered this deliverable — signal type / brief / enrichment stage / meeting / task / freeform request}
- quality_rating: [1-5, added post-delivery by author]
- engagement: [platform metrics populated after publish — impressions: / opens: / clicks: / comments:]
```

**input_context examples:**
- `signal: P0 Pete Caputa LinkedIn post on measurement`
- `brief: First Signal pitch for {client}, enrichment stage Diagnosed`
- `meeting: 2026-04-08 Wellis weekly sync`
- `task: #53 Fix GA4 consent mode`
- `freeform: user request "write email about..."`

**quality_rating:** Added after delivery when the author (or recipient) evaluates the output. 1 = missed the mark, 3 = adequate, 5 = exceptional. Used by `/output-review` to identify which input contexts produce the best deliverables.

**engagement:** Populated after publication for public content (LinkedIn posts, newsletters, emails). Used by `/output-review` for feedback loop analysis.

### Step 4: Save the file

Use the Write tool to save to the determined location.

### Step 5: Open file

```bash
core/scripts/ops/open-file.sh "{saved_file_path}"
```

### Step 6: Confirm + Ask About Finalization

```
✓ Saved: {path}
✓ Opened in Typora
Type: {type} | Client: {client} | Version: v1.0

Is this a draft or final version?
- Draft → saved as {name}-draft.md (edit in Typora, come back when ready)
- Final / Send → I'll extract tasks, rename to -sent.md, update ontology
```

### Step 7: If Finalized — Auto-Extract + Auto-Sync Tasks

When user confirms "this is final" / "ok send it" / "accepted":
1. Scan deliverable for action items (commitments, promises, deadlines, verbs: "will", "should", "needs to", "by [date]")
2. Auto-add ALL extracted tasks to client TASKS.md with full ontology (Layer, Meeting, Email, Lead edges)
   - Auto-populate `From:` from deliverable type + date
   - Auto-populate `Inform:` from deliverable's `For:` header
3. Auto-sync each task to Todoist (single-task auto-push per task-sync.md)
4. Add `## Tasks Extracted` section to the deliverable
5. Rename: `{name}-draft.md` → `{name}-sent.md`
6. Update ontology backlinks
7. Bump version: `v1.0 → v1.1 — finalized, {N} tasks extracted and synced`
8. Show ONE summary: "{N} tasks extracted and synced to Todoist. Review in TASKS.md if needed."

See: `core/sops/arcanian/11-memo-to-tasks.md` for full process.

### Step 7b: Quality Rating Prompt

After finalization (or 24h after delivery for async), prompt:

```
How did this deliverable perform? Rate 1-5:
  1 = missed the mark / needed major rework
  2 = below expectations / significant edits needed
  3 = adequate / minor tweaks
  4 = good / used as-is or near-as-is
  5 = exceptional / exceeded expectations

Rating: [1-5]
```

Update the `quality_rating:` field in the deliverable's ontology block.

For LinkedIn posts and emails, also prompt for engagement data when available:
```
Engagement update (leave blank if not yet available):
  Impressions: ___  Likes: ___  Comments: ___  Clicks: ___
```

Update the `engagement:` field. This data feeds the monthly `/output-review` analysis.

## Glossary Check

Before saving, check if the project has a `PROJECT_GLOSSARY.md`. If it does, verify the deliverable doesn't use banned terms. Warn if it does.

## Examples

**User:** "write an email to Ricsi about the tápválasztó spec"
```
→ Saves to: clients/mancsbazis/takeover/correspondence/ricsi-tapvalaszto-spec-draft.md
→ Opens in Typora
→ Ontology: Client: mancsbazis, Layer: L3, Task: (if linked)
→ Glossary check: uses "tápválasztó" ✓ (not "Product Recommender")
```

**User:** "draft a LinkedIn post about the 7-layer framework"
```
→ Saves to: internal/content/linkedin/posts/LINKEDIN_POST_NN_7LAYER.md
→ Opens in Typora
→ Ontology: Client: internal, Layer: L0-L7
→ Checks: Bridge Rule (must land on marketing diagnosis)
```

**User:** "write a memo about the Euronics follow-up plan"
```
→ Saves to: internal/leads/euronics/sent/{date}_followup-plan.md
→ Opens in Typora
→ Ontology: Lead: euronics, Layer: L6
→ Updates LEAD_STATUS.md timeline
```
