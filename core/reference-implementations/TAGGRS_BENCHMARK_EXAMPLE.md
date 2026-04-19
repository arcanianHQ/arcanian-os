---
scope: shared
name: TAGGRS Configuration Benchmark (ExampleRetail Gold Standard)
description: Reference implementation of TAGGRS tracking tags in Web GTM and sGTM — extracted from ExampleRetail production setup (GTM-EXAMPLE-001-001 ws296, GTM-EXAMPLE-001-002 ws118)
type: reference-implementation
source_client: ExampleRetail
source_date: 2026-04-01
containers:
  web_gtm: GTM-EXAMPLE-001-001 (workspace 296)
  sgtm: GTM-EXAMPLE-001-002 (workspace 118)
  taggrs_container: "{{Taggrs Container ID}}" variable
---
> v1.0 — 2026-04-03

# TAGGRS Configuration Benchmark — ExampleRetail Gold Standard

> Every new client sGTM setup MUST match this configuration for TAGGRS analytics to work correctly (Server vs Client chart, Consent Approvals, event tracking).

---

## 1. Web GTM — TAGGRS Event Tracking Tag

**Purpose:** Client-side TAGGRS tag that sends event data to TAGGRS analytics from the browser. This is what populates the "Client-side" line in TAGGRS Server vs Client Analytics.

| Setting | Value | Notes |
|---------|-------|-------|
| **Tag name** | `Taggers Event Tracking Tag` | ID 304 in ExampleRetail |
| **Tag type** | `cvt_1676017_302` (TAGGRS community template) | Template version may differ per container |
| **Consent** | **`NOT_NEEDED`** | CRITICAL — must fire for ALL visitors regardless of consent state. This is how TAGGRS sees both granted AND denied events. If set to NEEDED, only consented users fire → 100% approval (wrong). |
| **`event_name`** | `{{Event}}` | Passes the GTM event name (page_view, add_to_cart, purchase, etc.) |
| **`container_id`** | `{{Taggrs Container ID}}` | Use a variable, not hardcoded. Easier to manage across workspaces. |
| **Trigger** | **All Events** — Custom Event, regex `.*` | Must fire on EVERY dataLayer push, not just All Pages. This captures all event types (page_view, view_item, add_to_cart, purchase, etc.) |
| **Blocking triggers** | None | |

### Why NOT_NEEDED is correct here

The TAGGRS tag is an **analytics/monitoring tag** — it feeds TAGGRS's own dashboard (Server vs Client, Consent Approvals). It does NOT send data to Google or Meta. For TAGGRS to accurately report consent distribution, it must see ALL events, including those from users who denied consent. The actual ad-platform consent gating happens on the Stape Data Tag and sGTM CAPI tags.

### Why "All Events" trigger is required

If the trigger is only "All Pages" (pageview), TAGGRS only sees page_view events. The Server vs Client chart will show 0 for all other event types, and the Consent Approvals filtered by purchase/add_to_cart will have minimal data.

---

## 2. sGTM — TAGGRS Tracking Tag (Server-Side)

**Purpose:** Server-side TAGGRS tag that sends event data to TAGGRS analytics from the sGTM server. This populates the "Server-side" line in TAGGRS Server vs Client Analytics.

| Setting | Value | Notes |
|---------|-------|-------|
| **Tag name** | `TAGGRS tracking tag - server side` | ID 16 in ExampleRetail |
| **Tag type** | `cvt_182493885_15` (TAGGRS sGTM template) | Template version may differ |
| **Consent** | **`NOT_SET`** | No consent gating on server side — sGTM receives events that already passed client-side consent checks. |
| **`event_name`** | `{{Event Name}}` | Server-side Event Name variable (built-in) |
| **`container_id`** | `{{Taggrs Container ID}}` | Same variable pattern as web side |
| **Trigger** | **Client Name = GA4** (type: ALWAYS with filter) | Fires on ALL events received by the GA4 Client. NOT just page_view. |
| **Blocking triggers** | None | |

### Trigger configuration detail

```
Trigger type: ALWAYS
Filter: Client Name EQUALS "GA4"
```

This means the TAGGRS sGTM tag fires on every event the GA4 Client claims (page_view, view_item, add_to_cart, begin_checkout, purchase, scroll, etc.). It does NOT fire on Data Client events — this avoids double-counting since Data Client events go to Meta CAPI, not TAGGRS.

### Why NOT on Data Client

The Data Client (Stape) handles Meta CAPI traffic. TAGGRS analytics should track GA4 pipeline only — the Server vs Client comparison is GA4 client-side vs GA4 server-side. Mixing in Data Client events would inflate the server-side number.

---

## 3. Supporting Infrastructure

### GA4 Client (sGTM)

| Setting | Value |
|---------|-------|
| Cookie management | `server` |
| Cookie name | `FPID` |
| Cookie domain | `auto` |
| Cookie max age | `63072000` (2 years) |
| Response compression | `true` |
| Gtag support | `true` |
| Dependency serving | `true` |
| Default paths | `true` |
| Measurement ID filter | `{{GA4 - MeasurementID - HU}}` (per-market variable) |

### Data Client (Stape) — sGTM

| Setting | Value |
|---------|-------|
| Response status code | `200` |
| Generate client ID | `true` |
| Prolong cookies | `true` |
| Response body | `timestamp` |
| Expose FPID cookie | `false` |

---

## 4. Common Mistakes (Anti-Patterns)

| Mistake | Effect | Seen in |
|---------|--------|---------|
| Web TAGGRS tag consent = `NEEDED` | Only consented users fire → 100% approval, no denied data | ExampleAuto |
| Web TAGGRS trigger = All Pages only | Only page_view events tracked → 0 for purchase, add_to_cart | ExampleAuto |
| Missing `event_name` parameter | TAGGRS can't categorize events by type | ExampleAuto |
| sGTM TAGGRS trigger = All Pages | Same as above, server-side — misses all non-pageview events | ExampleAuto |
| sGTM TAGGRS trigger on Data Client | Double-counts Meta CAPI events as GA4 server-side | — |
| Hardcoded container_id | Works but harder to manage — use a variable | ExampleAuto (minor) |

---

## 5. Verification Checklist

After configuring TAGGRS tags, verify in TAGGRS dashboard (app.taggrs.io):

- [ ] **Server vs Client Analytics** (page_view): both lines show traffic, server > client by 15-25%
- [ ] **Server vs Client Analytics** (purchase): both lines show data on purchase days
- [ ] **Consent Approvals** (page_view): granted ~55-70%, denied ~30-45% (varies by market/CMP)
- [ ] **Consent Approvals** (purchase): higher granted % is normal (buyers tend to accept cookies)
- [ ] **"Denied By Default"** appears in tooltip — proves Consent Mode v2 default-denied state is reaching TAGGRS
- [ ] Event type dropdown has all event types (not just page_view)

---

## 6. ExampleRetail Production Numbers (Benchmark)

As of 2026-04-01 (Mar 25 – Apr 1 range):

| Metric | Value |
|--------|-------|
| Server vs Client difference | +22.3% server-side uplift |
| Daily page_views | 50,000 – 70,000 |
| Consent granted (page_view) | ~60% |
| Consent denied (page_view) | ~40% |
| Consent granted (purchase) | Higher (buyers accept cookies) |

---

*Extracted from ExampleRetail production containers 2026-04-01. Use as the baseline for all new client TAGGRS setups.*
