# 07 — Vendor Access Management

> Generic SOP. Adapt per client in `clients/{slug}/processes/`.
> Owner: Fractional CMO | Tier: 2 | Review: Quarterly

## Purpose
Eliminate single points of failure in platform access, ensure every critical system has backup authentication, and govern vendor onboarding/offboarding with auditable checklists.

## Trigger
- New vendor or agency onboarded
- Vendor or agency offboarded
- Team member joins or leaves
- Quarterly access audit cycle
- Security incident or suspected unauthorized access

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Fractional CMO | A |
| Marketing Director | R (access matrix, onboarding/offboarding execution) |
| IT / Security | R (technical access provisioning, MFA enforcement) |
| CRM Administrator | C (CRM-specific access) |
| Agency Account Manager(s) | C (confirm access needs) |
| CEO / CMO (internal) | I |

## Systems
- Password manager — shared vaults per vendor/role
- Access matrix spreadsheet — who has access to what, at what level
- Contract tracker — vendor agreements, terms, renewal dates

## Steps

### Access Matrix
1. Maintain a single access matrix covering all marketing-related platforms:

| Platform Category | Examples | Access Levels |
|---|---|---|
| CRM | — | Admin, Editor, Viewer |
| E-commerce | — | Admin, Editor, Viewer |
| Web analytics | — | Admin, Editor, Viewer |
| Tag management | — | Publish, Edit, View |
| Ad platforms (search) | — | Admin, Standard, Read-only |
| Ad platforms (social) | — | Admin, Advertiser, Analyst |
| Dashboard / BI | — | Admin, Editor, Viewer |
| Data warehouse | — | Admin, Read-only |
| Server-side GTM | — | Admin, Editor, Viewer |
| Email / automation | — | Admin, Editor, Viewer |
| Calling / VoIP | — | Admin, User, Viewer |
| Project management | — | Admin, Member, Guest |

2. Every platform must have minimum 2 people with admin access (one internal + one backup)
3. Access levels follow principle of least privilege — vendors get minimum access needed for their scope
4. Matrix updated within 24h of any access change

### Onboarding Checklist
1. Marketing Director receives onboarding request with: vendor name, contact person, scope of work, required platforms
2. Fractional CMO approves access scope based on vendor's contract and role
3. For each approved platform:
   - Create named user account (no shared logins)
   - Set appropriate access level per matrix
   - Enable MFA where available
   - Document in access matrix: who, what platform, what level, date granted, granted by
4. Vendor receives: access credentials via secure channel (password manager invite or encrypted message), platform-specific usage guidelines, escalation contacts
5. Onboarding target: all access provisioned within 3 business days of approval

### Offboarding Checklist
1. Marketing Director initiates offboarding checklist when vendor/agency engagement ends or team member departs
2. For each platform the departing party had access to:
   - Revoke user account or downgrade to no-access
   - Remove from shared password manager vaults
   - Rotate any shared credentials the party had access to
   - Document in access matrix: date revoked, revoked by
3. Verify revocation: Marketing Director confirms access is actually removed (test login if possible)
4. Offboarding target: all access revoked within 24h of departure for team members, 3 business days for vendors
5. If vendor had access to sensitive data (customer PII, financial): confirm data deletion or return per contract terms

### Vendor Contract Tracker
1. All vendor and agency contracts logged in shared tracker:
   - Vendor name, service category, contract start/end date, renewal type (auto/manual), notice period
   - Monthly/annual cost, payment terms
   - Key contact person
   - Link to signed contract document
2. Marketing Director reviews tracker monthly — flag contracts expiring within 60 days
3. Fractional CMO decides: renew, renegotiate, or terminate — 30 days before expiry

### Quarterly Access Audit
1. Marketing Director pulls current access state from all platforms (screenshot or export)
2. Compare actual access against access matrix — identify discrepancies:
   - Accounts that should have been removed (stale access)
   - Access levels higher than needed (over-provisioned)
   - Platforms with only 1 admin (SPOF risk)
3. Remediate all discrepancies within 5 business days
4. Audit results documented and shared with Fractional CMO
5. Any critical findings (e.g., former vendor still has admin access) escalated immediately

## Escalation
- If a platform has only 1 admin and that person becomes unavailable → Marketing Director escalates to IT / Security for emergency access recovery within 4h
- If unauthorized access detected → IT / Security locks the account immediately, Fractional CMO notified within 1h
- If vendor refuses to return or delete client data post-offboarding → escalate to legal

## KPIs

| Metric | Target |
|---|---|
| Platforms with backup admin auth | 100% |
| Access matrix current (no stale entries) | 100% |
| Onboarding time (approval to access) | < 3 business days |
| Service breaks due to access issues | Zero |
| Vendor contracts tracked | 100% |

## Review Cadence
Quarterly — Marketing Director conducts full access audit. Monthly contract tracker review. Immediate audit triggered by any security incident.
