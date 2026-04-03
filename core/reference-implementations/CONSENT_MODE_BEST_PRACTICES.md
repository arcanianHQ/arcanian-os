---
name: Consent Mode v2 — GTM Best Practices
description: CMP setup rules for GTM consent — Google Tag MUST be NOT_NEEDED (double-gating kills attribution), CookieYes NOT_NEEDED, event tags require consent
type: reference-implementation
source_client: ExampleAuto (learned from), ExampleRetail (gold standard)
source_date: 2026-04-01
applies_to: ALL clients using CookieYes + GTM + Consent Mode v2
---

# Consent Mode v2 — GTM Best Practices

> These rules apply to every client GTM container. Violations cause 100% Direct attribution, CookieYes audit failures, GDPR risk, and broken TAGGRS consent analytics.
>
> **RULE 0 IS THE MOST CRITICAL RULE. It caused 100% Direct attribution on ExampleAuto for 10+ days. Violating it silently kills all campaign attribution.**

---

## Rule 0: Google Tag (googtag) MUST be NOT_NEEDED — CRITICAL

**The Google Tag and Google Ads Tag must have consent = `NOT_NEEDED`.**

This is the single most important consent rule. Getting this wrong silently destroys ALL campaign attribution (UTM, gclid, fbclid) with no errors, no warnings.

### What happens when you set Google Tag consent to NEEDED (WRONG)

1. New visitor arrives via Facebook/Google ad (UTMs in URL)
2. CookieYes sets consent defaults to `denied` (correct)
3. Google Tag requires `analytics_storage` → **GTM blocks the tag entirely**
4. `gtag.js` never loads → no `page_view` sent → GA4 has zero data for this visitor
5. User browses, adds to cart, goes to checkout
6. User accepts cookies → consent becomes `granted`
7. GTM fires the Google Tag NOW — but it's too late: the original URL with UTMs is gone
8. GA4 records the session start without campaign data → **attributed as Direct**
9. Purchase fires → attributed to the Direct session
10. **Result: 100% of conversions show as Direct**

### What happens when you set Google Tag consent to NOT_NEEDED (CORRECT)

1. New visitor arrives via Facebook/Google ad (UTMs in URL)
2. CookieYes sets consent defaults to `denied` (correct)
3. Google Tag has consent NOT_NEEDED → **fires immediately**
4. `gtag.js` loads, reads consent state → sees `denied`
5. Sends a **cookieless ping** to GA4 with `gcs=G100` (denied) — includes `dl` with full UTM URL
6. GA4 records: new session, source = `test_final / cpc`, campaign = `debug_consent_fix` — **even without cookies**
7. User accepts cookies → Google Tag sends `gcs=G111` (granted) → full data with cookies
8. Purchase fires → correctly attributed to the original campaign
9. **Result: proper multi-touch attribution**

### The key insight

**The Google Tag has built-in Consent Mode v2.** It handles consent internally:
- `gcs=G100` → cookieless ping (limited data, no cookies, but records campaign source)
- `gcs=G111` → full data with cookies

Adding GTM-level consent gating (`consentStatus: NEEDED`) on TOP of this creates a **double-gate** where the tag never loads at all. The built-in consent mode never gets a chance to work.

### ExampleRetail gold standard (confirmed working)

```
GA4 - GT - Server Sending (ID: 294) → consent: NOT_NEEDED ✅
Google Ads Tag (ID: 252) → consent: NOT_NEEDED ✅
GA4 - Basic web sending (ID: 357) → consent: NOT_NEEDED ✅
```

### ExampleAuto (was broken, now fixed)

```
01.00 GA4 - Page View (ID: 16) → was: NEEDED (analytics_storage) ❌ → fixed to: NOT_NEEDED ✅
```

### Evidence

- ExampleAuto showed 100% Direct attribution on ALL 13 conversions (March 30 - April 2)
- Clean browser test with `NEEDED`: zero GA4 requests before cookie accept, `gtag` function never existed
- Clean browser test with `NOT_NEEDED`: GA4 fires immediately with `gcs=G100`, UTMs in `dl`, session starts correctly
- GA4 Real-time confirmed `test_final / cpc` as source after fix

---

## Rule 1: CMP Tag MUST be NOT_NEEDED

The CMP tag (CookieYes, Cookiebot, OneTrust, etc.) is the tag that **sets** consent state. It cannot require consent to fire — that's a chicken-and-egg deadlock.

| Setting | Correct | Wrong |
|---------|---------|-------|
| CMP tag consent | **NOT_NEEDED** | NEEDED (any type) |
| CMP tag trigger | **Consent Initialization** | All Pages |

**Why Consent Initialization trigger:** This is the earliest trigger in GTM — fires before All Pages, before DOM Ready, before any other tag. The CMP must set consent defaults before anything else runs.

**Why NOT_NEEDED:** The CMP tag is infrastructure, not a tracking tag. It doesn't send data to third parties — it configures the consent state that all other tags check. Requiring consent on the consent-setter creates a deadlock where:
- New visitor arrives → all consent = denied (default)
- CMP needs `functionality_storage` to fire → but that's denied
- CMP never fires → consent defaults never update → everything stays denied OR falls through

### ExampleAuto bug (2026-04-01)

CookieYes CMP tag had `consentStatus: NEEDED, consentType: functionality_storage`. CookieYes still worked because its script also loads directly in HTML (outside GTM), but the GTM-side consent integration was broken — GTM never received proper consent defaults, causing CookieYes audit to flag "late consent checking" on all pages.

---

## Rule 2: Event tags MUST require consent, but Google Tag / Google Ads Tag MUST NOT

There are two categories of tags with opposite consent rules:

### Tags that MUST be NOT_NEEDED (infrastructure tags)

| Tag type | Consent | Why |
|----------|---------|-----|
| **Google Tag (googtag)** | **`NOT_NEEDED`** | Has built-in Consent Mode v2. Double-gating kills attribution. See Rule 0. |
| **Google Ads Tag** | **`NOT_NEEDED`** | Same as Google Tag — built-in consent handling |
| **CMP tag (CookieYes)** | **`NOT_NEEDED`** | Sets consent state. See Rule 1. |
| **Stape Data Tag** | **`NOT_NEEDED`** | See Rule 3 |
| **TAGGRS tracking tag** | **`NOT_NEEDED`** | See TAGGRS_BENCHMARK_EXAMPLE.md |

### Tags that MUST require consent (event/pixel tags)

| Tag type | Required consent | Examples |
|----------|-----------------|----------|
| GA4 event tags (non-googtag) | `analytics_storage` | view_item, add_to_cart, purchase |
| Facebook Pixel (all events) | `ad_storage` | PageView, ViewContent, Purchase |
| Google Ads Conversion Linker | `ad_storage` | Conversion tracking |
| TikTok | `ad_storage` | All pixel events |
| Barion | `ad_storage` or `functionality_storage` | Payment tracking |

### What "NEEDED" does in GTM

When a tag has `consentStatus: NEEDED` with a consent type:
1. GTM checks the current consent state for that type
2. If `granted` → tag fires normally
3. If `denied` → tag is **queued** and waits for consent to be granted
4. If user accepts cookies → CMP updates consent → queued tags fire
5. If user rejects or ignores → queued tags never fire

This is exactly the behavior we want for tracking tags. Without consent gating, tags fire immediately on page load regardless of user choice → GDPR violation.

---

## Rule 3: Stape Data Tag — NOT_NEEDED (intentional)

The Stape Data Tag has `consentStatus: NOT_NEEDED` because:

1. It sends data to **our own sGTM server** (first-party), not directly to ad platforms
2. The **sGTM CAPI tags** check consent server-side (`adStorageConsent: required`)
3. If we gate the Data Tag on consent, non-consented users' events never reach sGTM → no server-side processing at all
4. The Data Tag includes `add_consent_state: true` → sGTM receives the consent state and can act on it

**The consent decision happens server-side, not client-side.** This maximizes CAPI coverage while maintaining consent compliance.

---

## Rule 4: Loading order in HTML

The ideal script loading order in the page HTML:

```
1. CookieYes script (cdn-cookieyes.com/client_data/.../script.js)
2. GTM script (googletagmanager.com/gtm.js)
3. Everything else (loaded by GTM with consent gating)
```

**Problem scripts** (WordPress plugins that inject outside GTM):
- TikTok for Business WP plugin → fires pre-consent
- Barion WP plugin → fires pre-consent
- Facebook for WooCommerce plugin → fires pre-consent

**Fix:** Deactivate WP plugins, move tracking to GTM with proper consent gating. If client won't deactivate (budget/priority), document as accepted GDPR risk.

**If CookieYes must load after GTM** (e.g., WP plugin ordering can't be changed): The CookieYes GTM template handles this by setting consent defaults to `denied` on Consent Initialization, before any other tags fire. This is safe as long as Rule 1 is followed (CMP tag = NOT_NEEDED on Consent Init trigger).

---

## Rule 5: Google Tag consent defaults

The Google Tag (gtag.js) supports built-in consent default configuration. When using CookieYes GTM template, this is handled automatically — CookieYes sets:

```javascript
gtag('consent', 'default', {
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  analytics_storage: 'denied',
  functionality_storage: 'denied',
  personalization_storage: 'denied',
  security_storage: 'granted',
  wait_for_update: 2000  // ms to wait for CMP to load
});
```

**Verify this is working:** In browser network tab, the first GA4 `collect` request should show `gcs=G100` (all denied) for a new visitor who hasn't interacted with the cookie banner. After accepting, subsequent requests show `gcs=G111` (all granted).

If `gcs=G111` appears on the very first request for a new visitor, consent defaults are not set correctly.

---

## Verification Checklist

After setting up consent in a new client GTM:

**Critical (do first — attribution depends on these):**
- [ ] **Google Tag (googtag) consent = NOT_NEEDED** ← most important
- [ ] **Google Ads Tag consent = NOT_NEEDED**
- [ ] CMP tag fires on Consent Initialization with NOT_NEEDED
- [ ] New visitor (clean browser, no cookies): GA4 request fires BEFORE cookie accept with `gcs=G100`
- [ ] The `dl` parameter in that request contains the full URL with UTMs
- [ ] GA4 Real-time shows correct source/medium for the test visit

**Standard (consent gating):**
- [ ] GA4 event tags (view_item, purchase etc.) require `analytics_storage`
- [ ] All FB/Meta tags require `ad_storage`
- [ ] Google Ads Conversion Linker requires `ad_storage`
- [ ] Stape Data Tag is NOT_NEEDED with `add_consent_state: true`
- [ ] TAGGRS tag is NOT_NEEDED (see TAGGRS_BENCHMARK_EXAMPLE.md)

**Validation (check after deploy):**
- [ ] After accepting cookies: GA4 requests show `gcs=G111`
- [ ] TAGGRS Consent Approvals shows realistic split (~60/40, not 100/0)
- [ ] CookieYes audit passes (no "late consent checking" from GTM tags)
- [ ] No WP plugins firing pre-consent (TikTok, Barion, FB for WooCommerce)
- [ ] Payment gateway domain in referral exclusion (e.g. barion.com)

---

## Anti-Patterns

| Mistake | Effect | Severity | Seen in |
|---------|--------|----------|---------|
| **Google Tag consent = NEEDED** | **100% Direct attribution — ALL campaign data lost** | **CRITICAL** | **ExampleAuto (10+ days)** |
| CMP tag consent = NEEDED | CMP can't set defaults → consent never initializes properly | High | ExampleAuto |
| No consent on GA4/FB event tags | Tags fire regardless of user choice → GDPR violation | High | — |
| Stape Data Tag consent = NEEDED | Non-consented events never reach sGTM → reduced CAPI coverage | Medium | — |
| WP plugins loading before CookieYes | Pre-consent tracking → CookieYes audit flags "late consent" | Medium | ExampleAuto (TikTok, Barion) |

---

*Extracted from ExampleAuto debugging session 2026-04-01. Applies to all clients.*
