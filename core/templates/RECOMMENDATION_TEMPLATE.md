---
id: "REC-NNN"
client: "{slug}"
title: "{What to do}"
priority: "P0|P1|P2|P3"
effort: "Quick fix|Half day|Multi-day|Project"
addresses: ["FND-NNN", "FND-NNN"]
status: "open|in-progress|done"
created: "YYYY-MM-DD"
---

# REC-NNN: {Title}

## Recommendation
{What to do — specific, actionable}

## Implementation
{Step-by-step instructions, code changes, GTM changes}

## Verification
{How to confirm the fix worked — specific checks}

## What This Fixes

| Finding | Title | Severity |
|---|---|---|
| FND-NNN | {title} | {severity} |

## Related
- FND-NNN (what this addresses)
- Task #N (in TASKS.md)
- REC-NNN (related recommendation)

<!--
RECOMMENDATION CONVENTIONS:
- Sequential per client, mirrors FND numbering where possible
- File: REC-NNN_slug-description.md
- Must be actionable — "do X" not "consider Y"
- Implementation = step-by-step (someone else should be able to follow it)
- Verification = how to prove it's fixed (not "check if it works")
- Always links back to findings it addresses
-->
