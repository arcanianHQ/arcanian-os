---
scope: shared
---

# SSH Onboarding

## Overview

SSH provides secure remote terminal access to macOS systems.

- **Auth Method:** Key-based (recommended) or Password
- **Port:** 22 (default)

## Onboarding Steps

### 1. Enable SSH on Target Mac

1. Open System Settings
2. Go to General → Sharing
3. Enable "Remote Login"
4. Select users allowed to access

### 2. Generate SSH Key (New Member)

On the connecting device:

```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "name@arcanian.ai"

# View public key
cat ~/.ssh/id_ed25519.pub
```

### 3. Add Public Key to Target Mac

On the target Mac:

```bash
# Create authorized_keys if it doesn't exist
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Add the public key
echo "paste-public-key-here" >> ~/.ssh/authorized_keys
```

### 4. Test Connection

```bash
# Connect via local network
ssh username@192.168.x.x

# Connect via Tailscale
ssh username@device-name
```

### 5. New Member Tasks

1. [ ] Generate SSH key pair
2. [ ] Share public key with admin
3. [ ] Wait for key to be added to target systems
4. [ ] Test SSH connection
5. [ ] Install SSH client on mobile (Termius or Blink Shell)

## Access Removal

1. Edit `~/.ssh/authorized_keys` on target Mac
2. Remove the user's public key line
3. Save file

---
