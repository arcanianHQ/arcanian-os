---
paths:
  - "clients/*/EVENT_LOG.md"
  - "clients/*/docs/*"
  - "clients/*/data/*"
  - "clients/*/audit/*"
  - "clients/*/reports/*"
  - "clients/*/analysis/*"
---

# Event Log Enforcement (path-scoped)

## When READING or WRITING analysis/data files for a client:

**PRE-LOAD:** Load `clients/{slug}/EVENT_LOG.md` BEFORE querying any data source.
- Identify events within your analysis period
- Account for known events when interpreting data (a session drop during a known budget cut is NOT an anomaly)
- If EVENT_LOG.md doesn't exist → WARN and create task to populate it

**POST-ANALYSIS:** After completing analysis, scan your output for newly discovered dated events:
- Budget/spend changes with identifiable dates
- Account/platform/campaign start/stop dates
- Tracking deployment dates
- Any >15% metric change with an identified external cause
→ Append new events to EVENT_LOG.md (dedup against existing entries first)

## When EDITING EVENT_LOG.md directly:

1. **EVT ID format:** `EVT-YYYY-MM-DD-NNN` — sequential per day. Verify no ID collision.
2. **Source tag is MANDATORY.** Every event must have `[DATA: ...]`, `[STATED: ...]`, `[OBSERVED: ...]`, or `[INFERRED]`.
3. **`[INFERRED]` events require a verification task.** Create one in TASKS.md linking back to the EVT ID.
4. **Never delete events.** Wrong event → add correction event referencing the original.
5. **Related column:** link to FND/REC/Task where applicable. Ontology backlinks apply.
6. **One event per row.** Two things on same day = two rows.

Rule: `core/methodology/EVENT_LOG_RULE.md`
