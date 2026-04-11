---
project: "loopforge"
sync: todoist
sync_id: ""
updated: 2026-04-03T00:00
---
> v1.0 — 2026-04-03

# LoopForge — Tasks

> Example task board for a SaaS client. Shows task format with ontology edges.

---

## P0 — Critical

- [ ] #1 Fix GA4 consent mode — default state is "granted" instead of "denied"
  - @next @computer
  - P0 | Owner: You | Due: 2026-04-07 | Effort: 1h | Impact: unlock
  - Created: 2026-04-03
  - Layer: L5
  - FND: consent mode misconfigured — GDPR risk + data quality
  - SOP: measurement-audit/01-phase-0-cli-baseline
  - Goal: Q2-measurement-health

---

## P1 — This Week

- [ ] #2 Set up Databox dashboard — connect GA4, Google Ads, HubSpot
  - @next @computer
  - P1 | Owner: You | Due: 2026-04-10 | Effort: 2h | Impact: lever
  - Created: 2026-04-03
  - Layer: L5
  - SOP: marketing-ops/04-measurement-reporting

- [ ] #3 Run /7layer diagnostic — identify primary constraint
  - @next
  - P1 | Owner: You | Due: 2026-04-11 | Effort: 3h | Impact: unlock
  - Created: 2026-04-03
  - Layer: L0-L7

---

## P2 — Next 2 Weeks

- [ ] #4 Agency coordination — align SEO agency on content pipeline
  - @waiting
  - P2 | Owner: You | Due: 2026-04-18 | Effort: 1h | Impact: lever
  - Waiting on: SEO agency — send keyword research by Apr 14
  - Waiting since: 2026-04-03
  - Follow-up: 2026-04-14 — ping if not received
  - Created: 2026-04-03
  - Layer: L5
  - SOP: marketing-ops/01-agency-coordination

- [ ] #5 Pipeline decay — 15 qualified leads in HubSpot with no follow-up >14 days
  - @waiting
  - P1 | Owner: You | Due: 2026-04-08 | Effort: 2h | Impact: unlock
  - Waiting on: Sales team — need owner assignment for 15 stale leads
  - Waiting since: 2026-03-25
  - Follow-up: 2026-04-08 — escalate if no action, leads are decaying
  - Created: 2026-03-25
  - Layer: L6
  - FND: 15 MQLs entered pipeline Mar 1-25, zero follow-up activity in HubSpot. Average deal cycle is 21 days — these leads are past the engagement window.
  - SOP: marketing-ops/02-lead-lifecycle
