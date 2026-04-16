---
scope: shared
argument-hint: source file or URL
---

# Skill: Extract Contacts (`/extract-contacts`)

## Purpose

Extracts all people from a correspondence, email, meeting transcript, or any text input and ensures they exist in the client's `CONTACTS.md`. New contacts are added, existing contacts are updated if new information is found.

**Core principle:** Every person who appears in project communication MUST be in the contact registry. A person not in CONTACTS.md is invisible to the task system, deliverable routing, and ontology.

## Trigger

Use when:
- User pastes or references an email, correspondence, or meeting transcript
- User says `/extract-contacts`
- User says "add contacts", "extract contacts", "update contacts from this"
- Part of `/inbox-process` when processing correspondence files

## Input

| Input | Required | Source |
|---|---|---|
| Text / email / file | Yes | User paste, file path, or conversation context |
| Client slug | Yes | Auto-detect from working directory or ask |

## Execution Steps

### Step 1: Identify all people

Scan the input for every person mentioned. Extract:

| Field | Source hints |
|---|---|
| **Full name** | Signature, From/To/CC headers, @mentions, body text |
| **Email** | Headers, signatures, mailto: links |
| **Phone** | Signatures, body text |
| **Role / Title** | Signatures, context ("kollégám", "vezető", "manager") |
| **Company** | Signature, email domain, context |
| **Language** | Email language, name patterns (HU/EN/RO/DE) |

### Step 2: Load existing CONTACTS.md

Read `CONTACTS.md` from the client project root. Build a lookup by:
- Email (primary key)
- Full name (fuzzy — handle "Nagy Róbert" vs "Róbert Nagy" ordering)
- Nickname

### Step 3: Classify each person

For each extracted person, classify:

| Status | Action |
|---|---|
| **EXISTS — no new info** | Skip |
| **EXISTS — new info found** | Update (add email, phone, role, or notes) |
| **NEW — client team** | Add to `## Client Team` table |
| **NEW — vendor/agency** | Add to appropriate `## Agencies & Partners` subsection (create if needed) |
| **NEW — platform contact** | Add to `## Platform / Vendor Contacts` |
| **ALREADY KNOWN — different context** | Update Notes with new context (e.g., "CC a Daktela projektben") |

### Step 4: Determine placement

For new vendor/agency contacts, check if a subsection already exists:
- Match by company name or email domain
- If exists → add to that subsection
- If new company → create new subsection with header: `### {Company} — {Service} — {Status}`
- Status: ONBOARDING / ACTIVE / STABLE / TRANSITIONING / PROPOSAL / TERMINATED

### Step 5: Fill mandatory fields

Every contact MUST have:
- `Active Since` — use email date or `YYYY-MM` of first appearance
- `Status` — `Active` (default for new), `Active (new)` if just appeared
- `Language` — infer from email language + name

Unknown fields → `—` (never guess emails or phones)

### Step 6: Apply changes

1. Edit `CONTACTS.md` — add new rows, update existing
2. Update `updated:` date in frontmatter
3. Report what changed:

```
## Contact extraction results
- **Source:** {file or "pasted email"}
- **People found:** {N}
- **New contacts added:** {list with placement}
- **Existing contacts updated:** {list with what changed}
- **Skipped (already complete):** {list}
```

### Step 7: Cross-reference

Flag if any extracted person:
- Is referenced in `TASKS.md` (Owner/From/Inform) but wasn't in CONTACTS.md → **data integrity fix**
- Has a departed status but appears in new correspondence → **verify: returned or stale reference?**
- Shares an email domain with an existing agency/vendor → **suggest grouping**

## Rules

1. **Never guess emails.** If not in the source text, use `—`.
2. **Hungarian name order:** "Gesztesi Gábor" = surname first. Store as-is (Hungarian order for HU contacts).
3. **Dedup by email first, then by name.** "Nagy Róbert" and "Róbert Nagy" are the same person.
4. **Preserve existing data.** Never overwrite a filled field with `—`. Only add or correct.
5. **Temporal columns are mandatory.** Every new contact gets `Active Since` and `Status`.
6. **Respect classification.** CONTACTS.md is CONFIDENTIAL — never expose in client-facing output.

## Integration

- **File Intake:** when `/inbox-process` routes correspondence → auto-run contact extraction
- **Auto-Save Deliverables:** before writing, check CONTACTS.md for recipient tone/language
- **Task System:** Owner/From/Inform fields resolve against CONTACTS.md nicknames
- **Ontology:** Person nodes in the knowledge graph link to CONTACTS.md entries

## Examples

**Input:** Email with `From: john.smith@newagency.com, CC: jane@wellis.hu`
**Output:**
- John Smith → NEW → `### NewAgency — TBD — ACTIVE` (new vendor section)
- Jane → EXISTS (jane@wellis.hu already in Client Team) → skip

**Input:** Meeting transcript mentioning "Kata mondta, hogy..." + no email
**Output:**
- Kata → NEW → Client Team, email: `—`, Notes: "Mentioned in meeting {date}, role TBD"

### Example 1: Email thread with 2 contacts

**Input:**
```
From: Anna Kovács <anna.k@example-brand.com>
To: team@example.com
CC: Tamás Molnár <t.molnar@example-agency.com>

Hi team,

Please find attached the Q1 report. Our developer Béla (bela@example-brand.com) 
will handle the GTM changes next week.

Best,
Anna Kovács
Head of Marketing
Example Brand Kft.
+36 30 123 4567
```

**Output (3 rows added to CONTACTS.md):**

| Name | Nickname | Email | Phone | Role | Company | Language | Active Since | Status |
|---|---|---|---|---|---|---|---|---|
| Kovács Anna | Anna | anna.k@example-brand.com | +36 30 123 4567 | Head of Marketing | Example Brand | HU | 2026-04 | Active |
| Molnár Tamás | Tamás | t.molnar@example-agency.com | — | Agency contact | Example Agency | HU | 2026-04 | Active |
| Béla | Béla | bela@example-brand.com | — | Developer [INFERRED from context] | Example Brand | HU | 2026-04 | Active |

### Example 2: Meeting transcript with unknown person

**Input:**
```
"...and then Gábor mentioned they switched to Shopify Plus last month.
He's handling the migration."
```

**Output (1 row added):**

| Name | Nickname | Email | Phone | Role | Company | Language | Active Since | Status |
|---|---|---|---|---|---|---|---|---|
| Gábor | Gábor | — | — | Migration lead [INFERRED] | — | HU | 2026-04 | Active |

Note: `[INFERRED]` tag on role — verify at next meeting.
