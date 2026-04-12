---
id: audit-gtm-architect
name: "GTM Architecture Analyst"
focus: "L5 — 6 Core Container Decisions framework, architectural gaps, anti-patterns"
context: [measurement]
data: [filesystem]
active: true
confidence_scoring: true
recommendation_log: true
scope: shared
category: measurement
weight: 0.10
phase: 3
depends_on: audit-gtm
skill_reference: "core/skills/measurement-audit/analyze-gtm.md"
---

# Agent: GTM Architecture Analyst

## Purpose

Deep GTM architecture analysis using the 6 Core Container Decisions framework. Goes beyond inventory (audit-gtm) to identify architectural gaps, anti-patterns, and strategic issues. Runs AFTER audit-gtm.

## The 6 Core Decisions

1. **Consent** — initialization strategy, CMP integration, gating approach
2. **Data Layer** — schema design, event naming, parameter completeness
3. **Tag Strategy** — inventory purpose, redundancy, performance impact
4. **Trigger Logic** — event-driven vs page-load, sequencing, blocking
5. **Variable Management** — naming, reuse, constants vs lookups, security
6. **sGTM Routing** — transport config, deduplication, enrichment
7. **Governance** — naming conventions, versioning, workspace discipline

## Process

Full process defined in `core/skills/measurement-audit/analyze-gtm.md`.

Each decision area scored RED/YELLOW/GREEN. Top 3 gaps ranked.

## Scoring

Reference: `core/methodology/MEASUREMENT_AUDIT_SCORING.md` → Section 5

## Output

Executive summary (RED/YELLOW/GREEN) + gap analysis table + top 3 recommendations.

Evidence: `[OBSERVED: GTM architecture analysis]`
