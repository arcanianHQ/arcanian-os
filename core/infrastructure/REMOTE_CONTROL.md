---
scope: shared
---

# Arcanian Ops — Remote Control Setup

## Primary: Claude Code Remote Control (native)

Claude Code has built-in remote control. No SSH, no Tailscale, no tmux needed for Claude sessions.

### Mac Mini Setup (One-Time)

```bash
# 1. Enable Remote Control globally (auto-enable for every session)
claude config set --global remoteControl true

# 2. Start the hub in server mode
claude remote-control --name "Arcanian Hub" --spawn worktree --capacity 32

# 3. Prevent Mac mini from sleeping
caffeinate -d -i -s &

# 4. In System Settings:
#    → General → Energy → "Wake for network access" = ON
#    → General → Energy → "Prevent automatic sleeping" = ON
```

**What this gives you:**
- One process, multiple concurrent sessions (up to 32)
- Each session runs in an isolated git worktree (no conflicts)
- Team members connect by scanning a QR code or opening `claude.ai/code`
- No SSH keys, no Tailscale setup, no tmux management
- Works from MacBook, iPhone, iPad — any browser

### Connecting from Any Device

1. Open `claude.ai/code` in a browser
2. Select the "Arcanian Hub" server
3. Choose or create a session (one per project)
4. You're in Claude Code — full access to that project's files, skills, MCP tools

Or: scan the QR code displayed when `claude remote-control` starts.

### Session Management

```bash
# Sessions are created per-project
# Each session gets its own worktree — isolated copy of the repo
# No conflicts even if two people work on the same project

# From the hub terminal, check active sessions:
claude remote-control status
```

---

## Fallback: Claude Code on the Web

When the Mac mini is down, or for lightweight work without the hub:

- **claude.ai/code** runs on Anthropic's cloud — no local setup needed
- Useful for Éva/Dóra to do quick tasks, review reports, ask questions
- Does NOT have access to local files or MCP servers (limited mode)
- Use for: reading tasks, drafting content, quick analysis
- NOT for: audit work, MCP-connected reports, sync operations

**Document as Plan B in team onboarding.**

---

## Fallback: SSH + Tailscale (non-Claude tasks)

For system admin, file browsing, or when Claude Code isn't the right tool:

### Setup
```bash
# 1. Install Tailscale on Mac mini
# Download from https://tailscale.com/download/mac
# Mac mini gets: macmini.tailnet-xxxx.ts.net

# 2. Enable SSH
# System Settings → General → Sharing → Remote Login → ON

# 3. From MacBook/iPhone (Termius, Blink Shell, or Terminal):
ssh user@macmini.tailnet-xxxx.ts.net
```

### When to use SSH instead of Remote Control
- System administration (install packages, restart services)
- File operations outside Claude Code (bulk copy, backup)
- Git operations (force push, branch management)
- Debugging Mac mini issues
- Checking `caffeinate` status, disk space, etc.

---

## Team Access Summary

| Person | Primary Access | Fallback |
|---|---|---|
| **László** | Remote Control (full) + SSH (admin) | claude.ai/code |
| **Éva** | Remote Control (assigned projects) | claude.ai/code |
| **Dóra** | Remote Control (assigned projects) | claude.ai/code |
| **4th hire** | Remote Control (assigned projects) | claude.ai/code |

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Can't connect to Remote Control | Check: `claude remote-control status`. Restart if needed. Verify Mac mini is awake. |
| Mac mini is sleeping | Check `caffeinate` is running. Check Energy settings. |
| Session limit reached (32) | Close unused sessions. Check which ones are idle. |
| Need local file access but RC is down | Use SSH + Tailscale fallback. |
| Éva/Dóra need quick access, hub is down | Use claude.ai/code (cloud, limited mode). |
