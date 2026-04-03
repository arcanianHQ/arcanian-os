> v1.0 — 2026-03-27

# SOP Auto-Surface Rule

> **ALWAYS-ON BEHAVIOR.** Before executing any task, check if a relevant SOP exists and load it.

---

## The Problem

SOPs exist in `core/sops/` (30+ procedures) and per-client `processes/` (numbered SOPs per client). But they only get loaded when someone explicitly references them. A user asking "send this newsletter" should automatically trigger SOP-06 (Email & Automation). A user saying "onboard this client" should load arcanian/01. But nothing connects the user's intent to the relevant SOP.

**A SOP that isn't loaded is a SOP that doesn't exist.**

## The Rule

### Before executing any task that matches a SOP trigger:

1. **Match the user's request against the keyword→SOP map** (see below)
2. **Load the matched SOP** from `core/sops/` or client `processes/`
3. **Follow the SOP steps** — don't improvise when a procedure exists
4. **If the SOP is outdated or missing steps**: follow it anyway, then flag the gap for update

### Keyword → SOP Routing Map

| Keywords in user request | SOP to load | Path |
|--------------------------|------------|------|
| agency, [Agency A], GD, Growww, Vision, [Competitor], BP Digital, coordinate | SOP-01 Agency Coordination | `marketing-ops/01-agency-coordination.md` |
| lead, contact, scoring, lifecycle, pipeline, funnel, nurture | SOP-02 Lead Lifecycle | `marketing-ops/02-lead-lifecycle.md` |
| budget, spend, invoice, payment, financial, cost, approve spend | SOP-03 Financial Controls | `marketing-ops/03-financial-controls.md` |
| tracking, measurement, GA4, GTM, pixel, conversion, attribution, dashboard | SOP-04 Measurement & Reporting | `marketing-ops/04-measurement-reporting.md` |
| campaign, launch, UTM, brief, ad, creative, kill criteria | SOP-05 Campaign Management | `marketing-ops/05-campaign-management.md` |
| email, newsletter, automation, AC, ActiveCampaign, abandoned cart, sequence, template HTML | SOP-06 Email & Automation | `marketing-ops/06-email-automation.md` |
| access, vendor, onboard vendor, offboard, password, permission, MFA | SOP-07 Vendor & Access | `marketing-ops/07-vendor-access.md` |
| content, blog, SEO content, publish, article, CTA | SOP-08 Content Pipeline | `marketing-ops/08-content-pipeline.md` |
| sales, feedback, lead quality, OCT, sales-marketing, standup | SOP-09 Sales-Marketing Loop | `marketing-ops/09-sales-marketing-loop.md` |
| audit, phase 0, phase 1, browser verify, container audit, feed audit | [Audit Framework] SOPs | `[audit-framework]/01-06` (match by phase) |
| onboard client, new client, discovery, proposal, scaffold | SOP arcanian/01-03 | `arcanian/01-client-onboarding.md` |
| prism, diagnostic, 7layer delivery | SOP arcanian/04 | `arcanian/04-prism-delivery.md` |
| publish, substack, pattern drop, quality bomb | SOP arcanian/05 | `arcanian/05-content-publishing.md` |
| intelligence profile, brand file, voice, Target Profile | SOP arcanian/06 | `arcanian/06-client-intelligence-profile.md` |
| memo, deliverable, extract tasks | SOP arcanian/11 | `arcanian/11-memo-to-tasks.md` |
| inbox, triage, unprocessed | SOP arcanian/09 | `arcanian/09-inbox-management.md` |

### Also check client-specific processes:

Per-client SOPs in `clients/{slug}/processes/` are numbered and often more specific than core SOPs. Load BOTH the core SOP AND the client-specific process if both exist.

Example: "send newsletter for ExampleBrand" →
1. Load `core/sops/marketing-ops/06-email-automation.md` (generic)
2. Load `clients/example-ecom/processes/06-EMAIL-AUTOMATION.md` (client-specific)
3. Load `clients/example-ecom/newsletter/EMAIL-BEST-PRACTICES.md` (CSS rules)
4. Follow all three

### When NO SOP matches:

If the task doesn't match any keyword but is clearly a repeatable process → note it as a candidate for a new SOP in CAPTAINS_LOG.md.

## Integration Points

- **CLAUDE.md** — always-on behavior
- **user-prompt-submit hook** — can match keywords and surface SOP reference
- **save-deliverable.md** — Step 0b already loads topic context; SOP is part of that context
- **Task creation** — every task should reference its governing SOP in the `SOP:` field
- **/scaffold-project** — client processes/ dir links to core SOPs

## Failure Mode

Without this rule:
> User: "send this newsletter to the partner list"
> System: *writes an email, sends it* — no frequency cap check, no deliverability test, no excluded segment handling

With this rule:
> User: "send this newsletter to the partner list"
> System: *loads SOP-06 + client process/06 + EMAIL-BEST-PRACTICES* → follows the procedure including list hygiene, exclusion tags, dark mode CSS fix, test send, frequency cap check
