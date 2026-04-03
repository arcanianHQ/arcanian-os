---
client: "{client}"
date: "YYYY-MM-DD"
phase: "{Phase 1 / Consent Check / Ad-hoc}"
domain: "{domain tested}"
browser_state: "clean"
---

# Browser Session Log — {Client} — YYYY-MM-DD

> Chronological log of every Chrome DevTools MCP action and its result.
> One file per audit session. Never edit after the session — append only during.

---

## Session Info

| Field | Value |
|-------|-------|
| Client | {client} |
| Domain | `{domain}` |
| Date | YYYY-MM-DD |
| Phase | {Phase 1 / Consent Check / etc.} |
| Chrome DevTools | `--remote-debugging-port=9222` |
| Clean state | Yes / No |

---

## Log

### HH:MM — {Action title}

**MCP call:** `{tool_name}`
**Input:** `{key parameters}`
**Result summary:** {What was observed — keep concise but factual}

```
{Raw output snippet if relevant — network payload, console error, script return value}
```

**Finding:** {FND-NNN reference if this revealed a finding, or "—"}

---

### HH:MM — {Next action}

**MCP call:** `{tool_name}`
**Input:** `{key parameters}`
**Result summary:**

```
```

**Finding:** —

---

<!-- Repeat for each MCP call -->

## Session Summary

**Actions taken:** {count}
**Findings discovered:** FND-XXX, FND-XXX
**Key observations:**
-
-

**Next steps:**
-

---

**Session ended:** HH:MM
