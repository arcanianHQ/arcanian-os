---
scope: shared
---

# Tailscale Onboarding

## Overview

Tailscale provides secure VPN mesh network for remote access to internal systems.

- **Status:** Planned
- **Auth Method:** SSO/Email

## Onboarding Steps

### 1. Prerequisites

- Tailscale account (personal or organization)
- Device to install Tailscale on

### 2. Installation

#### macOS
```bash
brew install tailscale
```
Or download from: https://tailscale.com/download/mac

#### iOS (iPad/iPhone)
1. Download "Tailscale" from App Store
2. Open app and sign in

### 3. Join Network

1. Open Tailscale
2. Sign in with approved identity provider
3. Device automatically joins the tailnet

### 4. Verify Connection

1. Check Tailscale admin console for new device
2. Test connectivity to other devices on tailnet:
   ```bash
   ping <device-name>
   ```

### 5. New Member Tasks

1. [ ] Install Tailscale on required devices
2. [ ] Sign in and join tailnet
3. [ ] Verify connection to internal resources
4. [ ] Configure exit node if needed

## Access Removal

1. Go to Tailscale admin console
2. Find user → Remove from tailnet
3. Devices will automatically disconnect

---
