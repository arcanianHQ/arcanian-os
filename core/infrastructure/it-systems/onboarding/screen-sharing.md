---
scope: shared
---

# Screen Sharing Onboarding

## Overview

macOS Screen Sharing provides remote GUI access to Mac systems.

- **Auth Method:** Password or Apple ID
- **Protocols:** VNC, Apple Remote Desktop

## Onboarding Steps

### 1. Enable Screen Sharing on Target Mac

1. Open System Settings
2. Go to General → Sharing
3. Enable "Screen Sharing"
4. Click info (i) button to configure:
   - Select "All users" or specific users
   - Set VNC password for non-Mac clients

### 2. Grant User Access

Option A - Local User Account:
- Add user to "Screen Sharing" allowed users list

Option B - Apple ID:
- User connects via Apple ID (requires both parties on same Apple ID or iCloud sharing)

### 3. Client Setup

#### macOS Client
1. Open Finder
2. Go → Connect to Server (Cmd+K)
3. Enter: `vnc://ip-address` or `vnc://tailscale-hostname`

#### iOS Client (iPad/iPhone)
Recommended apps:
- **Screens 5** - Best for Mac-to-Mac
- **Jump Desktop** - Cross-platform support

1. Install app from App Store
2. Add new connection:
   - Host: IP address or Tailscale hostname
   - Port: 5900 (default VNC)
   - Username/Password: Mac login credentials

### 4. New Member Tasks

1. [ ] Install screen sharing client (Screens 5 or Jump Desktop)
2. [ ] Receive connection details from admin
3. [ ] Test connection over local network
4. [ ] Test connection over Tailscale (if remote)

## Access Removal

1. System Settings → Sharing → Screen Sharing
2. Remove user from allowed users list
3. Change VNC password if shared

---
