---
id: "FND-NNN"
client: "{slug}"
title: "{Short title}"
severity: "Critical|High|Medium|Low"
phase: 0-5
layer: "Feed|DataLayer|Consent|Network|SGTM|Platform|Cross-system"
status: "open|verified|resolved|false-positive"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
---

# FND-NNN: {Title}

## Observation
{What was observed — facts only, no interpretation}

## Evidence
{Screenshots, network payloads, code snippets, URLs}

## Root Cause
{Why this happens — technical mechanism}

## Impact
{What breaks or degrades — conversions, attribution, compliance, data quality}

## Related
- REC-NNN (recommendation that fixes this)
- FND-NNN (related finding)
- PAT-NNN (known pattern match)
- Task #N (in TASKS.md)

<!--
FINDING CONVENTIONS:
- Sequential per client, never reuse numbers
- File: FND-NNN_slug-description.md
- Severity: Critical (data loss/compliance), High (significant), Medium (non-critical), Low (best practice)
- Phase: which audit phase discovered it (0=CLI, 1=Browser, 2=Dashboard, 3=Container, 4=Cross-verify, 5=Diagnosis)
- Layer: what tracking layer is affected
- Status flow: open → verified → resolved (or false-positive)
- Evidence is mandatory — no finding without proof
-->
