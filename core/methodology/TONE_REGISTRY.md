> v1.0 — 2026-03-24

# Tone Registry — How We Speak to Each Person

> Every person we communicate with has a specific tone. The system MUST match tone to recipient.
> This prevents: formal email to casual client, casual email to corporate contact, wrong language register.

---

## How Tone Is Stored

### Per-Client: in PROJECT_GLOSSARY.md → People & Roles section
Add a `Tone` column:

```markdown
| Name | Role | Tone | Notes |
|---|---|---|---|
| [Name] | Owner | Casual HU, practical, no marketing jargon, numbers-first | "persze, persze" — keep it short, action-oriented |
| [Name] | Marketing Director | Professional HU, strategic, can handle frameworks | Uses "Ön" sometimes in formal settings |
| [Client Contact] | US CEO | Direct EN/HU mix, fast, wants bottom-line | Micromanages — give specifics, not vague plans |
```

### Per-Lead: in LEAD_STATUS.md → add Tone field
```markdown
| **Tone** | Formal HU, first email was "Önözős", keep it that way |
```

### Per-Platform: in content skills
| Platform | Default tone |
|---|---|
| LinkedIn post | Professional but personal. Honest practitioner. Show don't tell. |
| LinkedIn comment | [Communication Framework] pacing: pace → pace → lead. Match the post's energy first. |
| Substack | Long-form, analytical, first-person. "I noticed..." |
| Client email | Match the client's tone register (check glossary) |
| Internal ([Team Member 2]/[Team Member 1]) | Casual HU, collaborative, "mit gondoltok?" |

## Per-Person Tone Card

For key contacts, create a tone card in the glossary:

```markdown
### [Name] (ExampleLocal)
- **Register:** Tegező (informal "te")
- **Language:** Hungarian only
- **Style:** Short sentences. Practical. Numbers > concepts. "Mennyit hoz?" > "Mi a stratégia?"
- **Avoid:** Brand terminology, marketing jargon, long explanations
- **Use:** Concrete examples, ROI framing, "ezt kell csinálni" not "érdemes lenne megfontolni"
- **Email length:** Max 5 sentences. Bullet points > paragraphs.
- **Response pattern:** Won't say no directly. Silence = no. Follow up in 5 days.
```

## Connection to Auto-Save Deliverables

When the `/save-deliverable` behavior triggers:
1. Identify the recipient
2. Look up their tone in PROJECT_GLOSSARY.md or LEAD_STATUS.md
3. If tone is defined → **verify the deliverable matches** before saving
4. If tone mismatch detected → warn: "This email uses formal register but [Name] expects casual"

## Connection to LinkedIn

For LinkedIn posts/comments, the tone comes from:
- `core/brand/arcanian/VOICE.md` — Arcanian's voice
- `` skill — already has [Communication Framework] pacing rules
- Content Calendar — Pattern Drop = diagnostic tone, Quality Bomb = personal tone

## The Rule

**Never generate a deliverable without checking the recipient's tone.**
If tone is not defined for a new contact → ask: "What tone should we use with {name}?"
Then add to the glossary.
