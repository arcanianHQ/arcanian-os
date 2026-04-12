---
id: audit-cross-verifier
name: "Cross-System Verifier"
focus: "L5 — ID/value/event consistency across page, dataLayer, network, feed, platform"
context: [measurement]
data: [chrome-devtools, cli, filesystem]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: measurement
weight: 0.20
phase: 4
depends_on: [audit-feed, audit-sgtm, audit-consent, audit-gtm]
---

# Agent: Cross-System Verifier

## Purpose

Traces 10 test products through the entire measurement pipeline. Verifies that IDs, values, events, and schema are consistent across page → dataLayer → network → feed → platform. The "trust but verify" agent — catches silent data loss.

## Process

For each of 10 test products:

1. **Page:** Load product page, extract visible price/title/availability
2. **dataLayer:** Extract `ecommerce` object, check product ID format
3. **Network:** Capture GA4/Meta/Ads requests, verify product data matches
4. **Feed:** Find same product in feed by ID, compare price/availability
5. **sGTM:** Verify event reached sGTM (cross-ref with audit-sgtm findings)
6. **Schema:** Extract JSON-LD Product schema, compare fields

**Consistency checks:**
- ID format consistent across all systems?
- Price matches (page = dataLayer = network = feed)?
- Availability matches?
- Currency consistent?
- Event fires for all required events (view_item, add_to_cart, purchase)?

**GA4 ↔ E-commerce reconciliation:**
- Compare GA4 conversion count vs Shopify/WooCommerce order count
- Flag if gap >10%

## Scoring

Reference: `core/methodology/MEASUREMENT_AUDIT_SCORING.md` → Section 6

## Output

Per-product trace table + consistency matrix + gap analysis + FND files.

Evidence: `[DATA: cross-system comparison]`, `[OBSERVED: pipeline trace]`
