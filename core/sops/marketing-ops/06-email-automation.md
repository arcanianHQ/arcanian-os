# 06 — Email & Automation

> Generic SOP. Adapt per client in `clients/{slug}/processes/`.
> Owner: Fractional CMO | Tier: 2 | Review: Monthly

## Purpose
Consolidate email sending to governed platforms, enforce automation change management, and maintain healthy send frequency by segment to maximize engagement and minimize unsubscribes.

## Trigger
- New email automation or sequence created
- Platform consolidation or migration
- Suppression rule update
- Monthly email health review
- Unsubscribe rate spike (>0.5% on any single send)

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Fractional CMO | A |
| Marketing Director | R (strategy, calendar, frequency governance) |
| Email / Automation Specialist | R (build, QA, deploy) |
| CRM Administrator | C (data hygiene, suppression lists) |
| Sales Team Lead | C (transactional/sales email alignment) |
| CEO / CMO (internal) | I |

## Systems
- Email marketing platform — campaigns, automations, segmentation, reporting
- Transactional email platform — order confirmations, shipping notifications, password resets
- SMS platform (if applicable) — transactional and marketing SMS
- CRM — contact records, consent status, engagement data
- E-commerce platform — triggered emails (cart abandonment, browse abandonment, post-purchase)

## Steps

### Platform Responsibility Matrix
1. Define which platform sends which type of email:
   - **Email marketing platform:** newsletters, promotional campaigns, nurture sequences, re-engagement
   - **Transactional platform:** order confirmation, shipping, returns, password reset, account notifications
   - **SMS platform:** order updates, appointment reminders, flash sale alerts (opt-in only)
2. Target state: maximum 1 marketing email platform + 1 transactional platform + 1 SMS platform
3. If multiple platforms currently send marketing email → create consolidation plan with timeline
4. No new email-sending platform added without Fractional CMO approval

### Automation Change Management
1. All new automations or changes to existing automations require:
   - Written request describing: trigger, audience, content summary, frequency, goal
   - Marketing Director approval before build
   - QA test (send to internal test group) before activation
2. Automation inventory maintained in shared document: name, trigger, audience size, status (active/paused/draft), last reviewed date
3. Quarterly audit: review all active automations. Pause any that haven't been reviewed in 90 days until re-validated.
4. No "set and forget" — every automation has a review date

### Suppression Rules
1. Global suppression list maintained in CRM, synced to all sending platforms:
   - Hard bounces — permanent suppression
   - Unsubscribes — permanent suppression (legal requirement)
   - Spam complaints — permanent suppression
   - Dead segment (no engagement in 180+ days) — suppressed from marketing email, eligible for one re-engagement attempt per quarter
2. Role-based suppression: sales-owned contacts may be excluded from marketing campaigns (define rules per client)
3. Suppression list synced across platforms weekly (automated if possible, manual check monthly)

### Send Frequency by Segment
1. Define maximum send frequency per engagement tier:
   - **Active** (opened/clicked in last 30 days): max 3 emails/week
   - **Warm** (opened/clicked in last 31-90 days): max 2 emails/week
   - **Cold** (no engagement in 91-180 days): max 1 email/week
   - **Dead** (no engagement in 180+ days): suppressed from regular sends
2. Frequency caps enforced in email platform settings (global frequency cap if available)
3. Automated + manual sends count toward the cap — Marketing Director maintains unified send calendar
4. SMS frequency: max 2 marketing SMS/month (transactional unlimited but monitored)

### Template Standards
1. All marketing emails use approved brand templates:
   - Mobile-responsive design
   - Clear unsubscribe link (legal requirement)
   - Preheader text utilized
   - Single primary CTA above the fold
   - Company address in footer (legal requirement)
2. Template library maintained in email platform — new templates require Marketing Director approval
3. Dark mode compatibility tested before launch
4. Accessibility: alt text on images, sufficient contrast, readable font size (14px+ body)

## Escalation
- If unsubscribe rate exceeds 0.5% on any single send → Marketing Director investigates content and audience within 24h
- If email deliverability drops below 95% → CRM Administrator and email platform support engaged within 24h
- If an unauthorized platform is found sending marketing email → Fractional CMO flags for immediate remediation
- If suppression sync fails → manual sync within 24h, root cause investigation within 48h

## KPIs

| Metric | Target |
|---|---|
| Platforms sending marketing email | 1 email + 1 transactional + 1 SMS |
| Welcome email delivery rate | 100% |
| Average open rate | 30%+ |
| Unsubscribe rate (per send) | < 0.3% |

## Review Cadence
Monthly — Marketing Director reviews email performance (open rate, click rate, unsubscribe rate, deliverability) and automation inventory. Quarterly automation audit and suppression list health check.
