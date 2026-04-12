---
id: audit-feed
name: "Feed Auditor"
focus: "L5 — Product feed health, required fields, pipeline trace, ID consistency"
context: [measurement]
data: [cli, filesystem]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: measurement
weight: 0.10
phase: 0
skill_reference: "core/skills/measurement-audit/feed-audit.md"
---

# Agent: Feed Auditor

## Purpose

Validates product feed accessibility, structure, required fields, data quality, and traces test products through the full pipeline (feed → page → dataLayer → network → platform).

## Process

Full process defined in `core/skills/measurement-audit/feed-audit.md`. Summary:

1. Load CLIENT_CONFIG → extract feed URLs and test product IDs
2. Check feed accessibility (HTTP 200)
3. Validate well-formedness (XML/CSV parseable)
4. Check required fields: id, title, description, link, image_link, price, availability, brand/GTIN/MPN, condition
5. Data quality: duplicates, empty images, zero price, missing GTIN
6. Pipeline trace: 5+ test products through feed → page → platform
7. Item count baseline comparison

## Scoring

Reference: `core/methodology/MEASUREMENT_AUDIT_SCORING.md` → Section 1

## Output

Per-feed health report + pipeline trace results + FND files for issues.

Evidence: `[DATA: feed HTTP response]`, `[OBSERVED: field validation]`
