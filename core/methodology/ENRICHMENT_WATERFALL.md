---
scope: shared
---

> v1.0 --- 2026-04-10

# Enrichment Waterfall

> Don't pitch what you haven't diagnosed. Don't diagnose what you haven't scanned.
> Every lead stage has a minimum intelligence requirement. Missing enrichment = ask questions, don't guess.

Inspired by Revenue Architects' GTM Engineering pattern (enrichment waterfall), adapted for Arcanian's consultative sales process where depth of diagnosis IS the product.

---

## Stage-Gated Enrichment

Each lead stage in `LEAD_TRACKING_STANDARD.md` requires specific intelligence before the lead can advance.

| Lead Stage | Required Intelligence | Primary Source | Gate |
|---|---|---|---|
| **Signal** (pre-Discovery) | Company name, contact title, signal type, initial relevance check | LinkedIn / web / SIGNAL_DETECTION_RULE | Can enter Discovery |
| **Discovery** | Website scan, tracking inventory, social presence, tech stack | client-explorer Steps 1-3 | Can schedule call |
| **Diagnosed** | /7layer or First Signal, constraint map, primary hypothesis | diagnostic pipeline | Can send materials |
| **Pitched** | Competitor quick-scan, pricing context, value calculation, ECP match | client-explorer Steps 4-5, market research | Can negotiate |
| **Negotiating** | Full CLIENT_INTELLIGENCE_PROFILE (7 files minimum) | brand/ scaffold | Can close |

---

## Per-Stage Enrichment Checklists

### Stage 0: Signal → Discovery

**Minimum to proceed:** Know who they are and why we noticed them.

- [ ] Company name + website URL
- [ ] Contact name + title + LinkedIn profile
- [ ] Signal that triggered attention (what, when, where)
- [ ] Initial relevance: do they match our ECP? (Yes / Maybe / Stretch)
- [ ] Quick check: do we already have a lead file? (`internal/leads/`)

**Where to document:** Create `internal/leads/{slug}/LEAD_STATUS.md` with Stage = Discovery.

---

### Stage 1: Discovery → Diagnosed

**Minimum to proceed:** Understand their digital presence and identify where measurement breaks.

- [ ] Website technical scan (CMS, speed, mobile, SSL)
- [ ] Tracking script inventory (GA4, GTM, pixels, consent)
- [ ] Social media presence scan (which platforms, activity level, follower quality)
- [ ] Initial hypothesis: what's their likely primary constraint? (L0-L7)
- [ ] Contact enrichment: who else is on the team? Decision maker identified?

**Source:** `client-explorer` agent Steps 1-3, or manual research.
**Where to document:** `internal/leads/{slug}/notes/discovery-scan.md`
**Time budget:** 30-60 minutes max. This is a scan, not an audit.

---

### Stage 2: Diagnosed → Pitched

**Minimum to proceed:** Have a diagnostic perspective worth sharing.

- [ ] /7layer diagnosis (Mode 1 minimum — First Signal) OR full Mode 2 if data available
- [ ] Primary constraint identified (L0-L7) with confidence rating
- [ ] At least one actionable finding (FND) to demonstrate value
- [ ] Materials prepared: analysis summary, Prism/Morsel pitch, or custom diagnostic
- [ ] **Lead score ≥ 15** (per `SIGNAL_DECAY_MODEL.md` stage gate)

**Source:** `/pipeline diagnostic` or `/7layer` standalone.
**Where to document:** `internal/leads/{slug}/notes/` + `internal/leads/{slug}/sent/`
**Gate logic:** If lead_score < 15 → do not send materials. Instead, create more signals (engage with their content, comment on posts, share relevant insights) to warm the relationship first.

---

### Stage 3: Pitched → Negotiating

**Minimum to proceed:** They've engaged with our materials and shown buying signals.

- [ ] Competitor quick-scan: who else could they hire? How do we compare?
- [ ] Pricing context: what's their likely budget range? What value can we deliver?
- [ ] Value calculation: estimated ROI of our engagement (time saved, revenue impact, cost avoided)
- [ ] ECP match validation: confirmed they fit our ideal client profile (not just "close enough")
- [ ] **Lead score ≥ 20** (per `SIGNAL_DECAY_MODEL.md` stage gate)

**Source:** client-explorer Steps 4-5, market research, discovery call notes.
**Where to document:** `internal/leads/{slug}/notes/pre-negotiation-brief.md`

---

### Stage 4: Negotiating → Won

**Minimum to proceed:** We know enough to serve them well from day one.

- [ ] Full CLIENT_INTELLIGENCE_PROFILE started (at least 4 of 7 files):
  - [ ] 7LAYER_DIAGNOSTIC.md (from Stage 2)
  - [ ] CONSTRAINT_MAP.md (from Stage 2)
  - [ ] ICP.md (who are THEIR customers)
  - [ ] VOICE.md (how they communicate)
  - [ ] POSITIONING.md (optional pre-close, often built post-close)
  - [ ] BELIEF_PROFILE.md (optional pre-close)
  - [ ] REPAIR_ROADMAP.md (optional pre-close, often built post-close)
- [ ] Proposal sent with scope, timeline, pricing
- [ ] Contract terms discussed
- [ ] Onboarding checklist prepared (`/onboard-client` ready to run)

**Where to document:** `internal/leads/{slug}/notes/` + brand/ stubs.
**On Won:** Run `/onboard-client` → move to `clients/{slug}/`.

---

## 3-Axis Context Load (Formalized)

Before writing ANY deliverable for a lead (or client), load context along three axes. This pattern originates from `save-deliverable.md` Step 0b and is formalized here as a reusable primitive.

### Axis 1 --- TOPIC
What do we already know about the subject of this deliverable?

| Source | What to extract |
|---|---|
| `takeover/correspondence/` + `takeover/emails/` | Prior exchanges on this topic |
| `TASKS.md` | Related tasks (by topic keyword, system name) |
| `audit/` | Related findings (FND-xxx) |
| `meetings/` | Transcripts mentioning the topic |
| `processes/` | Related SOPs or plans |
| `CAPTAINS_LOG.md` | Prior decisions about this topic |

### Axis 2 --- PERSON
What do we know about the recipient/subject?

| Source | What to extract |
|---|---|
| `CONTACTS.md` | Name, role, what they own, tone preference |
| `correspondence/` by name | Prior exchanges with this person |
| `TASKS.md` filtered by Owner/From/Inform | What they're involved in |
| `meetings/` filtered by participant | What was discussed with them |

### Axis 3 --- DOMAIN
For multi-domain clients, filter by the relevant domain.

| Source | What to extract |
|---|---|
| `DOMAIN_CHANNEL_MAP.md` | Which channels/tools connect to this domain |
| `TASKS.md` filtered by `Domain:` | Domain-specific tasks |
| Domain-specific audit findings | Findings tagged to this domain |
| Domain-specific processes | SOPs or plans for this domain |

**Rule:** Never write an email asking questions we already have answers to. "Not loaded ≠ not known."

---

## Gate Enforcement

**Hard gates (MUST pass before advancing):**
- Signal → Discovery: company + contact identified
- Diagnosed → Pitched: lead_score ≥ 15
- Pitched → Negotiating: lead_score ≥ 20

**Soft gates (SHOULD pass, override with documented reason):**
- Discovery → Diagnosed: all 5 checklist items complete
- Negotiating → Won: at least 4 of 7 intelligence profile files started

**Override format:** Add to LEAD_STATUS.md timeline:
```
| YYYY-MM-DD | Gate override | → | Advancing without [item] because [reason] |
```

---

## Integration Points

- `LEAD_TRACKING_STANDARD.md` → references this waterfall for stage advancement rules
- `SIGNAL_DECAY_MODEL.md` → provides score thresholds for hard gates
- `save-deliverable.md` → Step 0b implements the 3-axis context load
- `/pipeline discovery` → executes Stage 1 enrichment (client-explorer)
- `/pipeline diagnostic` → executes Stage 2 enrichment (/7layer + constraints)
- `/morning-brief` → can flag leads with incomplete enrichment for their current stage
- `client-explorer` agent → primary tool for Stages 1 and 3 enrichment

---

*What enrichment steps are we missing? What gates feel too strict or too loose?*
