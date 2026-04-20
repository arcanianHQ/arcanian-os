---
scope: shared
created: 2026-04-17
source-of-truth: internal/strategy/BUSINESS_MODEL.md v1.1
---

# Engagement Map — Package ↔ Delivery Type

> Canonical mapping between **commercial packages** (what the client buys) and **delivery engagement types** (what the team does). One sentence, one side. Never mixed.

---

## The Two Vocabularies

| Layer | Who it's for | Where it's used |
|---|---|---|
| **Commercial packages (SKU)** | Client, prospect, public | Website, pitch, proposal, contract, invoice, CRM, client emails |
| **Delivery engagement types** | Team, internal ops | SOPs, skills, methodology docs, agent prompts, TASKS.md, Captain's Log |

**Rule:** In any single sentence, use one OR the other — never both. If a cross-reference is needed, link to this file.

---

## The 5 × 5 Mapping

| # | Package (client-facing) | Delivery Type (internal) | Pricing | Prerequisite | SOP |
|---|---|---|---|---|---|
| 1 | **Pattern Check** | Arcanian Nexus — the analytics engine *(micro scope, 30-min, no written deliverable)* | Free | — | SOP-15 |
| 2 | **First Signal** | Arcanian Nexus — the analytics engine *(full scope: 7-layer diagnostic + findings report + 2-hour walkthrough)* | €497 | — | SOP-15 |
| 3 | **AOS Setup** | AOS implementation *(standard scope: scaffold + MCP wiring + first skills live + team onboarding)* | €TBD *(see BUSINESS_MODEL.md Open Items)* | — | SOP-04 |
| 4 | **The Fixer** | AOS embedded engagement *(ongoing, embedded team member operating AOS on client's behalf)* | €5-6K/month | **AOS Setup** | SOP-14 |
| 5 | **Custom** | AOS training + AOS custom development *(workshops OR new skills/agents/hooks/integrations outside core)* | Project-based *(quoted per scope)* | depends on scope | SOP-04 (training) + SOP-13 (custom dev) |

---

## Typical Revenue Path (Sequence)

```
Pattern Check (free, lead-gen)
    ↓
First Signal (€497, qualification + diagnosis)
    ↓
AOS Setup (€TBD, implementation — prereq for The Fixer)
    ↓
The Fixer (€5-6K/month, ongoing)
    ↓
(Custom can slot in at any stage, quoted separately)
```

**Exception (#5 Custom):** may be standalone (no prior stages) for agencies or teams who already have AOS installed elsewhere (via agency licensing) and need specific custom development or a training workshop.

---

## Mapping Nuances

- **Pattern Check AND First Signal share one delivery type** (Nexus diagnostic analysis — different scopes). Same SOP (SOP-15) covers both.
- **Custom is a "bucket"** — two different delivery types (training #1 and custom dev #3) both fall under it, depending on project scope. SOP-04 covers the training branch; SOP-13 covers the custom-dev branch.
- **AOS Setup is NOT the same as AOS Starter licensing.** AOS Starter (€1,500 setup + €300/mo, from agency licensing tier in BUSINESS_MODEL.md) is a subscription-based SaaS-like offering for agencies deploying AOS on their own clients. AOS Setup (€TBD, one-time) is a direct-consulting implementation project. These two may eventually reconcile (see Open Items in BUSINESS_MODEL.md).
- **Legacy clients map to #4 AOS embedded engagement:** all 13+ active engagements (Wellis, Diego, Flora MiniWash, FelDoBox, Mancsbázis, Bankmonitor, Cegalapito, Domypress, Bruntál, Jafholz, VRSoft, VRSoftSK, Deluxe, Dhora Academy, Dhora Editoria) reclassified under #4 as of 2026-04-17 — no migration required, just relabeling. Detailed per-client mapping doc: pending (separate issue).

---

## Retired Names (do NOT re-introduce as client-facing)

| Retired | Was | Replaced by |
|---|---|---|
| **Prism** | Old €2-5K diagnostic deliverable | First Signal (€497) + AOS Setup (€TBD). Visual report capability lives on as the First Signal deliverable. |
| **Morsel** | Old free surface diagnostic | Pattern Check |
| **Fractional CMO** (as package name) | Old €5-10K/mo engagement | The Fixer (€5-6K/mo). **Note:** "Fractional CMO" remains valid as a **role name** in marketing-ops SOPs — industry-standard term for the RACI-owner role. |
| **ArcLens** | Internal thinking-interface concept | Capability folded into AOS (skills, agents, memory). Never was client-facing. |
| **Nexus Full** (old tier name) | Old paid diagnostic tier | First Signal |

Historical references in **signed contracts** (Wellis), **sent pitches** (Anthropic, Pipedrive), and **timestamped self-diagnostics** are preserved as-is — no retroactive corrections.

---

## Pricing Open Questions (→ BUSINESS_MODEL.md Open Items)

- AOS Setup price — not yet set. Candidates: flat €3-5K or tiered by client size.
- AOS Setup ↔ AOS Starter (agency licensing) reconciliation — same fee bypass? Separate projects? Bundled with Y1 licensing?
- Custom pricing framework — per-skill, per-agent, per-hour, or hybrid?

---

## When the Mapping Gets Referenced

| Context | What to link |
|---|---|
| Client proposal explaining what they're buying | Package name only (table rows 1-5 left column) |
| Internal SOP or skill describing what the team does | Delivery type only (table rows 1-5 middle column) |
| Pricing question, sales training, new hire onboarding | Link to this file — full mapping |
| Sync between marketing-ops SOP (role: "Fractional CMO") and this file (package: "The Fixer") | Use the role name in the SOP, the package name in the proposal. Don't mix. |

---

## Version + Source of Truth

- **This file** is the canonical mapping.
- **BUSINESS_MODEL.md v1.1** is the source of truth for strategic rationale, pricing, and revenue model.
- **SOP_INDEX.md** (arcanian/04, 13, 14, 15) is the source of truth for delivery procedures.
- If this file disagrees with any of the above, **this file is wrong** — update it to match.

Changes:
- 2026-04-17 — Created (v1.0). Locks the package/engagement split decided in BUSINESS_MODEL.md v1.1.
