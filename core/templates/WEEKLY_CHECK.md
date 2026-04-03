---
client: "{client}"
week: "YYYY-Www"
date: "YYYY-MM-DD"
auditor: ""
---
> v1.0 — 2026-04-03

# {Client Name} — Weekly Check

**Week:** YYYY-Www
**Date:** YYYY-MM-DD
**Auditor:**

---

## Phase 0 — CLI Baseline Checks

### SGTM Health

- [ ] SGTM endpoint responding (HU): `curl -I https://sgtm.example.hu`
  - Status:
  - Response time:
- [ ] SGTM endpoint responding (RO): `curl -I https://sgtm.example.ro`
  - Status:
  - Response time:

### Feed Item Counts

| Country | Feed URL | Expected Count | Actual Count | Delta | Status |
|---------|----------|---------------|-------------|-------|--------|
| HU | | | | | OK / DRIFT |
| RO | | | | | OK / DRIFT |

### Pixel Status

- [ ] Meta Pixel active (HU): Last event received < 24h ago
- [ ] Meta Pixel active (RO): Last event received < 24h ago

---

## Phase 2 — Match Rate & Conversion Checks

### Meta Ads

| Country | Event | 7-day count | Match rate | Status |
|---------|-------|------------|------------|--------|
| HU | PageView | | | |
| HU | ViewContent | | | |
| HU | AddToCart | | | |
| HU | Purchase | | | |
| RO | PageView | | | |
| RO | ViewContent | | | |
| RO | AddToCart | | | |
| RO | Purchase | | | |

### GA4

| Country | Event | 7-day count | Status |
|---------|-------|------------|--------|
| HU | page_view | | |
| HU | view_item | | |
| HU | add_to_cart | | |
| HU | purchase | | |
| RO | page_view | | |
| RO | view_item | | |
| RO | add_to_cart | | |
| RO | purchase | | |

### Google Ads Conversions

| Country | Conversion Action | Status | Last Conversion | Notes |
|---------|------------------|--------|----------------|-------|
| HU | Purchase | Recording / No recent | | |
| RO | Purchase | Recording / No recent | | |

### Enhanced Conversions

| Country | Platform | Match Rate | Status |
|---------|----------|-----------|--------|
| HU | Google Ads | | OK / LOW / ZERO |
| RO | Google Ads | | OK / LOW / ZERO |

### Feed Quality

| Country | Total Items | Active Items | Disapproved | Warnings | Notes |
|---------|------------|-------------|-------------|----------|-------|
| HU | | | | | |
| RO | | | | | |

---

## Quick Browser Checks

> Open site in Chrome with Tag Assistant + Meta Pixel Helper active.

### Homepage

- [ ] GTM container loaded
- [ ] Consent banner appears (no prior consent)
- [ ] Default consent state = denied (check dataLayer)
- [ ] No tracking fires before consent grant
- [ ] After consent: PageView fires to GA4
- [ ] After consent: PageView fires to Meta

### Product Page (test product: ________________)

- [ ] `view_item` / `ViewContent` fires after consent
- [ ] Product ID matches feed format
- [ ] Price is correct (incl. currency)
- [ ] Content type = `product`
- [ ] No duplicate events

### Add to Cart

- [ ] `add_to_cart` / `AddToCart` fires
- [ ] Product ID, quantity, price correct
- [ ] No duplicate events

### Checkout / Purchase

- [ ] Test order placed (or check recent real orders)
- [ ] `purchase` / `Purchase` fires
- [ ] Transaction ID present and unique
- [ ] Revenue matches order total
- [ ] Product IDs in purchase match feed IDs
- [ ] Enhanced Conversions data present (hashed email/phone)
- [ ] No duplicate purchase events

### Consent Behavior

- [ ] Rejecting consent: no analytics/marketing tags fire
- [ ] Accepting consent: all tags fire with correct consent state
- [ ] Consent persists on page navigation
- [ ] Consent banner does not reappear after choice

---

## Issues Found

| # | Description | Severity | Phase | New / Known | Related |
|---|------------|----------|-------|-------------|---------|
| 1 | | critical / high / medium / low | 0-5 | New / Known (FND-XXX) | |
| 2 | | | | | |
| 3 | | | | | |

## Actions Taken

| # | Action | Result |
|---|--------|--------|
| 1 | | |
| 2 | | |

## Notes

<!-- Any observations, questions for the client, things to follow up on -->

---

## Summary

**Overall status this week:** GREEN / YELLOW / RED

**Key changes since last week:**
-

**Follow-up needed:**
-

---

**Template version:** 1.0
**Last updated:** 2026-03-07
