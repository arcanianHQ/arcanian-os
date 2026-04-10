---
scope: shared
---

> v1.0 --- 2026-04-10

# MCP Error Handling Standard

> When an MCP tool fails, don't just retry blindly. Classify the error, then decide.
> Inspired by Claude Certified Architect best practices (structured error responses).

---

## Error Categories

| Category | HTTP Codes | Meaning | Retryable? | Action |
|---|---|---|---|---|
| **transient** | 429, 500, 502, 503, 504, timeout | Temporary service issue | Yes — backoff | Wait `retry_after` or exponential backoff, max 3 attempts |
| **validation** | 400, 422 | Bad input (malformed request, missing field) | No — fix input | Fix the request parameters, then retry once |
| **business** | 404, 409, 410 | Resource not found, conflict, gone | No — surface | Tell the user: "{resource} not found" or "conflict detected" |
| **permission** | 401, 403 | Auth failure or insufficient access | No — escalate | Tell the user: "Access denied — check MCP token/permissions" |

---

## Retry Strategy

### Transient Errors (429, 5xx, timeout)

```
Attempt 1: immediate (first failure)
Attempt 2: wait 3 seconds
Attempt 3: wait 10 seconds
After 3 failures: STOP, report to user with error details
```

**Special case — 429 (rate limit):**
- If `retry_after` header present → wait that exact duration
- If no header → halve batch size + wait 5 seconds
- See `MCP_RATE_LIMITS.md` for per-platform batch limits

### Validation Errors (400, 422)

```
1. Read the error message carefully
2. Identify which parameter is wrong
3. Fix the parameter
4. Retry ONCE with corrected input
5. If still fails → STOP, show error to user
```

**Never retry a 400 with the same input.** That's the definition of insanity.

### Business Errors (404, 409)

```
1. 404: "Resource {id} not found in {platform}"
   - Check: did the ID come from a stale cache/memory?
   - Check: is the resource in a different instance/account?
2. 409: "Conflict — resource was modified by someone else"
   - Fetch current state, show diff to user, ask for resolution
```

### Permission Errors (401, 403)

```
1. 401: "Authentication failed — MCP token may be expired"
   - Suggest: restart session (MCP tokens freeze at session start)
2. 403: "Insufficient permissions for this operation"
   - Check: does the MCP server's scope include this action?
   - Check: is this a read-only MCP being asked to write?
```

---

## Structured Error Response Format

When an MCP tool fails, classify and present:

```
MCP ERROR: {tool_name}
Category: {transient|validation|business|permission}
Retryable: {yes|no}
Detail: {error message from the platform}
Action: {what we're doing about it}
```

---

## Platform-Specific Patterns

| Platform | Common Error | Category | Notes |
|---|---|---|---|
| **Todoist** | 429 Too Many Requests | transient | Max 450 req/min. Batch 10, wait 3s. |
| **Todoist** | 400 Invalid project_id | validation | Check TODOIST_ROUTING_MAP.md |
| **ActiveCampaign** | 429 Rate Limited | transient | Varies by plan. |
| **ActiveCampaign** | 404 Contact not found | business | Check: right instance? (US vs EU) |
| **Databox** | 401 Unauthorized | permission | Token in .mcp.json may be expired |
| **Asana** | 403 Forbidden | permission | Check workspace access |
| **Fireflies** | 429 | transient | Max 5 concurrent. Wait + halve batch. |

---

## Integration Points

- `MCP_RATE_LIMITS.md` → references this file for error classification before retry decisions
- `post-tool-use-mcp-error-classifier.sh` → hook that auto-classifies MCP errors
- All MCP-using skills and agents → should follow this standard when handling failures

---

*What error patterns are we missing? What platforms behave differently?*
