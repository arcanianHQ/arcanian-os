---
scope: shared
---

# SOP-04: AOS Onboarding

> Deploy Arcanian OS for a new client (training + implementation — engagement types #1 + #2).

Supersedes: `04-prism-delivery.md` (archived 2026-04-17, `internal/archive/retired/arcanian-sops/`).

---

## 1. Purpose

Install Arcanian OS in the client's environment, configure the standard scaffold (CLIENT_CONFIG, DOMAIN_CHANNEL_MAP, CONTACTS, brand intelligence shell), wire the client's MCP connections (Databox, GA4, platform APIs as applicable), and train the client's team to operate the system. The goal is a functioning, self-operated AOS deployment — not a one-time diagnostic.

## 2. Trigger

- Client purchased **AOS Setup** package (engagement type #2 — implementation), or
- Client purchased **Custom — AOS training** (engagement type #1 — training on an existing AOS install)
- Contract signed + payment confirmed

## 3. RACI

| Activity | Founder | Delivery Lead | Research Lead | Client |
|---|---|---|---|---|
| AOS scaffold deployment | A | R | C | I |
| MCP connections wiring | A | R | C | C |
| CLIENT_CONFIG + DOMAIN_CHANNEL_MAP fill | A | R | C | C |
| First skills live (validation) | A, R | C | I | C |
| Training workshop delivery | A, R | C | C | R |
| Handoff + documentation | A | R | I | R |

## 4. Systems & Tools

- `/scaffold-project` skill (core AOS scaffold)
- MCP config (`.mcp.json`) — Databox, GA4, Ads, platform APIs
- `CLIENT_CONFIG.md` template
- `DOMAIN_CHANNEL_MAP.md` template
- `CONTACTS.md` template
- Brand intelligence profile templates (7 files)
- `core/skills/onboard-client.md`
- Claude Code (client's own subscription OR shared access model — TBD per engagement)

## 5. Steps

### 5.1 Pre-kickoff preparation
- Confirm licensing model (direct AOS access vs. hosted-by-Arcanian — depends on AOS Setup variant, see BUSINESS_MODEL.md)
- Collect client platform access checklist
- Schedule kickoff workshop (2-3 hours, all stakeholders present)

### 5.2 Scaffold deployment
- Run `/scaffold-project` with client slug
- Verify directory structure matches standard (`clients/{slug}/` with all expected subdirs)
- Install CLAUDE.md kernel + path-scoped rules

### 5.3 MCP + data wiring
- Configure Databox MCP (Nexus foundation — see `core/methodology/DATABOX_MANDATORY_RULE.md`)
- Configure platform MCPs relevant to client domains (GA4, Google Ads, Meta, AC, etc.)
- Run MCP connection check (`/connect` skill)
- Verify Nexus output generation on real client data (one test query)

### 5.4 Profile fill-in
- Fill `CLIENT_CONFIG.md` (domains, tracking IDs, platform IDs)
- Fill `DOMAIN_CHANNEL_MAP.md` (which channels serve which domains — mandatory for multi-domain clients)
- Fill `CONTACTS.md` (client team, agencies, preferred channels, language)
- Build initial 7-file brand intelligence profile (may be partial — to be deepened during training)

### 5.5 First skills validation
- Run 2-3 core diagnostic skills on client data to validate setup (e.g., `/7layer` Mode 1, `/health-check`)
- Confirm Nexus output matches client expectations (sanity check)

### 5.6 Training workshop delivery
- 2-3 hour workshop with client team
- Cover: AOS architecture, how to ask questions, key skills per role, escalation flow
- Hands-on: client runs a real diagnostic alongside us
- Recorded for future reference

### 5.7 Handoff documentation
- Deliver: client-specific runbook (how to use THEIR AOS install — skills they'll use, MCP tokens location, who to contact for what)
- Schedule 1-week check-in to debug/iterate
- Transition to ongoing support model (The Fixer if applicable, or async for self-operated)

## 6. Escalation

- Missing MCP access → block scaffold completion, escalate to Founder, do not proceed with partial data
- Client team resists training → Founder engages directly, reviews fit for engagement type
- Scaffold errors (hook failures, parallel Write batch misses) → see `feedback_scaffold_batch_writes.md`; always verify Step 12 after parallel writes
- Client asks for engagement outside AOS Setup scope → quote as Custom (engagement type #3)

## 7. KPIs

| Metric | Target |
|---|---|
| Scaffold deployed | Within 3 business days of trigger |
| MCP connections live | Within 5 business days |
| First skills validated | Within 7 business days |
| Training workshop | Within 10 business days |
| Client self-operated | Within 30 days (for standard AOS Setup) |

## 8. Review Cadence

- **After each onboarding:** Debrief — what worked, what didn't, any scaffold improvements needed
- **Quarterly:** Review onboarding playbook; update `/scaffold-project` skill based on learnings

## 9. Related SOPs

- SOP-01: Client Onboarding (commercial side: discovery → proposal → contract)
- SOP-02: Discovery Call
- SOP-03: Proposal Delivery
- SOP-06: Client Intelligence Profile (7-file deepening — post-onboarding)
- SOP-13: AOS Custom Development (when client needs skills/agents outside core)
- SOP-14: AOS Embedded Engagement (when client converts to The Fixer)
- SOP-15: Arcanian Nexus — the analytics engine — Diagnostic Analysis (Pattern Check / First Signal delivery)

## Open items

- Training workshop curriculum — detailed slide deck pending
- Onboarding runbook template — draft pending
- AOS Setup pricing → `internal/strategy/BUSINESS_MODEL.md` Open Items
