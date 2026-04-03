> v1.0 — 2026-04-03

# Contact Registry Standard

> Every client project MUST have a `CONTACTS.md` file with ALL people involved.
> This is the single source of truth for names, emails, nicknames, and communication preferences.
> Added: 2026-03-26

## Why

- When writing emails/memos → system auto-loads recipient's name, nickname, preferred language
- When assigning tasks → `Owner:` and `From:` resolve to real people
- When [Task Manager] syncs → `Inform:` maps to correct email
- When /council delivery runs → report-reviewer checks names against contact list
- When meeting notes come in → system identifies speakers by nickname/full name

## File: `CONTACTS.md` (per client project root)

### Format

```markdown
# {Client Name} — Contacts

> Single source of truth for all people involved in this engagement.
> Referenced by: TASKS.md (Owner, From, Inform), CLAUDE.md (Key Contacts), /task-sync, /council delivery

---

## Client Team

| Name | Nickname | Role | Email | Phone | Preferred Channel | Language | Notes |
|------|----------|------|-------|-------|-------------------|----------|-------|
| [Client Contact] | [Client Contact] | US CEO | client-contact@example-ecom.com | — | Email (HU) | HU | Micro-manages, needs proof. Tegező. |
| [Client MD] | [Name] | Marketing Dir HU | — | — | Email / Slack | HU | Day-to-day coord. Tegező. |
| [Client Contact 2] | [Client Contact 2] | Online Sales Mgr US | contact@example-ecom.com | — | Email (EN) | EN | Manages 14 US reps. |

## Agencies & Partners

| Name | Nickname | Company | Role | Email | Phone | Status | Notes |
|------|----------|---------|------|-------|-------|--------|-------|
| [Name] | [Name] | [Agency A] | Google Ads | — | — | Contract ends 03-31 | — |
| [Partner Contact] | [Partner Contact] | [Agency B] | AC Admin | — | — | Active | — |
| [External Specialist] | [Team Member] | BP Digital | SEO (strategic) | — | — | Active | — |

## Arcanian Team

| Name | Nickname | Role | Email | Notes |
|------|----------|------|-------|-------|
| [Owner Name] | [Owner] | Creator/Strategy | owner@example.com | ExampleBrand email: owner@example-ecom.com |
| [Team Member 1] | [Team Member 1] | Research | team1@example.com | No ExampleBrand access |
| [Team Member 2] | [Team Member 2] | Delivery | team2@example.com | No ExampleBrand access |

---

## Communication Rules

- **Tegező/Magázó:** {per person — see Notes column}
- **Default language:** {HU/EN per person}
- **NDA applies:** {yes/no}
- **Who reviews deliverables:** {name — e.g., "[Client Contact 3] reviews everything" for ExampleRetail}
```

## Fields

| Field | Required | Purpose |
|-------|:--------:|---------|
| **Name** | Yes | Full name (in native order — HU: Family Given) |
| **Nickname** | Yes | What we CALL them in tasks, meetings, and conversation. Maps to Owner:/From:/Inform: fields. |
| **Role** | Yes | Their function in this engagement |
| **Email** | Recommended | For [Task Manager] sync (Inform → follower) and correspondence |
| **Phone** | Optional | Only if phone is a primary channel |
| **Preferred Channel** | Recommended | Email / Slack / Phone / WhatsApp — how they prefer to be contacted |
| **Language** | Recommended | HU / EN / both — what language to use with them |
| **Notes** | Optional | Tegező/magázó, review habits, quirks, constraints |

## How the System Uses It

### Task Fields → Contact Resolution

| Task field | System looks up | Action |
|------------|----------------|--------|
| `Owner: [Owner] + [Name]` | CONTACTS.md → email | [Task Manager] assigns to [Owner], adds [Name] as follower |
| `From: [Client Contact] (meeting)` | CONTACTS.md → nickname confirmed | Validates person exists in client contacts |
| `Inform: [Stakeholder], [Team Member 1]` | CONTACTS.md → email | [Task Manager] adds as followers (if collaborators), otherwise in description |
| Deliverable `For: [Client Contact]` | CONTACTS.md → language, tegező/magázó | Auto-sets deliverable tone |
| Meeting transcript speaker "[Client Contact 2]" | CONTACTS.md → [Client Contact 2], Online Sales Mgr | Meeting-sync identifies speaker role |

### Save-Deliverable → Tone Auto-Loading (Step 0)

When generating a deliverable FOR a person:
1. Read CONTACTS.md
2. Find the person by Name or Nickname
3. Load: Language (HU/EN), Tegező/Magázó, preferred channel
4. Apply to deliverable tone

### /council delivery → Name Validation

Report-reviewer checks:
- Names in the deliverable match CONTACTS.md entries
- No misspelled names (common issue: "Gabor" without accent → should be "[Name]")
- PII scanner skips names that are in CONTACTS.md (they're intentional, not leaked)

## Scaffold Integration

`/scaffold-project` creates an empty `CONTACTS.md` from this template:
- Pre-populates Arcanian Team section ([Owner], [Team Member 1], [Team Member 2])
- Leaves Client Team and Agencies sections empty for filling

## Migration from Existing Files

Most projects already have contacts in CLIENT_CONFIG.md or CLAUDE.md:
1. Extract contacts from CLIENT_CONFIG.md → CONTACTS.md
2. Add missing fields (nickname, email, language, preferred channel)
3. Keep CLIENT_CONFIG.md for technical config (domains, tracking IDs)
4. Keep CLAUDE.md Key Contacts section as a SHORT reference (3-5 names max)
5. CONTACTS.md becomes the FULL registry
