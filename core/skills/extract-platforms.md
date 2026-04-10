---
scope: shared
---

# Skill: Extract Platforms (`/extract-platforms`)

## Purpose

Extracts all digital platform identifiers, domains, tracking IDs, and system references from correspondence, emails, meeting transcripts, audit notes, or any text input. Ensures they exist in the client's `DOMAIN_CHANNEL_MAP.md` and `CLIENT_CONFIG.md`.

**Core principle:** Every platform identifier that appears in project communication MUST be mapped. An unmapped GTM container is an analysis blind spot. An unmapped domain is a data leak.

## Trigger

Use when:
- User pastes or references an email, correspondence, or meeting transcript containing platform IDs
- User says `/extract-platforms`
- User says "extract tracking IDs", "update domain map", "map platforms from this"
- Part of `/inbox-process` when processing technical correspondence
- After any vendor/agency onboarding email

## Input

| Input | Required | Source |
|---|---|---|
| Text / email / file | Yes | User paste, file path, or conversation context |
| Client slug | Yes | Auto-detect from working directory or ask |

## What to Extract

### Tier 1 — Always extract (high value, unique identifiers)

| Type | Pattern | Example | Target file |
|---|---|---|---|
| **Domain** | `*.com`, `*.hu`, `*.de`, `*.fr`, `*.nl`, URLs | `buenospa.com`, `wellis.hu` | DOMAIN_CHANNEL_MAP `## Domains` |
| **GA4 Property** | `G-XXXXXXXXX` or `properties/XXXXXXXXX` | `G-W3JK5L2M` | DOMAIN_CHANNEL_MAP `## Analytics → GA4` + CLIENT_CONFIG `## Tracking IDs` |
| **GTM Container** | `GTM-XXXXXXX` | `GTM-KF5ZNHD` | DOMAIN_CHANNEL_MAP `## Analytics → GTM` + CLIENT_CONFIG |
| **Google Ads** | `XXX-XXX-XXXX` (10-digit) | `695-132-7421` | DOMAIN_CHANNEL_MAP `## Ad Accounts → Google Ads` + CLIENT_CONFIG |
| **Meta Pixel** | pixel ID (15-16 digit) | `548219623456789` | DOMAIN_CHANNEL_MAP `## Ad Accounts → Meta` + CLIENT_CONFIG |
| **Meta Ad Account** | `act_XXXXXXXXX` | `act_1234567890` | DOMAIN_CHANNEL_MAP `## Ad Accounts → Meta` |
| **sGTM domain** | `sst.*`, `gtm.*`, `ss.*` | `sst.buenospa.com` | DOMAIN_CHANNEL_MAP `## Analytics → GTM` + CLIENT_CONFIG |
| **ActiveCampaign** | `*.api-us1.com`, `*.activehosted.com` | `wellis-eu.activehosted.com` | DOMAIN_CHANNEL_MAP `## CRM / Email` |
| **Shopify** | `*.myshopify.com` | `buenospa.myshopify.com` | DOMAIN_CHANNEL_MAP `## E-commerce` |

### Tier 2 — Extract when found (supporting identifiers)

| Type | Pattern | Example | Target file |
|---|---|---|---|
| **Google Merchant Center** | merchant ID | `123456789` | CLIENT_CONFIG |
| **Search Console** | verified property URL | `sc-domain:wellis.hu` | DOMAIN_CHANNEL_MAP `## Analytics → Search Console` |
| **Databox source** | source ID (7-digit) | `4924545` | DOMAIN_CHANNEL_MAP `## Databox` |
| **Hotjar** | site ID | `3456789` | CLIENT_CONFIG |
| **TikTok Pixel** | pixel ID | `CXXX...` | CLIENT_CONFIG |
| **Pinterest Tag** | tag ID | `2612345678901` | CLIENT_CONFIG |
| **Bing/Microsoft Ads** | account ID | | CLIENT_CONFIG |
| **CookieYes/Cookiebot** | banner ID | | CLIENT_CONFIG |
| **Roivenue** | connection/project ref | | CLIENT_CONFIG |
| **IFS/ERP** | system reference | | CLIENT_CONFIG (notes) |
| **Daktela/helpdesk** | instance, ticket ID pattern | `daktela#766004` | CLIENT_CONFIG (notes) |

### Tier 3 — Flag but don't auto-map (needs context)

| Type | What to flag | Action |
|---|---|---|
| **IP addresses** | Server IPs, CDN IPs | Flag for CLIENT_CONFIG infrastructure section |
| **API keys/tokens** | Any credential-like string | **NEVER store** — flag as security concern |
| **Email addresses** | @domain patterns | Route to `/extract-contacts` instead |
| **Phone numbers** | Tel patterns | Route to `/extract-contacts` instead |

## Execution Steps

### Step 1: Scan input for all identifiers

Use regex patterns to find all Tier 1 and Tier 2 identifiers. For each, capture:
- **Raw value** (exact string)
- **Type** (GA4, GTM, Google Ads, etc.)
- **Context** (surrounding text — what domain/purpose it relates to)
- **Who mentioned it** (From: header or speaker name)

### Step 2: Load existing maps

Read from client project root:
1. `DOMAIN_CHANNEL_MAP.md` — current platform mappings
2. `CLIENT_CONFIG.md` — current tracking IDs

Build lookup by identifier value.

### Step 3: Classify each discovery

| Status | Action |
|---|---|
| **EXISTS — matches current map** | Skip |
| **EXISTS — new context** | Update Notes column (e.g., "also serves wellis.fr per email 2026-04-10") |
| **NEW — domain known, ID new** | Add to correct section, map to domain |
| **NEW — domain unknown** | Add to `## Unmapped / Unknown` with discovery context |
| **CONFLICT — different value for same slot** | **FLAG** — don't overwrite. "CLIENT_CONFIG says GA4 = G-ABC, email says G-XYZ — which is current?" |
| **DEPRECATED — ID mentioned but account closed** | Update Status to `Deprecated` with date |

### Step 4: Determine domain mapping

For each new identifier, try to map to a domain:
1. **Explicit in text** — "the GTM for wellis.hu is GTM-ABC" → direct map
2. **Email domain context** — email about buenospa.com → likely buenospa.com
3. **Campaign name patterns** — `buenospa.com_pmax_*` → buenospa.com
4. **Cannot determine** → add to `## Unmapped / Unknown` with `Action needed: confirm domain`

### Step 5: Apply changes

1. Edit `DOMAIN_CHANNEL_MAP.md` — add new rows in correct sections
2. Edit `CLIENT_CONFIG.md` — add new tracking IDs
3. Set `Active Since` to email/document date
4. Set `Status` to `Active` (or `Active (unverified)` if from forwarded/second-hand source)
5. Add Change Log entry in DOMAIN_CHANNEL_MAP

### Step 6: Report

```
## Platform extraction results
- **Source:** {file or "pasted email"}
- **Identifiers found:** {N}
- **New mappings added:** {list with type + domain + where stored}
- **Existing mappings confirmed:** {list}
- **Conflicts found:** {list — REQUIRES MANUAL RESOLUTION}
- **Unmapped (needs context):** {list}
- **Security flags:** {any API keys/tokens found — DO NOT STORE}
```

### Step 7: Cross-reference

Flag if:
- A new domain has NO GA4 property → **tracking blind spot**
- A new domain has NO GTM container → **no tag management**
- A Google Ads account has no Databox source → **not in dashboards**
- An AC instance is mentioned but not in DOMAIN_CHANNEL_MAP → **CRM blind spot**
- A Tier 3 item (API key) was found → **security: do not store, warn user**

## Rules

1. **Never store API keys, tokens, or credentials.** Flag and warn.
2. **Never overwrite existing mappings without flagging.** A conflict = manual resolution.
3. **Temporal columns are mandatory.** Every new mapping gets `Active Since` (from document date) and `Status`.
4. **Preserve existing data.** Only add or update Notes — never blank out a filled field.
5. **Multi-domain clients:** always try to map identifier → domain. Unmapped = blind spot.
6. **IDs are case-sensitive.** `GTM-KF5ZNHD` ≠ `gtm-kf5znhd`.
7. **Verify before trusting.** If ID comes from forwarded email or second-hand mention, mark as `Active (unverified)`.

## Integration

- **`/extract-contacts`** — person data routes there, platform data routes here. They complement each other.
- **`/inbox-process`** — when routing technical correspondence, auto-run platform extraction.
- **`/scaffold-project`** — creates empty DOMAIN_CHANNEL_MAP and CLIENT_CONFIG for new clients.
- **`/measurement-audit`** — reads DOMAIN_CHANNEL_MAP as primary input. Missing mappings = audit gaps.
- **Multi-Domain Analysis Rule** — this skill is the feeder. Every analysis starts with "load DOMAIN_CHANNEL_MAP."
- **Alarm Calibration** — new Databox sources need baseline data before anomaly detection works.

## Examples

**Input:** Daktela onboarding email mentioning `daktela#766004`, `nagy.robert@wellis.hu`
**Output:**
- `daktela#766004` → Tier 2, add to CLIENT_CONFIG notes (helpdesk ticket system reference)
- `nagy.robert@wellis.hu` → route to `/extract-contacts`
- No Tier 1 IDs found

**Input:** Agency email: "We set up GTM-ABC123 on sst.example.com for the new GA4 property G-XYZ789"
**Output:**
- `GTM-ABC123` → NEW → DOMAIN_CHANNEL_MAP `## Analytics → GTM` (Server, domain TBD)
- `sst.example.com` → NEW → sGTM domain, linked to GTM-ABC123
- `G-XYZ789` → NEW → DOMAIN_CHANNEL_MAP `## Analytics → GA4` + CLIENT_CONFIG
- Cross-ref: domain? → check email context or flag as unmapped

### Example 1: Full website scan

**Input:** Homepage of example-brand.com scanned via Chrome DevTools

**Output:**

| Platform | ID / Detail | Status | Source |
|---|---|---|---|
| Google Analytics 4 | G-EXAMPLE001 | CONFIRMED [OBSERVED] | dataLayer + network request to google-analytics.com |
| Google Tag Manager | GTM-EXAMPLE01 | CONFIRMED [OBSERVED] | Script tag in `<head>` |
| Meta Pixel | 123456789012345 | CONFIRMED [OBSERVED] | fbq('init') call detected |
| Shopify | Checkout at checkout.example-brand.com | CONFIRMED [OBSERVED] | Shopify CDN assets loaded |
| Consent Banner | CookieYes | CONFIRMED [OBSERVED] | cookieyes.js loaded, banner visible |

### Example 2: Partial scan with gaps

**Input:** Landing page scan — consent banner blocks most scripts

**Output:**

| Platform | ID / Detail | Status | Source |
|---|---|---|---|
| Google Analytics 4 | G-EXAMPLE001 | CONFIRMED [OBSERVED] | Loaded after consent accept |
| Consent Banner | Unknown provider | PARTIAL [OBSERVED] | Banner visible but no identifiable script name |
| Meta Pixel | — | NOT DETECTED [OBSERVED] | No fbq() calls found post-consent |
| Server-side GTM | — | UNKNOWN | Cannot determine from client-side scan |

**Flag:** Meta Pixel NOT DETECTED — verify: (1) is it expected? (2) check GTM container for pixel tag.
