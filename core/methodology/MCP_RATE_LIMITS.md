> v1.0 — 2026-03-24

# System Guardrail: MCP Rate Limits

> **SYSTEM-WIDE RULE** — applies to ALL MCP operations.
> Learned from: [Task Manager] 429 error (2026-03-24) — 50 assign operations sent at once, all failed.

---

## The Rule

**Never send bulk MCP operations without batching and delays.**

## Per-Platform Limits

| Platform | Max per call | Delay between batches | Notes |
|---|---|---|---|
| **[Task Manager]** | 10 items | 3 seconds | 429 at ~50. Safe at 10. |
| **Asana** | 10 items | 2 seconds | Rate limit varies by endpoint |
| **Fireflies** | 5 transcripts | 5 seconds | Large responses — batch small |
| **Databox** | 5 metrics | 2 seconds | Per-metric calls are fine |
| **ActiveCampaign** | 10 items | 2 seconds | Bulk endpoints exist but rate-limited |
| **Google Ads** | 1 report | 5 seconds | Heavy queries |
| **Meta Ads** | 1 report | 5 seconds | Heavy queries |

## Batching Pattern

```
WRONG:
  [task-manager].manage-assignments(taskIds: [50 IDs])  → 429 ALL FAILED

RIGHT:
  Batch 1: [task-manager].manage-assignments(taskIds: [10 IDs])  → wait 3s
  Batch 2: [task-manager].manage-assignments(taskIds: [10 IDs])  → wait 3s
  Batch 3: [task-manager].manage-assignments(taskIds: [10 IDs])  → wait 3s
  ...
```

## Retry on Rate Limit

When 429 received:
1. Wait the `retry_after` value (usually 30-60 seconds)
2. Reduce batch size by half
3. Retry
4. If 429 again: wait 2x longer, reduce batch to 5
5. After 3 failures: stop and tell the user

## Connection to Skills

Any skill that does bulk MCP operations must follow this:
- `/meeting-sync` — 5 transcripts per batch (already documented)
- `/tasks sync` — 10 tasks per batch to [Task Manager]/Asana
- `/client-report` — 5 metric calls max before pause
- `/health-check` — sequential MCP checks, not parallel
- `/morning-brief` — read-only, safe (but still batch if many clients)

## In Proposals / Automations

When estimating automation speed, account for rate limits:
```
❌ "We'll sync all 200 tasks in seconds"
✓ "200 tasks at 10/batch with 3s delays = ~60 seconds total"
```
