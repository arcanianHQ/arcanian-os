---
scope: shared
---

# Team Directory — User Identity & Sync Mapping

> Used by /task-sync, /council, and hooks to map task owners to external system users.
> Updated: 2026-03-26

## Team Members

| Name | Short | Role | Todoist Email | Asana Email | Machines |
|------|-------|------|---------------|-------------|----------|
| Fazakas László | László | Creator/Strategy | laszlo@arcanian.ai | laszlo@arcanian.ai | MacBook Pro (endre), Mac mini (T9) |
| Erdei Éva | Éva | Research/Presentation | eva@arcanian.ai | eva@arcanian.ai | MacBook Air |
| Diószegi Dóra | Dóra | Delivery/Operations | dora@arcanian.ai | dora@arcanian.ai | MacBook Air |
| Viktor | Viktor | Wellis HU operations | — | — | — |

## Session User Detection

Claude Code sessions detect the current user from `~/.claude/user.json` if it exists, or fall back to the OS username.

**Detection order:**
1. `~/.claude/user.json` → `{ "name": "László", "email": "laszlo@arcanian.ai" }`
2. `$USER` environment variable → map: `endre` = László
3. Ask on first use → save to `~/.claude/user.json`

## Owner → Todoist Mapping

When `/task-sync` pushes a task with `Owner: László`, it maps to the Todoist collaborator with matching email. If the project has no collaborators (personal project), `responsibleUser` is omitted.

| TASKS.md Owner | Todoist responsibleUser | Asana assignee |
|----------------|----------------------|----------------|
| László | laszlo@arcanian.ai | laszlo@arcanian.ai |
| Éva | eva@arcanian.ai | eva@arcanian.ai |
| Dóra | dora@arcanian.ai | dora@arcanian.ai |
| László + Éva | László (primary), Éva as follower | László (assignee), Éva (follower) |
| Pali | — (external, no Todoist) | — |
| Viktor | — (external, no Todoist) | — |

## Per-Client Owner Defaults

| Client | Default Owner | Notes |
|--------|--------------|-------|
| wellis | László | Under NDA, László only |
| diego | László | Primary, Éva on Google Ads tasks |
| mancsbazis | Dóra | Dóra owns delivery, László strategy |
| deluxe | László | |
| flora-miniwash | László | Gateway to STRT Holding |
| domypress | László | New onboarding |
| internal | László | Hub tasks |
