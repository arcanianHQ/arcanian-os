> v1.0 — 2026-03-24

# [Audit Framework] Evidence Standard

> Every audit step must be reproducible. Every claim must have timestamped evidence.
> "If it's not logged with timestamp + screenshot + network capture, it didn't happen."

---

## The Rule

During any measurement audit phase (0-5), the system MUST:
1. **Log every action** with timestamp
2. **Capture browser state** via Chrome DevTools MCP
3. **Store relevant network traffic** (tracking requests, consent state, dataLayer)
4. **Screenshot key states** (before consent, after consent, after action)

## Evidence Storage

```
clients/{slug}/audit/evidence/
├── AUDIT_LOG.md                          ← Timestamped log of ALL actions
├── {date}_phase{N}/
│   ├── screenshots/
│   │   ├── {timestamp}_homepage_clean_state.png
│   │   ├── {timestamp}_consent_banner.png
│   │   ├── {timestamp}_after_consent.png
│   │   ├── {timestamp}_product_page.png
│   │   └── {timestamp}_add_to_cart.png
│   ├── network/
│   │   ├── {timestamp}_all_requests.json
│   │   ├── {timestamp}_tracking_requests.json
│   │   ├── {timestamp}_consent_state.json
│   │   └── {timestamp}_datalayer_snapshot.json
│   ├── console/
│   │   ├── {timestamp}_console_messages.json
│   │   └── {timestamp}_js_errors.json
│   └── state/
│       ├── {timestamp}_cookies.json
│       ├── {timestamp}_localstorage.json
│       └── {timestamp}_sessionstorage.json
```

## AUDIT_LOG.md Format

```markdown
> v1.0 — {date}

# Audit Evidence Log — {Client}

| # | Timestamp | Phase | Action | Result | Evidence files |
|---|---|---|---|---|---|
| 1 | 2026-03-24T10:15:00 | 1 | Clear browser state | Clean: 0 cookies, 0 localStorage | state/10-15-00_cookies.json |
| 2 | 2026-03-24T10:15:30 | 1 | Navigate to homepage | Loaded in 2.3s | screenshots/10-15-30_homepage.png |
| 3 | 2026-03-24T10:15:45 | 1 | Check cookies BEFORE consent | 7 cookies found (⚠ GDPR) | state/10-15-45_cookies.json |
| 4 | 2026-03-24T10:16:00 | 1 | Screenshot consent banner | Banner visible, defaults denied | screenshots/10-16-00_consent.png |
| 5 | 2026-03-24T10:16:15 | 1 | Capture ALL network requests | 45 requests, 12 tracking | network/10-16-15_all_requests.json |
| 6 | 2026-03-24T10:16:30 | 1 | Grant consent | gcs=G111 confirmed | network/10-16-30_consent_state.json |
| 7 | 2026-03-24T10:16:45 | 1 | Check cookies AFTER consent | 12 cookies now | state/10-16-45_cookies.json |
```

## Chrome DevTools MCP — Default Capture Sequence

For EVERY page during audit, run this sequence:

### 1. Before any interaction
```
chrome.clear_browser_state()           → log
chrome.navigate_page(url)              → log + screenshot
chrome.list_console_messages()         → save to console/
chrome.list_network_requests()         → save ALL to network/
chrome.evaluate_script("document.cookie")  → save to state/cookies.json
chrome.evaluate_script("JSON.stringify(localStorage)")  → save to state/
chrome.evaluate_script("JSON.stringify(sessionStorage)")  → save to state/
chrome.evaluate_script("JSON.stringify(dataLayer)")  → save to network/datalayer.json
chrome.take_screenshot()               → save to screenshots/
```

### 2. After consent grant
```
chrome.click(consent_button)           → log
chrome.list_network_requests()         → save (capture NEW requests fired by consent)
chrome.evaluate_script("document.cookie")  → save (compare: what cookies appeared?)
chrome.evaluate_script("JSON.stringify(dataLayer)")  → save (consent update event?)
chrome.take_screenshot()               → save
```

### 3. After user action (add to cart, purchase, etc.)
```
chrome.click(action_element)           → log
chrome.wait_for(network_idle)          → wait for tracking to fire
chrome.list_network_requests()         → save (capture tracking requests)
chrome.evaluate_script("JSON.stringify(dataLayer)")  → save (ecommerce event?)
chrome.take_screenshot()               → save
```

### 4. Network traffic filtering

From all captured requests, extract and store separately:
```
Tracking requests (store in tracking_requests.json):
- /g/collect (GA4)
- /collect? (UA legacy)
- facebook.com/tr (Meta Pixel)
- sst.{domain}/g/collect (sGTM)
- api.taggrs.io (TAGGRS)
- bat.bing.com (Bing)
- analytics.tiktok.com (TikTok)
- ct.pinterest.com (Pinterest)
- tr.snapchat.com (Snapchat)
```

## Per-Phase Evidence Requirements

| Phase | What to capture | Chrome DevTools? |
|---|---|---|
| **Phase 0 (CLI)** | curl responses, feed XML, robots.txt, DNS records | No — CLI only |
| **Phase 1 (Browser)** | **FULL evidence sequence** — every page, every action | YES — mandatory |
| **Phase 2 (Dashboards)** | Screenshots of platform UIs (Meta EM, GAds, GA4) | Screenshots only |
| **Phase 3 (Container)** | GTM JSON exports + inventory | No — JSON analysis |
| **Phase 4 (Cross-verify)** | **FULL evidence sequence** for 10 products | YES — mandatory |
| **Phase 5 (Diagnosis)** | References to evidence from phases 1-4 | No — analysis |

## Timestamp Format

All timestamps: `YYYY-MM-DDTHH:MM:SS` (ISO 8601)
File naming: `HH-MM-SS_{description}` (colons → hyphens for filenames)

## Connection to Findings

Every finding (FND-NNN) MUST reference its evidence:
```markdown
## Evidence
- Screenshot: `audit/evidence/2026-03-24_phase1/screenshots/10-15-45_cookies_before_consent.png`
- Network: `audit/evidence/2026-03-24_phase1/network/10-15-45_tracking_requests.json`
- Cookie dump: `audit/evidence/2026-03-24_phase1/state/10-15-45_cookies.json`
```

Without evidence, a finding is an OPINION, not a FACT.

## Connection to Knowledge Flow

After audit, evidence patterns feed KNOWN_PATTERNS.md:
- New tracking domain discovered → add to tracking request filter list
- New consent banner type → add to CMP detection patterns
- New dataLayer structure → add to validation scripts
