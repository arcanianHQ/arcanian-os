# Arcanian Ops — SOP Library Index

> Master index of all Standard Operating Procedures.
> Generic, reusable, NO client-specific data or PII.
> Client-specific adaptations live in `clients/{slug}/processes/`.

---

## Marketing Operations (marketing-ops/)

Core processes for running a client's marketing operation. Applicable to ALL clients.

| # | SOP | Tier | Purpose | Systems |
|---|---|---|---|---|
| 01 | [Agency Coordination](marketing-ops/01-agency-coordination.md) | 1 | Align external agencies, prevent conflicts, single coordination point | PM tool, email, dashboards |
| 02 | [Lead Lifecycle](marketing-ops/02-lead-lifecycle.md) | 1 | End-to-end lead journey: capture → enrichment → scoring → assignment → outcome | CRM, e-commerce, calling, automation |
| 03 | [Financial Controls](marketing-ops/03-financial-controls.md) | 1 | Prevent uncontrolled spend, approval workflows, payment normalization | Budget sheet, ad platforms, attribution |
| 04 | [Measurement & Reporting](marketing-ops/04-measurement-reporting.md) | 2 | Single source of truth for performance: tracking, attribution, dashboards | GA4, GTM/sGTM, ads, dashboards |
| 05 | [Campaign Management](marketing-ops/05-campaign-management.md) | 2 | Brief → approve → launch → review with naming, UTM, kill criteria | Ad platforms, PM tool, UTM builder |
| 06 | [Email & Automation](marketing-ops/06-email-automation.md) | 2 | Consolidate email platforms, govern automations, frequency caps | CRM, email, SMS, e-commerce |
| 07 | [Vendor & Access](marketing-ops/07-vendor-access.md) | 2 | Eliminate access SPOFs, onboard/offboard checklists, quarterly audit | All platforms (access matrix) |
| 08 | [Content Pipeline](marketing-ops/08-content-pipeline.md) | 3 | Turn SEO content into revenue: CTAs, email capture, nurture paths | Blog, CRM, analytics |
| 09 | [Sales-Marketing Loop](marketing-ops/09-sales-marketing-loop.md) | 3 | Close marketing→sales gap: feedback standup, lead quality scoring, OCT | CRM, calling, PM, ad platforms |

### Tiers
- **Tier 1 (week 1):** Existential — operation cannot function without these
- **Tier 2 (weeks 2-3):** Operational — makes execution consistent and scalable
- **Tier 3 (weeks 4+):** Optimization — closes the loop and drives growth

---

## [Audit Framework] ([audit-framework]/)

Phase-gated audit methodology. Applied to every client's measurement stack.

| # | SOP | Purpose |
|---|---|---|
| 01 | [Phase 0 — CLI Baseline]([audit-framework]/01-phase-0-cli-baseline.md) | Feed health, SGTM endpoints, structured data, robots.txt |
| 02 | [Phase 1 — Browser Verification]([audit-framework]/02-phase-1-browser.md) | JS errors, tracking inventory, dataLayer, consent, network |
| 03 | [Phase 2 — Dashboard Audit]([audit-framework]/03-phase-2-dashboards.md) | Meta EM, Google Ads, GA4, GMC, Search Console |
| 04 | [Phase 3 — Container Audit]([audit-framework]/04-phase-3-container.md) | Tag inventory, triggers, consent gating, variables, SGTM clients |
| 05 | [Phase 4 — Cross-Verification]([audit-framework]/05-phase-4-cross-verify.md) | 10-product end-to-end trace |
| 06 | [Phase 5 — Diagnosis]([audit-framework]/06-phase-5-diagnosis.md) | Pattern matching, root causes, action playbooks |
| 07 | [Knowledge Extraction]([audit-framework]/07-knowledge-extraction.md) | MANDATORY post-audit: patterns → hub, SOP improvements, scripts |

---

## Arcanian Internal (arcanian/)

Our own operational SOPs.

| # | SOP | Purpose |
|---|---|---|
| 01 | [Client Onboarding](arcanian/01-client-onboarding.md) | Discovery → proposal → contract → scaffold → kickoff |
| 02 | [Discovery Call](arcanian/02-discovery-call.md) | Standard discovery call structure + scoring |
| 03 | [Proposal Delivery](arcanian/03-proposal-delivery.md) | Proposal writing → review → send → follow-up |
| 04 | [Prism Delivery](arcanian/04-prism-delivery.md) | Diagnostic → Prism report → walk-through → handoff |
| 05 | [Content Publishing](arcanian/05-content-publishing.md) | Wed Pattern Drop + Fri Quality Bomb + Bridge Rule |
| 06 | [Client Intelligence Profile](arcanian/06-client-intelligence-profile.md) | 7 diagnostic files per client (7layer, constraints, repair, pattern, voice, Target Profile, positioning) |
| 07 | [Knowledge Sharing](arcanian/07-knowledge-sharing.md) | Team briefing, skill updates, methodology evolution |
| 08 | [Quarterly Review](arcanian/08-quarterly-review.md) | Client engagement health check, renewal/expansion decision |

---

## Platform SOPs (platforms/)

Platform-specific procedures. Referenced by marketing-ops and [audit-framework] SOPs.

| Platform | SOPs planned | Status |
|---|---|---|
| `ga4/` | Property setup, event config, audience creation, BigQuery linking | Planned |
| `google-ads/` | Account structure, conversion tracking, Enhanced Conversions, OCT | Planned |
| `meta-ads/` | Pixel setup, CAPI, catalogue, custom audiences, reporting | Planned |
| `activecampaign/` | Account setup, automation architecture, deal pipeline, list hygiene | Planned |
| `shopify/` | GTM integration, checkout tracking, Deep Data, cart recovery | Planned |
| `gtm/` | Container structure, naming, consent mode, tag templates | Planned |
| `sgtm/` | Setup, client config, CAPI tags, health monitoring | Planned |
| `databox/` | Dashboard creation, data source connection, goals, alerts | Planned |
| `hubspot/` | CRM setup, lead scoring, workflow, deal pipeline | Planned |

---

## SOP Template

Every SOP follows the standard 9-section structure:

```
1. Purpose — Why this process exists (one sentence)
2. Owner — Who is accountable (role, not name)
3. Trigger — What starts this process
4. Stakeholders (RACI) — Roles with Responsible/Accountable/Consulted/Informed
5. Systems — Platforms involved (generic: "CRM" not "ActiveCampaign")
6. Steps — Numbered, actionable steps
7. Escalation — When and how to escalate
8. KPIs — What success looks like (measurable)
9. Review Cadence — How often to review and update
```

Template: `templates/SOP_TEMPLATE.md`

---

## How SOPs Connect

| SOPs reference | In tasks as | Example |
|---|---|---|
| Marketing-ops SOPs | `SOP: marketing-ops/05-campaign-management` | Campaign launch task |
| Audit SOPs | `SOP: [audit-framework]/03-phase-2-dashboards` | Dashboard audit task |
| Arcanian SOPs | `SOP: arcanian/01-client-onboarding` | New client setup task |
| Platform SOPs | `SOP: platforms/ga4/event-config` | GA4 setup task |

## Client Adaptation

Generic SOPs live here. Client-specific adaptations live in `clients/{slug}/processes/`.
Client process files reference the master SOP:
```markdown
# 01 — Agency Coordination ({Client})
> Based on: sops/marketing-ops/01-agency-coordination.md
> Adapted for: {client-specific context}
```

---

## Stats

| Category | Count | Status |
|---|---|---|
| Marketing Operations | 9 | Done (from ExampleBrand learnings) |
| [Audit Framework] | 7 | Done (from methodology) |
| Arcanian Internal | 8 | Done |
| Meta (index + template) | 2 | Done |
| Platform SOPs | ~30-50 | Planned |
| **Written** | **26** | 9 + 7 + 8 + index + template |
| **Total planned** | **~55-75** | |
| **Target** | **100+** | Growing with every client |
