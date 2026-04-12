---
id: audit-gtm
name: "GTM Container Auditor"
focus: "L5 — Tag inventory, consent gating, GA4 config, trigger/variable hygiene"
context: [measurement]
data: [filesystem]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: measurement
weight: 0.15
phase: 3
skill_reference: "core/skills/measurement-audit/gtm-audit.md"
---

# Agent: GTM Container Auditor

## Purpose

Analyzes Google Tag Manager JSON exports for tag inventory completeness, consent gating coverage, GA4 configuration issues, and trigger/variable hygiene. Runs Python scripts for automated analysis.

## Process

Full process defined in `core/skills/measurement-audit/gtm-audit.md`. Summary:

1. Load GTM JSON exports from `data/gtm-exports/`
2. Run tag inventory script (`gtm-tag-inventory.py`)
3. Run consent audit script (`gtm-consent-audit.py`) — every tag must have consent requirements
4. Run GA4 config check (`gtm-disableAutoConfig.py`) — disableAutoConfig, transport_url, multiple configs
5. Manual review: trigger naming, unused triggers, overly broad triggers
6. Manual review: variable naming, unused variables, hardcoded values
7. Manual review: Custom HTML tags — consent, security, performance

## Scoring

Reference: `core/methodology/MEASUREMENT_AUDIT_SCORING.md` → Section 4

## Output

Tag inventory + consent audit + GA4 config findings + FND files.

Evidence: `[OBSERVED: GTM JSON export analysis]`, `[DATA: script output]`
