> v1.0 — 2026-03-24

# 10 — Tone Discovery & Storage

> When we need to write to someone whose tone isn't on file.
> **Owner:** Whoever is writing | **Tier:** 1 | **Review:** Per new contact

## Purpose
Discover, verify, and permanently store a person's communication tone so every future deliverable matches automatically.

## Trigger
- Writing a deliverable for a person with no Tone in PROJECT_GLOSSARY.md
- New contact added to a project
- First email/message to a lead

## Process

### 1. Search for Evidence (2 min)
Look for how this person communicates:
- `meetings/` — meeting transcripts where they spoke
- `takeover/correspondence/` — emails they sent/received
- `inbox/` — any raw communication from them
- `LEAD_STATUS.md` — notes about communication style

### 2. Extract Tone Signals
From the evidence, identify:

| Signal | What to look for |
|---|---|
| **Register** | Tegező (te) / Magázó (Ön) / Mixed |
| **Language** | HU only / EN only / Mixed / Hunglish |
| **Length** | Short (1-3 sentences) / Medium / Long |
| **Format** | Bullet points / Paragraphs / Voice messages |
| **Vocabulary** | Technical / Practical / Strategic / Casual |
| **Responds to** | Numbers / Stories / Authority / Empathy |
| **Ignores** | What they skip or push back on |
| **Speed** | Replies in hours / days / weeks / never (silence = no) |

### 3. Generate Hypothesis
Write a 3-line tone summary:
```
Register: tegező, casual HU
Style: short, practical, numbers-first, max 5 sentences
Pattern: silence = no, responds to ROI framing, ignores brand talk
```

### 4. Verify with Team
Present the hypothesis:
> "Based on 2 meetings + 3 emails, {name} seems to prefer casual Hungarian, short messages, and ROI framing. Sound right?"

Wait for confirmation or adjustment. Do NOT write in an unverified tone.

### 5. Store Permanently
Add to `PROJECT_GLOSSARY.md` → People & Roles:

```markdown
| {Name} | {Full name} | {Role} | {Verified tone description} | {Notes} |
```

### 6. Done — Never Repeat
Once stored, every future deliverable for this person auto-loads the tone.
The discovery process NEVER runs twice for the same person.

## Escalation

| Condition | Action |
|---|---|
| No evidence at all (new contact, no meetings) | Ask the user directly: "What tone should we use?" |
| Evidence contradicts itself | Present both options: "In meetings they're casual, but their emails are formal. Which is real?" |
| Tone changes over time | Update the glossary entry with a note: "Started formal, now casual (since {date})" |

## KPIs

| Metric | Target |
|---|---|
| Every person in glossary has Tone | 100% |
| Tone verified before first deliverable | 100% |
| No deliverable sent in wrong tone | 0 incidents |
