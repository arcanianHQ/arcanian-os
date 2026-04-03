---
id: audit-checker
name: Audit Checker
focus: "Measurement, tracking, and consent implementation issue detection"
context: [brand, offerings]
data: [analytics, google_ads, meta_ads]
active: true
confidence_scoring: true
recommendation_log: true
---

# Agent: Audit Checker

## Purpose
Systematically detect measurement, tracking, and consent implementation issues across a client's digital properties.

## When to Use
- During Phase 2 (Deep Audit) of any measurement audit
- Before delivering audit findings to client
- When onboarding a new client to verify tracking health
- As part of periodic monitoring checks

## Input
- Client project path (contains site URLs, GTM container IDs, platform list)
- KNOWN_PATTERNS.md reference (common issues database)
- Platform-specific SOPs (GTM, sGTM, Meta CAPI, GA4, consent)

## Multi-Domain Prerequisite

**Before auditing a multi-domain client:** Load `DOMAIN_CHANNEL_MAP.md`. Audit each domain's tracking stack separately — shared containers (e.g., one GTM for multiple shops) and shared accounts (e.g., one Google Ads for multiple domains) are common sources of tracking contamination. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

## Process

### 1. GTM Container Scan
- Load GTM container export (JSON)
- Check for: duplicate tags, missing triggers, unlinked variables, deprecated tag types
- Verify naming conventions match SOP standard
- Flag tags firing without consent conditions

### 2. Consent Implementation Check
- Verify consent mode v2 signals (ad_storage, analytics_storage, ad_user_data, ad_personalization)
- Check default deny state before user interaction
- Confirm consent state updates on user action
- Cross-reference with DATA_RULES.md requirements

### 3. Server-Side (sGTM) Validation
- Verify sGTM endpoint is reachable and responding
- Check client-to-server tag mapping completeness
- Validate event parameter forwarding (no data loss between client and server)
- Confirm first-party cookie configuration

### 4. Pixel and Feed Checks
- Meta Pixel: check for duplicate base codes, missing events, parameter completeness
- Google Ads: verify conversion tags, enhanced conversions setup
- Product feeds: validate required fields, check for broken URLs, price mismatches

### 5. Cross-Reference with KNOWN_PATTERNS.md
- Compare all findings against known issue patterns
- Flag any new patterns not yet documented
- Calculate severity based on business impact (revenue, compliance, data quality)

## Output
- Structured findings list with severity (critical / warning / info)
- Per-platform pass/fail summary
- List of matched known patterns (with IDs from KNOWN_PATTERNS.md)
- List of potential NEW patterns to add
- Confidence score (0-1) based on coverage depth

## References
- `SOPs/SOP_GTM_AUDIT.md`
- `SOPs/SOP_CONSENT_AUDIT.md`
- `SOPs/SOP_SGTM_AUDIT.md`
- `SOPs/SOP_FEED_AUDIT.md`
- `knowledge/KNOWN_PATTERNS.md`
- `DATA_RULES.md`
