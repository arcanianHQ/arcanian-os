---
scope: shared
---

# Ubiquiti Remote Access Setup

Project for configuring remote access to local Mac system from iPad/iPhone using Ubiquiti networking.

## Goals

- Access local Mac from iOS devices (iPad/iPhone)
- Leverage existing Ubiquiti network infrastructure

## Planned Solutions

1. **Tailscale VPN** - Zero-config mesh VPN for secure remote access
2. **Ubiquiti Teleport** - Native UniFi VPN (if using UniFi Gateway)
3. **SSH Access** - Terminal access via Termius or Blink Shell
4. **Screen Sharing** - GUI access via Screens 5 or Jump Desktop

## MCP Servers

- **Asana** - Task management integration (`https://mcp.asana.com/sse`)

## Post-Restart Checklist

After computer restart, ensure:
- [ ] Claude Code is running
- [ ] MCP servers are connected (run `/mcp` to verify)
- [ ] Tailscale is connected (if installed)
