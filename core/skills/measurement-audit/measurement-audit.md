---
scope: int-confidential
---

# Skill: Measurement Audit v2.0

> v2.0 — 2026-04-12 — Refactored to agent-council architecture.

## Purpose

Runs a full progressive measurement health audit for an e-commerce client. Orchestrates 7 specialized agents via the **measurement-audit council** across 5 automated phases. Produces a scored AUDIT_REPORT.md.

## Architecture

This skill uses the **measurement-audit council** (`core/agents/councils/measurement-audit.yaml`):

| Agent | Phase | Weight | What it checks |
|---|---|---|---|
| `audit-feed` | 0 | 10% | Feed health, required fields, pipeline trace |
| `audit-sgtm` | 0 | 20% | sGTM endpoint, event receipt, cookies, tag responses |
| `audit-consent` | 1 | 25% | 7-test Consent Mode v2 protocol (GDPR gate) |
| `audit-gtm` | 3 | 15% | Tag inventory, consent gating, GA4 config |
| `audit-gtm-architect` | 3 | 10% | 6 Core Container Decisions framework |
| `audit-cross-verifier` | 4 | 20% | ID/value/event consistency across systems |
| `audit-pattern-matcher` | 5 | — | Pattern matching + recommendations (chairman) |

Pipeline: Phase 0 (parallel) → Phase 1 → Phase 3 (sequential) → Phase 4 → Phase 5
Phase 2 (Platform Dashboards) is manual — not automated.

Scoring: `core/methodology/MEASUREMENT_AUDIT_SCORING.md`

## Trigger

```
/measurement-audit {client-slug}
/audit {client-slug}
```

Example: `/audit diego`, `/audit vrsoft`

## Prerequisites

- `clients/{client-slug}/CLIENT_CONFIG.md` must exist and be populated
- **Multi-domain:** If CLIENT_CONFIG.md lists 2+ domains, `DOMAIN_CHANNEL_MAP.md` MUST exist. Load it before Phase 0. Every audit query, finding, and recommendation must specify which domain it applies to. Shared data sources (e.g., one Google Ads account serving multiple domains) must be filtered per domain. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.
- **Evidence classification:** Every finding (FND) and recommendation (REC) MUST tag evidence: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Causal claims must pass timeline test. GA4 alone is insufficient — always check platform-side data. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.
- **Confidence scoring:** Every FND and REC gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).
- **Recommendation dedup:** Before creating any REC, check `RECOMMENDATION_LOG.md` in the client directory. After creating a REC, auto-append to the log. See `core/methodology/RECOMMENDATION_DEDUP_RULE.md`.
- Chrome running with `--remote-debugging-port=9222` (for Phase 1+)
- CLI scripts in `scripts/cli/` must be executable
- Python 3.x available (for Phase 3 analysis scripts)

## Procedure

### Step 0: Pre-flight

1. **Load** `clients/{client-slug}/CLIENT_CONFIG.md`
2. **Validate** required fields are populated:
   - At minimum: slug, at least one production domain, at least one tracking ID
   - If critical fields are missing, STOP and report what is needed
3. **Create** audit directory: `clients/{client-slug}/audits/YYYY-MM-DD_audit/`
4. **Create** phase subdirectories: `phase0/` through `phase5/`
5. **Initialize** finding counter by scanning existing `clients/{client-slug}/findings/` for highest FND number

### Step 1: Phase 0 -- CLI Baseline

**Access required:** `curl`, `grep`, command line only

**Run these scripts from `scripts/cli/`:**

1. **SGTM Health Check**
   ```bash
   scripts/cli/sgtm-health-check.sh {sgtm-endpoint}
   ```
   - Checks SGTM endpoint responds (HTTP 200)
   - Verifies correct headers
   - Tests cookie behavior
   - Log output to `phase0/sgtm-health.log`

2. **Feed Health Check**
   ```bash
   scripts/cli/feed-health-check.sh {feed-url}
   ```
   - Downloads feed, checks well-formedness
   - Counts items, checks required fields (id, title, price, availability, link, image_link)
   - Checks GTIN/MPN presence
   - Log output to `phase0/feed-health.log`

3. **Pipeline Trace** (for test products from CLIENT_CONFIG)
   ```bash
   scripts/cli/pipeline-trace.sh {feed-url} {product-id}
   ```
   - Traces specific product IDs through the feed
   - Checks price consistency, availability, ID format
   - Log output to `phase0/pipeline-trace.log`

4. **CLI Structured Data**
   ```bash
   scripts/cli/cli-structured-data.sh {domain}
   ```
   - Fetches page, extracts JSON-LD structured data
   - Validates Product, BreadcrumbList, Organization schemas
   - Log output to `phase0/structured-data.log`

5. **Feed Item Count Log**
   ```bash
   scripts/cli/feed-item-count-log.sh {feed-url}
   ```
   - Records item count for baseline tracking
   - Log output to `phase0/feed-item-count.log`

**After Phase 0 — Auto-Populate Config:**

Update `CLIENT_CONFIG.md` and `ACCESS_REGISTRY.md` with Phase 0 discoveries:

| What Was Discovered | Write To |
|-------------------|----------|
| SGTM endpoint status (healthy/unhealthy) | `ACCESS_REGISTRY.md` → SGTM Provider table |
| Feed item counts (baseline) | `CLIENT_CONFIG.md` → Feed URLs & Baselines → Item Count |
| Feed format (XML/CSV) and field coverage | `CLIENT_CONFIG.md` → Feed URLs & Baselines → Format |
| Structured data types found (Product, BreadcrumbList, etc.) | `CLIENT_CONFIG.md` → Platform Specifics (new row if needed) |
| Product ID format from feed/structured data | `CLIENT_CONFIG.md` → Product Types & SKU Structure |

**Then:** Create FND files for any issues found. Record Phase 0 status.

### Step 2: Phase 1 -- Browser-Side Verification

**Access required:** Chrome DevTools MCP (remote debugging on port 9222)

**MANDATORY FIRST STEP — Clear browser state:**

1. **Navigate** to production domain using `navigate_page`
2. **Run** `scripts/browser/clear-browser-state.js` via `evaluate_script` — clears cookies, localStorage, sessionStorage, IndexedDB, Cache Storage, service workers
3. **Navigate** to production domain AGAIN (reload with clean state)

Without this step, stale consent cookies will make consent testing invalid. Repeat this clear step before testing each country domain and before consent rejection tests (Test 6).

**Then run these browser scripts via `evaluate_script`:**

4. **Discover Cookie Banner** (`scripts/browser/discover-cookie-banner.js`)
   - Find CMP type, banner elements, button selectors
   - Do NOT hardcode selectors -- use discovered ones

5. **Validate Consent State** (`scripts/browser/validate-consent-state.js`)
   - Check default consent state (should be `denied` for EU)
   - Test consent updates after interaction
   - Verify consent persistence across page loads

6. **Discover Tracking Domains** (`scripts/browser/discover-tracking-domains.js`)
   - Enumerate all third-party tracking domains loaded
   - Identify any non-GTM tracking scripts

7. **Discover Non-GTM Tracking** (`scripts/browser/discover-non-gtm-tracking.js`)
   - Find hardcoded tracking scripts bypassing GTM/consent

8. **Discover JS Errors** (`scripts/browser/discover-js-errors.js`)
   - Check console for GTM/GA4/Meta-related errors

9. **Validate DataLayer** (`scripts/browser/validate-datalayer.js`)
   - Check `window.dataLayer` structure
   - Validate event names, parameter completeness

10. **Validate FB Pixel** (`scripts/browser/validate-fb-pixel.js`)
    - Check Meta Pixel initialization and events

11. **Event Funnel Check** (`scripts/browser/event-funnel-check.js`)
    - Verify expected e-commerce events fire in sequence

12. **GCS Parameter Check** (`scripts/browser/gcs-parameter-check.js`)
    - Check Google Consent Signals parameters

13. **Network Capture** using `list_network_requests`
    - Filter for tracking domains (google-analytics.com, facebook.com, googleads.g.doubleclick.net, etc.)
    - Capture pre-interaction and post-interaction states

14. **Screenshots** using `take_screenshot`
    - Capture consent banner state
    - Capture any visual errors

**After Phase 1 — Auto-Populate Config:**

Update `CLIENT_CONFIG.md` and `ACCESS_REGISTRY.md` with Phase 1 discoveries:

| What Was Discovered | Write To |
|-------------------|----------|
| **CMP type** (Cookiebot, CookieYes, OneTrust, Amasty, etc.) | `CLIENT_CONFIG.md` → CMP Configuration → CMP Type |
| **Consent cookie name** and default state | `CLIENT_CONFIG.md` → Consent type mapping |
| **Meta Pixel ID(s)** found on page | `ACCESS_REGISTRY.md` → Meta → Pixel ID |
| **GA4 Measurement ID** (`G-XXXXXXX`) from network requests | `ACCESS_REGISTRY.md` → Google → GA4 |
| **Google Ads Conversion ID** from network requests | `ACCESS_REGISTRY.md` → Google → Google Ads |
| **GTM Container ID** from page source | `ACCESS_REGISTRY.md` → Google → GTM (verify matches config) |
| **ESP/Email scripts** (Klaviyo JS, Mailchimp, HubSpot tracking, etc.) | `ACCESS_REGISTRY.md` → Email / ESP table |
| **Other tracking platforms** (Hotjar, Clarity, Criteo, TikTok, Pinterest, etc.) | `ACCESS_REGISTRY.md` → Other Platforms table |
| **Non-GTM tracking scripts** found | `ACCESS_REGISTRY.md` → Other Platforms (flag as "bypasses GTM") |
| **Tracking domains** discovered | `CLIENT_CONFIG.md` → new section or notes |
| **DataLayer event names** found | `CLIENT_CONFIG.md` → Platform Specifics notes |
| **E-commerce platform** signals (Magento, Shopify, WooCommerce indicators) | `CLIENT_CONFIG.md` → platform / platform_version |

**How to auto-populate:**

1. After running all Phase 1 discover scripts, collect results into a structured summary
2. For each discovered item, check if it already exists in the config/registry
3. If missing: add it with source noted as "Phase 1 discovery — {date}"
4. If different from what's in config: flag as discrepancy — create a FND finding
5. Log all auto-populated fields in the audit phase1 log

**Important:** Discovery populates what's OBSERVABLE from the browser. It cannot discover:
- Account names, access levels, or who granted access (human input needed)
- API keys or tokens (must be provided by client)
- Backend platform details (version, modules, database config)
- Feed management tool accounts (only feed URLs are observable)

**Then:** Create FND files for all issues. Update audit progress.

### Step 3: Phase 2 -- Platform Dashboard Verification

**Access required:** Read-only platform logins

If platform access is available, verify:

1. **GA4 Property**
   - Realtime report: events arriving?
   - DebugView: parameter quality?
   - E-commerce reports: revenue tracking?

2. **Meta Events Manager**
   - Event quality score
   - Parameter completeness
   - Deduplication status (browser vs server)

3. **Google Ads**
   - Conversion actions: recording?
   - Enhanced conversions: status?

4. **Google Merchant Center**
   - Feed processing status
   - Disapproved products count
   - Data quality issues

If access is NOT available: document what is blocked, skip to Phase 3.

### Step 4: Phase 3 -- Container Audit

**Access required:** GTM editor access or JSON exports in `clients/{slug}/data/gtm-exports/`

1. **Check for GTM exports** in `clients/{slug}/data/gtm-exports/`

2. **Run analysis scripts from `scripts/analysis/`:**

   ```bash
   python3 scripts/analysis/gtm-tag-inventory.py clients/{slug}/data/gtm-exports/{file}.json
   ```
   - Full tag inventory with consent settings
   - Output to `phase3/tag-inventory.log`

   ```bash
   python3 scripts/analysis/gtm-consent-audit.py clients/{slug}/data/gtm-exports/{file}.json
   ```
   - Consent configuration audit per tag
   - Output to `phase3/consent-audit.log`

   ```bash
   python3 scripts/analysis/gtm-disableAutoConfig.py clients/{slug}/data/gtm-exports/{file}.json
   ```
   - Check GA4 config tag `disableAutoConfig` settings
   - Output to `phase3/disable-autoconfig.log`

3. **Manual checks:**
   - Trigger hygiene (naming conventions, unused triggers)
   - Variable naming conventions
   - Tag firing sequence
   - Custom HTML tags (security review)

If GTM exports are NOT available: document what is blocked, skip to Phase 4.

### Step 5: Phase 4 -- Cross-Verification

**Access required:** All of the above

1. **Select 10 test products** from CLIENT_CONFIG.md

2. **For each product, trace the full pipeline:**
   - Page load: structured data, dataLayer push
   - Add to cart: dataLayer event, network request, SGTM receipt
   - Checkout: dataLayer events, consent state
   - Purchase (if testable): conversion event, platform receipt

3. **SGTM Tag Response Validation (MANDATORY):**
   If SGTM preview access is available, verify that every SGTM tag **succeeds** — not just fires:
   - Open SGTM Preview mode
   - Fire key events: `page_view`, `view_item`, `add_to_cart`, `begin_checkout`, `purchase`
   - For each event, check every fired tag's `ResponseStatusCode` (must be 2xx)
   - Check tag parameters (`value`, `currency`, `content_ids`, user data) resolved to real values (not `undefined`)
   - Check response body for error messages (Meta: `error_subcode`, Google: error responses)
   - See `methodology/KNOWN_PATTERNS.md` → PAT-032 (undefined value/currency) and PAT-033 (response errors not monitored)
   - Create Critical findings for any non-2xx response, High findings for undefined parameters

5. **Run cross-format consistency check:**
   ```javascript
   // scripts/browser/cross-format-consistency.js
   ```
   - Compare product IDs across: page, dataLayer, network, feed, platform

6. **Run schema validation:**
   ```javascript
   // scripts/browser/validate-schema-vs-page.js
   // scripts/browser/schema-errors.js
   // scripts/browser/schema-dedup-audit.js
   ```

7. **Document discrepancies** as FND files with cross-system evidence

### Step 6: Phase 5 -- Diagnosis

**Access required:** Analysis complete from Phases 0-4

1. **Load** `methodology/KNOWN_PATTERNS.md` (if it exists)
2. **Match findings** against known patterns
3. **Identify root causes** -- findings often share a root cause
4. **Generate recommendations** (REC files) for each finding or finding cluster
5. **Prioritize** recommendations: P0 (data loss/compliance) > P1 (significant gap) > P2 (improvement) > P3 (nice-to-have)

### Step 7: Generate Report

1. **Create** `clients/{slug}/audits/YYYY-MM-DD_audit/AUDIT_REPORT.md` from template
2. **Populate:**
   - Executive summary with overall RED/YELLOW/GREEN status
   - All findings listed with severity
   - All recommendations listed with priority
   - Pass/fail matrix per country
   - Next steps

## Output Files

For each run, this skill produces:

| File | Location |
|------|----------|
| Phase logs | `clients/{slug}/audits/YYYY-MM-DD_audit/phase{N}/` |
| Findings | `clients/{slug}/findings/FND-{NNN}_{description}.md` |
| Recommendations | `clients/{slug}/recommendations/REC-{NNN}_{description}.md` |
| Audit report | `clients/{slug}/audits/YYYY-MM-DD_audit/AUDIT_REPORT.md` |
| Screenshots | `clients/{slug}/data/screenshots/` |

## Error Handling

- **Script fails:** Log the error, note which check was skipped, continue with remaining checks. Create a finding noting the script failure if it indicates an issue (e.g., SGTM unreachable = finding).
- **Access denied:** Document in audit report which phases were blocked and why. Do NOT skip findings from available phases.
- **Chrome DevTools not connected:** Stop Phase 1+, complete Phase 0 only, report connection issue.
- **No GTM exports:** Skip Phase 3 container analysis, note in report. Recommend client provides exports.

## Integration

```
/audit {slug}          -- This skill (full audit)
/consent-check {slug}  -- Focused consent verification (subset of Phase 1)
/feed-audit {slug}     -- Focused feed check (subset of Phase 0)
/sgtm-diagnose {slug}  -- Focused SGTM diagnosis (subset of Phase 0 + 2)
/gtm-audit {slug}      -- Focused container audit (subset of Phase 3)
/analyze-gtm {slug}    -- GTM JSON deep analysis
/plan-gtm {slug}       -- GTM remediation planning
```

## Notes

- Never skip phases. If access is unavailable, document and move on.
- Finding numbers are per-client, sequential, never reused.
- Always cross-reference findings with recommendations.
- The discover-first principle applies at every step: never hardcode selectors, URLs, or element text.
- Large feeds (>5MB XML) should be analyzed with CLI scripts, not loaded into memory.

---

**Version:** 1.1
**Created:** 2026-03-07
**Updated:** 2026-03-07
**Author:** Measurement Audit Platform
