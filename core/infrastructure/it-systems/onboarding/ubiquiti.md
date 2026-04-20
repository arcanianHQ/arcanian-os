---
scope: shared
---

# Ubiquiti/UniFi Onboarding

## Overview

Ubiquiti UniFi is used for network infrastructure management.

- **Auth Method:** Browser-based
- **Console:** Local UniFi Controller or UniFi Cloud

## Onboarding Steps

### 1. Create UniFi Account

1. Go to https://account.ui.com
2. Create account with @arcanian.ai email
3. Enable two-factor authentication

### 2. Grant Access to Network

#### Local Controller
1. Log in to UniFi Controller
2. Go to Settings → Admins
3. Add new admin with email
4. Select role:
   - **Super Admin** - Full access
   - **Admin** - Manage devices
   - **Read Only** - View only

#### UniFi Cloud
1. Log in to https://unifi.ui.com
2. Share site access with new user's UI account

### 3. Teleport VPN Setup (Optional)

If using UniFi Gateway with Teleport:

1. Enable Teleport in UniFi settings
2. New user downloads UniFi app
3. Connect via Teleport for remote access

### 4. New Member Tasks

1. [ ] Create UI.com account
2. [ ] Accept network invitation
3. [ ] Download UniFi Network app (mobile)
4. [ ] Verify access to network dashboard

## Access Removal

1. Go to Settings → Admins
2. Remove user from admin list
3. Revoke any Teleport access

---
