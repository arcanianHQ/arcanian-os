---
client: "{client}"
last_updated: "YYYY-MM-DD"
---

# {Client Name} — Escalation Contacts

## Who Fixes What

| Issue Domain | Examples | Primary Owner | Escalation Contact | Notes |
|-------------|----------|---------------|-------------------|-------|
| GTM Web container | Tag config, triggers, variables, consent setup | | | |
| GTM SGTM container | Server-side tags, SGTM clients, transport | | | |
| SGTM infrastructure | Server health, scaling, DNS, SSL | | | |
| Meta Pixel / CAPI | Pixel events, catalogue, Business Manager | | | |
| GA4 configuration | Events, conversions, audiences, data streams | | | |
| Google Ads | Conversion actions, audiences, enhanced conversions | | | |
| Product feed | Feed generation, XML/CSV format, item attributes | | | |
| CMP / Consent | Cookie banner, consent categories, compliance | | | |
| Platform (Magento/Shopify) | DataLayer, checkout events, product data | | | |
| DNS / Hosting | Domain, SSL, CDN, server config | | | |
| Custom development | Theme changes, module development, API integration | | | |
| Data / Analytics | Reports, dashboards, data discrepancies | | | |

## Key Contacts

| Name | Role | Email | Phone | Availability | Notes |
|------|------|-------|-------|-------------|-------|
| | Client-side lead | | | | |
| | Developer | | | | |
| | Marketing | | | | |
| | Agency contact | | | | |

## Communication Protocol

| Channel | Use For | Response Time |
|---------|---------|--------------|
| Email | Non-urgent findings, weekly reports, documentation | 24-48h |
| Slack / Teams | Quick questions, clarifications, status updates | Same day |
| Phone / Call | Critical issues (P0), blocked work, complex discussions | Immediate |
| Shared doc / ticket | Detailed fix instructions, evidence, step-by-step | As per priority |

## Reporting Cadence

| Report | Frequency | Recipient(s) | Format | Day |
|--------|-----------|-------------|--------|-----|
| Weekly check summary | Weekly | | WEEKLY_CHECK.md | Monday |
| Audit report | Per audit | | AUDIT_REPORT.md | After completion |
| Finding notifications | As found | | FINDING.md | Immediate for P0 |
| Monthly summary | Monthly | | Email summary | 1st of month |

## Escalation Rules

1. **P0 (Critical):** Data loss actively happening or tracking completely broken.
   - Notify immediately via phone/call.
   - Owner must acknowledge within 1 hour.
   - Fix or workaround within 24 hours.

2. **P1 (High):** Significant data quality issue or major feature broken.
   - Notify via Slack/Teams within 4 hours of discovery.
   - Owner must acknowledge within 24 hours.
   - Fix within 1 week.

3. **P2 (Medium):** Data quality concern, non-critical misconfiguration.
   - Include in next weekly check report.
   - Fix within 2 weeks.

4. **P3 (Low):** Minor improvement, best practice recommendation.
   - Include in audit report.
   - Fix at convenience.

## Access & Permissions Log

| Date | Action | Platform | Granted By | Notes |
|------|--------|----------|-----------|-------|
| YYYY-MM-DD | Access granted | GTM Web | | Editor access |
| | | | | |

---

**Template version:** 1.0
**Last updated:** 2026-03-07
