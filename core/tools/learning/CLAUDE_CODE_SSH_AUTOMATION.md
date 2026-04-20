---
scope: shared
---

# SSH Automation from Claude Code

Complete guide for automating SSH connections to Cloudways from Claude Code using expect scripts.

**Date:** 2025-11-16
**Tested Environment:** macOS with expect installed

---

## 🔍 The Problem

When trying to SSH into Cloudways from Claude Code using standard methods:

```bash
# ❌ This FAILS:
ssh SSH_USER (see .credentials)@D7_HOST (see .credentials) -p 22
# Error: Too many authentication failures

# ❌ This ALSO FAILS:
sshpass -p 'PASSWORD' ssh SSH_USER (see .credentials)@D7_HOST (see .credentials)
# Error: Permission denied, please try again
# Error: Too many authentication failures
```

**Why it fails:**
- SSH client tries multiple authentication methods before password
- Server rejects connection after too many failed auth attempts
- Password authentication gets blocked by previous key-based attempts

---

## ✅ The Solution: Expect Scripts

Use expect scripts with proper SSH options to force password-only authentication.

### Working Template

```bash
cat > /tmp/ssh_cmd.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 30
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) "YOUR_COMMAND_HERE"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/ssh_cmd.sh
/tmp/ssh_cmd.sh
```

### Critical SSH Options

| Option | Purpose |
|--------|---------|
| `-o StrictHostKeyChecking=no` | Skip host key verification |
| `-o PreferredAuthentications=password` | Force password authentication |
| `-o PubkeyAuthentication=no` | Disable SSH key attempts |

**Without these options, the connection will fail!**

---

## 📋 Practical Examples

### Example 1: Check Current Directory

```bash
cat > /tmp/ssh_pwd.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 30
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) "pwd"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/ssh_pwd.sh
/tmp/ssh_pwd.sh
```

**Output:**
```
/home/969836.cloudwaysapps.com/DB_USER (see .credentials)
```

### Example 2: List Directory Contents

```bash
cat > /tmp/ssh_ls.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 30
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) "cd public_html && ls -la"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/ssh_ls.sh
/tmp/ssh_ls.sh
```

### Example 3: Run Composer Install (Long-Running Command)

```bash
cat > /tmp/composer_install.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 600  # 10 minutes for long-running command
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) \
          "cd public_html/drupal10 && composer install --no-dev --no-interaction"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/composer_install.sh
/tmp/composer_install.sh
```

**Note:** Increase `timeout` for commands that take longer to execute.

### Example 4: Multiple Commands in Sequence

```bash
cat > /tmp/ssh_multi.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 60
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) \
          "cd public_html/drupal10/web && \
           ../vendor/bin/drush status && \
           ../vendor/bin/drush cr"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/ssh_multi.sh
/tmp/ssh_multi.sh
```

---

## 📤 SCP File Uploads with Expect

### Upload Single File

```bash
cat > /tmp/scp_upload.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 600  # 10 minutes for large files
spawn scp -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          -P 22 \
          /path/to/local/file.sql \
          SSH_USER (see .credentials)@D7_HOST (see .credentials):~/
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/scp_upload.sh
/tmp/scp_upload.sh
```

### Upload to Specific Directory

```bash
cat > /tmp/scp_upload_dir.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 600
spawn scp -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          -P 22 \
          /path/to/local/file.txt \
          SSH_USER (see .credentials)@D7_HOST (see .credentials):~/public_html/
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/scp_upload_dir.sh
/tmp/scp_upload_dir.sh
```

---

## ⚠️ Important Limitations

### 1. Connection Rate Limiting

**Problem:** Server may block connections after too many rapid attempts.

```bash
ssh: connect to host D7_HOST (see .credentials) port 22: Operation timed out
```

**Solution:** Wait 1-2 minutes between connection attempts if you hit rate limits.

### 2. Large File Uploads

**Problem:** SCP may timeout when uploading very large files (> 50MB).

```bash
scp: Connection closed
```

**Solutions:**
- Increase timeout: `set timeout 1200` (20 minutes)
- Compress files before uploading: `gzip file.sql`
- Upload to Cloudways backup location via web interface instead

### 3. Interactive Commands

**Problem:** Commands requiring interactive input won't work.

```bash
# ❌ This WON'T WORK:
nano settings.php
# ❌ This WON'T WORK:
drush config:import
# (if it prompts for confirmation)
```

**Solution:** Use non-interactive flags:
```bash
# ✅ This WORKS:
drush config:import -y
drush cr --no-interaction
composer install --no-interaction
```

---

## 🔧 Debugging SSH Issues

### Enable Verbose Logging

```bash
cat > /tmp/ssh_debug.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 30
log_user 1  # Enable verbose output
spawn ssh -vvv \
          -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) "pwd"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/ssh_debug.sh
/tmp/ssh_debug.sh
```

### Test Connection Only

```bash
cat > /tmp/ssh_test.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 30
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) "echo 'Connection successful'"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF

chmod +x /tmp/ssh_test.sh
/tmp/ssh_test.sh
```

**Expected output:**
```
Connection successful
```

---

## 📚 Cloudways-Specific Paths

Based on actual SSH verification (2025-11-16):

| Path Type | Actual Path |
|-----------|------------|
| **Home Directory** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)` |
| **Application Root** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/public_html` |
| **Drupal 10** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/public_html/drupal10` |
| **Web Root** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/public_html/drupal10/web` |
| **Config Sync** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/public_html/drupal10/config/sync` |
| **Private Files** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/private_html` |
| **Logs** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/logs` |
| **Git Repo** | `/home/969836.cloudwaysapps.com/DB_USER (see .credentials)/git_repo` |

---

## 🚀 Complete Deployment Example

Here's a complete example of running multiple deployment steps via SSH automation:

```bash
#!/bin/bash
# Complete Cloudways deployment automation

# Step 1: Verify Git deployment
cat > /tmp/step1.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 30
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) \
          "cd public_html && ls -la drupal10"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF
chmod +x /tmp/step1.sh
echo "Step 1: Verifying Git deployment..."
/tmp/step1.sh

# Step 2: Install Composer dependencies
cat > /tmp/step2.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 600
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) \
          "cd public_html/drupal10 && composer install --no-dev --no-interaction"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF
chmod +x /tmp/step2.sh
echo "Step 2: Installing Composer dependencies..."
/tmp/step2.sh

# Step 3: Clear Drupal cache
cat > /tmp/step3.sh << 'EOF'
#!/usr/bin/expect -f
set timeout 60
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) \
          "cd public_html/drupal10/web && ../vendor/bin/drush cr"
expect "password:"
send "SSH_PASSWORD (see .credentials)\r"
expect eof
EOF
chmod +x /tmp/step3.sh
echo "Step 3: Clearing cache..."
/tmp/step3.sh

echo "✅ Deployment complete!"
```

---

## 💡 Best Practices

### 1. Always Use Timeouts

Set appropriate timeouts based on expected command duration:

```bash
set timeout 30   # For quick commands (ls, pwd, echo)
set timeout 60   # For drush commands (cr, status)
set timeout 600  # For composer install, database imports
```

### 2. Add Error Handling

```bash
#!/usr/bin/expect -f
set timeout 30
spawn ssh -o StrictHostKeyChecking=no \
          -o PreferredAuthentications=password \
          -o PubkeyAuthentication=no \
          SSH_USER (see .credentials)@D7_HOST (see .credentials) "YOUR_COMMAND"
expect {
    "password:" {
        send "SSH_PASSWORD (see .credentials)\r"
        exp_continue
    }
    "Permission denied" {
        puts "\nERROR: Authentication failed!"
        exit 1
    }
    eof
}
```

### 3. Log Output for Debugging

```bash
#!/usr/bin/expect -f
log_file /tmp/ssh_output.log  # Save all output to file
set timeout 30
# ... rest of script
```

### 4. Clean Up Temporary Scripts

```bash
# After running commands, clean up:
rm -f /tmp/ssh_*.sh /tmp/scp_*.sh
```

---

## 🔗 Related Documentation

- **Cloudways Deployment:** `docs/CLOUDWAYS_DEPLOYMENT.md`
- **Deployment Steps:** `CLOUDWAYS_DEPLOYMENT_STEPS.md`
- **Credentials:** `.credentials` (gitignored)

---

## 📝 Summary

**What Works:** ✅ Expect scripts with password-only SSH options

**What Doesn't Work:** ❌ Direct ssh/sshpass without disabling key auth

**Key Requirements:**
1. Use expect scripts
2. Force password authentication
3. Disable SSH key attempts
4. Set appropriate timeouts
5. Use non-interactive command flags

---

**Last Updated:** 2025-11-16
**Verified Working:** ✅ SSH commands, directory listing, file operations
**Pending:** Database uploads (may hit connection timeouts with large files)
