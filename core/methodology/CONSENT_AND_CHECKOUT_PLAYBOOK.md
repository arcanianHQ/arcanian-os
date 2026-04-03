> v1.0 — 2026-03-24

# Consent & Checkout Playbook — Per-Client Documentation

> Every client's website has DIFFERENT consent banner behavior and checkout flow.
> Before running a measurement audit, document HOW to interact with these on THIS site.
> Without this, audit results are inconsistent and non-reproducible.

---

## The Problem

- Consent banners differ: CookieBot, Amasty, Unas native, CookieYes, custom
- Some default to "denied", some to "granted", some have no default
- Accept/deny button text varies: "Elfogadom" / "Összes elfogadása" / "Accept All" / "I Agree"
- Some consent banners don't actually block cookies (cosmetic only)
- Checkout flows differ: guest checkout, registered only, multi-step, single-page
- Some checkouts require real credentials (can't test without account)
- Purchase testing may require test products or staging environments

## What Must Be Documented Per Client

### In CLIENT_CONFIG.md → Add "Consent & Checkout" section:

```markdown
## Consent Management

| Field | Value |
|---|---|
| **CMP Platform** | (CookieBot / Amasty / Unas native / CookieYes / Custom / None) |
| **Default state** | denied / granted / unknown |
| **Accept all selector** | `button.accept-all` / `#cookie-accept` / text "Elfogadom" |
| **Deny all selector** | `button.deny` / `#cookie-reject` / text "Elutasítom" |
| **Settings selector** | (if granular options exist) |
| **Cookie name** | `CookieConsent` / `UN_cookie_consent_v2` / `cookieyes-consent` |
| **GCS parameter** | `gcs=G111` (all granted) / `gcs=G100` (analytics only) |
| **Blocks tracking before consent?** | YES / NO / PARTIALLY (cosmetic only) |
| **Test verified** | YYYY-MM-DD — by who |

## Checkout Flow

| Field | Value |
|---|---|
| **Platform** | Shopify / WooCommerce / Magento / Unas / Custom |
| **Guest checkout?** | YES / NO |
| **Test account available?** | YES (credentials in ACCESS_REGISTRY) / NO |
| **Staging environment?** | YES (URL) / NO |
| **Test product** | (product URL for safe test purchase) |
| **Checkout steps** | Cart → Shipping → Payment → Confirmation (list actual steps) |
| **Payment test method** | Test card / Utánvét / Free product / Staging only |
| **Purchase creates real order?** | YES (cancel after) / NO (staging) |
```

## Known CMP Patterns (from audits)

| CMP | Default | Accept selector | Cookie name | Notes |
|---|---|---|---|---|
| **CookieBot** | denied | `#CybotCookiebotDialogBodyLevelButtonLevelOptinAllowAll` | `CookieConsent` | Most reliable. GCS integration standard. |
| **Amasty (Magento)** | varies | `.amcookie-accept` | `amcookie` | ExampleRetail uses this. JS 404 errors common. |
| **Unas native** | denied | `button` with "Összes elfogadása" text | `UN_cookie_consent_v2` | ExampleLocal. Simple but consent gating often broken. |
| **CookieYes** | denied | `.cky-btn-accept` | `cookieyes-consent` | |
| **None** | granted (⚠) | — | — | GDPR violation if tracking active |

## Known Checkout Patterns

| Platform | Guest? | Steps | Test method |
|---|---|---|---|
| **Shopify** | Usually yes | Cart → Checkout (shipping + payment) → Thank you | Test product + utánvét or test card |
| **Unas** | Configurable | Cart → Login/Guest → Shipping → Payment → Confirm | Test product if available |
| **Magento** | Configurable | Cart → Shipping → Payment → Review → Confirm | Staging preferred |
| **WooCommerce** | Usually yes | Cart → Checkout (single page) → Thank you | Test product + COD |

## Audit Pre-Flight Checklist

Before Phase 1 (Browser Verification), confirm:

- [ ] CMP platform identified
- [ ] Accept/deny selectors documented in CLIENT_CONFIG.md
- [ ] Default consent state verified (clean browser test)
- [ ] Checkout flow documented (steps, guest vs registered)
- [ ] Test account available OR staging URL available OR test product identified
- [ ] Payment method for test purchase determined (won't charge real money)

If ANY of these is missing → can't start Phase 1. Document the blocker.

## Chrome DevTools Consent Test Sequence

```
# 1. Clean state
chrome.evaluate_script("document.cookie = ''")  → clear cookies
chrome.navigate_page(homepage)

# 2. Before consent
chrome.take_screenshot()  → "before_consent.png"
chrome.evaluate_script("document.cookie")  → save cookies (should be ZERO tracking)
chrome.list_network_requests()  → save (should be ZERO tracking requests)

# 3. Find and document the consent banner
chrome.take_screenshot()  → "consent_banner.png"
chrome.evaluate_script("document.querySelector('{accept_selector}').textContent")

# 4. DENY consent (test deny path first)
chrome.click("{deny_selector}")
chrome.evaluate_script("document.cookie")  → save (should still be ZERO tracking)
chrome.list_network_requests()  → save (no new tracking requests?)

# 5. Accept consent
chrome.navigate_page(homepage)  → fresh page
chrome.click("{accept_selector}")
chrome.evaluate_script("document.cookie")  → save (tracking cookies should appear NOW)
chrome.list_network_requests()  → save (GA4, Meta, etc. should fire NOW)

# 6. Verify GCS parameter
chrome.list_network_requests()  → filter for /g/collect → check gcs= parameter
```

## Connection to Findings

| Pattern | Finding if true |
|---|---|
| Tracking cookies before consent | FND: GDPR violation — cookies set pre-consent |
| Consent banner doesn't block tracking | FND: Cosmetic consent — tracking fires regardless |
| No deny option | FND: No opt-out mechanism |
| GCS not updating on consent change | FND: Consent Mode not functioning |
| Checkout can't be tested | Blocker: document in TASKS.md, escalate |
