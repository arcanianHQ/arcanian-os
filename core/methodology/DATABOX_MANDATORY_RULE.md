---
scope: shared
---

# Databox is Mandatory for Data Analysis

> v1.0 — 2026-04-11

## Rule

**Without a live Databox MCP connection, NEVER perform data analysis. This is a HARD BLOCK — not a warning, not a degraded mode.**

## Why

Local markdown files contain snapshots — they are stale the moment they're saved. Analyzing data from local files instead of Databox produces conclusions based on outdated numbers. This has caused wrong recommendations in the past.

The whole point of Databox integration is that every number is live, verifiable, and timestamped. Without it, the system is guessing — and guessing dressed up as analysis is worse than saying "I can't analyze this right now."

## Behavior

### When Databox IS connected:
- Pull metrics via `load_metric_data` or `ask_genie`
- Every metric claim includes `[DATA: Databox, YYYY-MM-DD]` evidence tag
- Cross-verify with platform data where possible

### When Databox is NOT connected:
1. **STOP immediately** — do not proceed with analysis
2. **Tell the user explicitly:** "Databox MCP is not connected. I cannot analyze data without it."
3. **Do NOT:**
   - Fall back to local files or cached data
   - Say "let me check local data files instead"
   - Use numbers from memory or prior conversations
   - Infer metrics from task descriptions or finding files
   - Produce any analysis output that looks like it came from real data
4. **DO:**
   - Help the user reconnect Databox (`/mcp` to re-authenticate)
   - Queue the analysis request for after reconnection
   - Work on non-data tasks while waiting

## Exceptions

- **Reading existing findings/RECs** (already written, already evidence-tagged) — OK, these are historical records, not live analysis
- **Structural work** (task management, SOP edits, planning) — OK, doesn't require data
- **The script/prompter for video recording** — references pre-verified numbers, not live queries

## How to apply

This rule applies to ALL skills that touch data:
- `/7layer`, `/council`, `/map-results`, `/analyze-gtm`, `/measurement-audit`
- `/day-start` (anomaly detection section)
- `/health-check` (metric verification)
- Any ad-hoc analysis request from the user
- Any agent that pulls metrics (channel-analyst-*, outcome-tracker)

Before executing any of these, check: `Is Databox MCP connected?` If not → STOP.
