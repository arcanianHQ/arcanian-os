---
scope: shared
---

# SOP-13: AOS Custom Development

> Build custom skills, agents, hooks, or integrations for a client outside the core AOS library (engagement type #3).

---

## 1. Purpose

Develop client-specific AOS capabilities (new skills, new agents, new hooks, new MCP integrations, new scaffold variants) that aren't part of the core AOS distribution. Deliver the custom artifact ready to run in the client's AOS install, document it, and optionally back-port to core if broadly useful.

## 2. Trigger

- Client signed Custom engagement (engagement type #3) — either standalone or as add-on to AOS Setup / The Fixer
- Scope defined: what skill/agent/hook/integration is needed, expected behavior, success criteria

## 3. RACI

| Activity | Founder | Delivery Lead | Research Lead | Client |
|---|---|---|---|---|
| Scope definition | A | R | C | C |
| Technical design | A, R | C | I | I |
| Implementation | A | R | C | I |
| Testing (client data) | A | R | C | C |
| Deployment to client AOS | A | R | I | I |
| Documentation | A | R | I | R |
| Decision: back-port to core | A, R | C | C | — |

## 4. Systems & Tools

- Existing AOS skills/agents as reference (`core/skills/`, `core/agents/`)
- Client's AOS scaffold (target deployment)
- `.claude/commands/` (skill symlinks)
- `core/methodology/ONTOLOGY_STANDARD.md` (if new artifact adds edges)
- `core/methodology/MODEL_ROUTING.md` (choose T1/T2/T3 model for new agents)

## 5. Steps

### 5.1 Scope + design
- Written scope doc: what, why, expected input/output, success criteria
- Technical design: skill vs. agent vs. hook vs. integration; dependencies; model tier
- Client approval on scope before implementation starts

### 5.2 Implementation
- Build in dev environment (Founder / Delivery Lead)
- Follow core conventions (skill frontmatter, naming, scope tags)
- If new agent: formal `.claude/agents/` definition required

### 5.3 Testing
- Run against client test data
- Verify output matches expected behavior
- Edge case tests: domain isolation, evidence classification, confidence tags where applicable

### 5.4 Deployment
- Deploy to client's AOS scaffold (symlink or copy per client agreement)
- Verify runs in client environment
- Documentation in client's runbook

### 5.5 Back-port decision
- Post-delivery: assess generality — is this useful for other clients?
- If yes: back-port to core, update CHANGELOG, propagate to 4 AOS flavors per scope
- If no: stays client-specific, noted in ENGAGEMENT_MAP

## 6. Escalation

- Scope creep during implementation → pause, re-scope with client, adjust pricing (Custom is project-based, see BUSINESS_MODEL.md)
- Implementation requires changes to core AOS (not just add-on) → escalate to Founder, separate decision
- Test failures with unclear cause → Peer review via `/council` or Agent review

## 7. KPIs

| Metric | Target |
|---|---|
| Scope approved | Before implementation starts (no exceptions) |
| Implementation complete | Per scope timeline (typically 3-10 business days per skill/agent) |
| Deployed + validated | Within agreed delivery window |
| Back-port decision | Within 7 days of deployment |

## 8. Review Cadence

- **After each Custom delivery:** Retro — what patterns emerged, any core AOS gaps revealed
- **Quarterly:** Aggregate Custom deliveries → identify core skills/agents to back-port

## 9. Related SOPs

- SOP-04: AOS Onboarding (prerequisite if client is new)
- SOP-14: AOS Embedded Engagement (often Custom work happens within Fixer context)
- `core/methodology/ONTOLOGY_STANDARD.md`
- `core/methodology/MODEL_ROUTING.md`

## Open items

- Custom engagement pricing framework (per skill / per agent / per hour) → BUSINESS_MODEL.md Open Items
- Back-port criteria checklist — draft pending
