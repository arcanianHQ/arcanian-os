---
scope: shared
type: glossary — canonical definitions of the AOS vocabulary
purpose: One place to look up every term used across the manifesto, learning path, habits, components, layers, rituals, and engagement depths. Definitions are short. Each points at the canonical doc for depth.
related:
  - MANIFESTO_IN_ACCORD.md
  - 7_HABITS.md
  - SIX_COMPONENTS.md
  - SEVEN_PLUS_ONE_LAYERS.md
  - ../RITUALS_BY_LAYER.md
  - ../PERSON_PROFILE_STANDARD.md
---

# AOS Glossary

One place for every term. Short definitions. Pointers to depth where it lives.

---

## The architecture

### AOS (Arcanian Operating System)
The open-source methodology, skill library, agent system, template set, and pattern library for running an agency as an operating system instead of a labor pool. Published under Apache 2.0.

### Accord
The relational property between humans and machines when an agency runs as an operating system. The agency's thinking is legible to the machine; the machine's output is legible to the humans; both sharpen every time either touches real work. Not the same as automation.

### Operating System (as applied to an agency)
An agency whose knowledge, rhythms, loops, evidence, and patterns live in an inspectable, versioned, improvable substrate — not in senior people's heads. Contrasted with a labor pool.

---

## The seven habits

The behavioural side — what a practitioner enacts, continuously, at every layer. Full doc: `7_HABITS.md`.

1. **Diagnose before you deliver**
2. **Show the trail**
3. **Close every loop**
4. **Work in accord with the machine**
5. **Carry lessons through people**
6. **Count on the people in the room**
7. **Sharpen the instrument**

---

## The six components

The structural side — what the operating system is made of. Full doc: `SIX_COMPONENTS.md`.

### Ladder
Where the agency stands on its AI adoption journey, honestly named. See also: *AI Adoption Ladder (L0–L9).*

### Layers
Where in the client's business the problem actually lives. See also: *7+1 Layers (L0–L7).*

### Trail
A source you can point to for every claim. Every evidence-tagged output.

### Rhythms
Loops around projects, reviews, retros. The cadence that keeps habits honest. See also: *Four cadences.*

### Memory
What the system remembers so people don't have to. The substrate that compounds across clients.

### Accord
Humans and AI sharpening each other on real work. Definition repeated because the component and the relational property carry the same name.

---

## The 7+1 Layers (L0–L7) — the diagnostic framework

Where a client's problem lives. Full doc: `SEVEN_PLUS_ONE_LAYERS.md`.

| Layer | Name | What it is |
|---|---|---|
| **L0** | Source | Founder identity, belief field — the unsaid assumptions |
| **L1** | Core | Why the company exists |
| **L2** | Identity | How the company shows up |
| **L3** | Product | What the company actually delivers |
| **L4** | Offer | Stack, packaging, pricing |
| **L5** | Channels | Where the company shows up (Meta, Google, SEO, email, etc.) |
| **L6** | Customer | Who the company serves — actual ICP vs. stated ICP |
| **L7** | Market | Macro forces the company cannot control |

The "+1" is L0. L1-L7 are operational; L0 is the source that shapes all of them.

---

## The AI Adoption Ladder (L0–L9) — the capability map

Where the practitioner is on the AI adoption journey. Any level is reachable from the open repo. Never a commercial gate — always a capability description.

| Level | Capability |
|---|---|
| **L0** | AI-curious — occasional ChatGPT, no systematic use |
| **L1** | Active ChatGPT user, hitting the ceiling |
| **L2** | Moved to Claude.ai web |
| **L3** | Using Claude Code + CLAUDE.md |
| **L4** | Running skills (slash commands) |
| **L5** | Spawning agents + running councils |
| **L6** | Understanding MCP + the data layer |
| **L7** | Connected to Databox (live performance data) |
| **L8** | Connected to Semrush (enrichment) |
| **L9** | Connected to ActiveCampaign (full-stack — traffic, context, journey) |

Ten levels (L0 through L9). L0 is the starting state — the practitioner is AI-curious but has no systematic workflow. The climb runs from L0 through L9, with each level naming a concrete capability threshold.

---

## Four rituals (the cadence spec)

The four scheduled pauses that keep habits honest at each layer's natural rhythm. Full spec: `../RITUALS_BY_LAYER.md`.

| Ritual | Cadence | Covers layers | Duration |
|---|---|---|---|
| **Weekly Pulse** | Weekly, same day | L5 + L7 | 30 min |
| **Monthly Product Review** | Monthly | L3 | 30 min |
| **Quarterly Strategic Session** | Quarterly | L2 + L4 + L6 | 4 hours |
| **Annual Founder Reflection** | Annually | L0 + L1 | 2 days |

---

## Four engagement depths (commercial)

Where Arcanian's personal involvement is priced. The operating system is free. Arcanian's time is not. Full spec: the commercial model in `internal/strategy/DECISIONS_2026-04-18_alignment.md`.

| # | Depth | Arcanian presence | Indicative price |
|---|---|---|---|
| **0** | **Self** | None — all free materials | €0 |
| **1** | **Guided (Onboarding)** | Bounded 3–6 week project | €5–12K |
| **2** | **Embedded** | Ongoing collaboration | €1.5–4K/mo + project fees |
| **3** | **Partnership** | Strategic co-creation | €3–6K/mo |

---

## Rituals-vs-habits-vs-artifacts (the three distinct things)

Three categories that are often confused.

- **Habits** are *how you work.* Continuous behaviours, at every layer, every day.
- **Rituals** are *when you check the work is still honest.* Scheduled pauses at layer-appropriate rhythms.
- **Artifacts** are *what the work leaves behind.* Written documents that habits and rituals produce.

Confusing these three is the source of ritual bloat.

---

## The six owner-facing artifacts

Documents an agency owner can fill out on a Tuesday and read in five minutes.

1. **One-Page Diagnosis** — per client, constraint named + evidence + recommendation + invalidation
2. **Agency Scorecard** — 5–15 weekly numbers, each source-tagged, thresholds and colours
3. **Quarterly Commitments** — 3–7 priorities per quarter, single owner per commitment
4. **Client Loop Tracker** — per client, which rituals are installed, last run date
5. **Pattern Log** — monthly signed patterns, signer lens named, second-lens confirmation pending
6. **Accountability Map** — seats + profile fit + owner + fit assessment

Templates in `core/templates/`; filled instances in `internal/` (agency-wide) or `clients/{slug}/` (client-specific).

---

## Profile-fit terminology

### Kolbe A Index
Four-mode cognitive assessment: Fact Finder (FF), Follow Thru (FT), Quick Start (QS), Implementor (IMP). Scores 1–10 per mode. Used to predict how a person naturally acts under stress and to match seats to profile shapes.

### Wealth Dynamics
Eight-profile creation-style assessment (Creator, Star, Supporter, Deal Maker, Trader, Accumulator, Lord, Mechanic). Used alongside Kolbe to describe how a person creates value.

### Fit / Partial / Mismatch
Seat-assignment verdict. A seat has a required profile shape. The current holder is ✅ Fit, ⚠️ Partial, or 🔴 Mismatch against that shape. Mismatches are structural findings, not personality comments. See `../PERSON_PROFILE_STANDARD.md` § "Profile Fit (Operational)."

### Signer lens
The cognitive angle a practitioner signed a pattern through. A pattern signed by an architectural lens (QS + Creator/Mechanic) is provisional until confirmed by a second lens (e.g., FF + Star). Peer review by a different-lens practitioner strengthens a pattern more than same-lens review.

---

## Other key terms

### Evidence tag taxonomy
Six categories every claim in every deliverable gets tagged with: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Habit 2 enforcement mechanism.

### KNOWN_PATTERNS.md
The cross-agency pattern library. Patterns are promoted from local monthly pattern logs to the cross-agency library after second-client confirmation. Each pattern is signed by its original practitioner; signature stays even as the pattern evolves.

### Founding Cohort
The first 10 agencies that hire Arcanian for onboarding. Preferential pricing locked for life. Direct input on methodology evolution. Vendilli is #1.

### "Together, not over" / *Együtt*
Hungarian for "together." Habit 6's frame: strategy that counts *on* people holds; strategy that counts *around* them collapses. The client is a co-author, not a consumer.

---

*Published under Apache 2.0. Attribution required. Last updated: 2026-04-18.*
