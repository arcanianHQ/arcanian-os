---
client: "{client}"
audit_date: "YYYY-MM-DD"
audit_type: "initial|weekly|incident|full"
auditor: ""
phases_completed: []
findings_count: 0
critical_count: 0
high_count: 0
medium_count: 0
low_count: 0
---

# {Client Name} — Audit Report

**Date:** YYYY-MM-DD
**Type:** Initial / Weekly / Incident / Full
**Auditor:**

---

## Executive Summary

<!-- 3-5 sentences: overall health, critical issues, key recommendation -->

**Overall status:** RED / YELLOW / GREEN

**Key findings:**
-
-
-

**Immediate actions required:**
-
-

---

## Phases Completed

| Phase | Name | Status | Notes |
|-------|------|--------|-------|
| 0 | CLI Baseline (SGTM, Feeds, Pixel) | Not started / Complete / Partial | |
| 1 | GTM Container Audit | Not started / Complete / Partial | |
| 2 | Browser-Side Verification | Not started / Complete / Partial | |
| 3 | SGTM & Server-Side Verification | Not started / Complete / Partial | |
| 4 | Feed & Catalogue Verification | Not started / Complete / Partial | |
| 5 | End-to-End Conversion Path | Not started / Complete / Partial | |

---

## Findings Summary

| ID | Title | Severity | Phase | Status | Owner |
|----|-------|----------|-------|--------|-------|
| FND-001 | | critical / high / medium / low / info | 0-5 | open | |
| FND-002 | | | | | |
| FND-003 | | | | | |

### By Severity

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High     | 0 |
| Medium   | 0 |
| Low      | 0 |
| Info     | 0 |

### By Phase

| Phase | Count |
|-------|-------|
| 0 — CLI Baseline | 0 |
| 1 — GTM Container | 0 |
| 2 — Browser-Side | 0 |
| 3 — Server-Side | 0 |
| 4 — Feed & Catalogue | 0 |
| 5 — End-to-End | 0 |

---

## Recommendations Summary

> **Grouped by priority.** Include count per group.

### P0 — Critical

| ID | Title | Status | Related Findings | Owner |
|----|-------|--------|-----------------|-------|
| REC-XXX | | proposed | FND-XXX | |

### P1 — High

| ID | Title | Status | Related Findings | Owner |
|----|-------|--------|-----------------|-------|
| REC-XXX | | proposed | FND-XXX | |

### P2 — Medium

| ID | Title | Status | Related Findings | Owner |
|----|-------|--------|-----------------|-------|
| REC-XXX | | proposed | FND-XXX | |

### P3 — Low

| ID | Title | Status | Related Findings | Owner |
|----|-------|--------|-----------------|-------|
| REC-XXX | | proposed | FND-XXX | |

---

## Pass/Fail Matrix

| Check | HU | RO | SK | Notes |
|-------|----|----|-----|-------|
| SGTM responding | | | | |
| Feed item count stable | | | | |
| Meta Pixel firing | | | | |
| Consent mode default denied | | | | |
| Purchase event tracked | | | | |
| Product IDs match feed | | | | |
| Enhanced Conversions active | | | | |
| GA4 events arriving | | | | |
| Google Ads conversions recording | | | | |
| No hardcoded scripts bypassing consent | | | | |

**Legend:** PASS / FAIL / PARTIAL / N/A

---

## Next Steps

> **Grouped by priority.**

### P0 — Critical
| # | Action | Owner | Due |
|---|--------|-------|-----|
| 1 | | | |

### P1 — High
| # | Action | Owner | Due |
|---|--------|-------|-----|
| 2 | | | |

### P2–P3 — Medium/Low
| # | Action | Owner | Due |
|---|--------|-------|-----|
| 3 | | | |

---

## Appendix

### Tools Used

- GTM Export version/date:
- Browser: Chrome + Meta Pixel Helper + Tag Assistant
- CLI scripts:
- Feed snapshot date:

### Files Generated

| File | Path | Description |
|------|------|-------------|
| | | |

---

**Template version:** 1.0
**Last updated:** 2026-03-07
