---
scope: shared
---

# Deployment Steps for External System

All credentials are stored in `.credentials` file.

## Step 1: Push code to GitHub

**Run locally:**
```bash
git push origin main
```

---

## Step 2: Pull code on D10 server

**SSH to D10:** `kocsid10ssh@159.223.220.3`

**Commands:**
```bash
cd ~/public_html
git stash
git pull origin main
git stash pop

# Check for deleted/modified Porto theme files
git status web/themes/contrib/porto_theme/

# If any deleted/modified Porto files found:
git restore web/themes/contrib/porto_theme/
```

---

## Step 3: Composer install (if needed)

**On D10 server:**
```bash
cd ~/public_html

# Check if needed
if [ ! -f vendor/autoload.php ]; then
  composer install --no-dev --optimize-autoloader
fi
```

---

## Step 4: Sync files from D7 to D10

**⚠️ CRITICAL STEP** - This is the file transfer step (~1.8GB, 5-10 minutes)

### Option A: Server-to-server (requires manual password entry)

**SSH to D10:** `kocsid10ssh@159.223.220.3`

```bash
cd ~/public_html/web/sites/default/files

rsync -avz --progress \
  kocsibeall.ssh.d10@165.22.200.254:/home/969836.cloudwaysapps.com/pajfrsyfzm/public_html/sites/default/files/ \
  ./

# When prompted, enter password: D10Test99!

# Set permissions
chmod -R 755 .

  rsync -avz --progress \
    -e "ssh -o StrictHostKeyChecking=no" \
    kocsibeall.ssh.d10@165.22.200.254:/home/969836.cloudwaysapps.com/pajfrsyfzm/public_html/sites/default/files/ \
    ~/test/


```

### Option B: Via local Mac (fully automated)

**Run locally (requires sshpass):**

```bash
# Create temp directory
mkdir -p /tmp/d7-files

# Step 1: Download from D7 to Mac
sshpass -p 'D10Test99!' rsync -avz \
  -e "ssh -o StrictHostKeyChecking=no" \
  kocsibeall.ssh.d10@165.22.200.254:/home/969836.cloudwaysapps.com/pajfrsyfzm/public_html/sites/default/files/ \
  /tmp/d7-files/

# Step 2: Upload from Mac to D10
sshpass -p 'KCSIssH3497!' rsync -avz \
  -e "ssh -o StrictHostKeyChecking=no" \
  /tmp/d7-files/ \
  kocsid10ssh@159.223.220.3:~/public_html/web/sites/default/files/

# Clean up
rm -rf /tmp/d7-files
```

---

## Step 5: Migrate content article images

**⚠️ NEW STEP** - Fix private:// files used in content articles

**On D10 server:**
```bash
cd ~/public_html
./scripts/migrate-private-files-to-public.sh
```

**What this does:**
- Copies content article images from private/ to public directory
- Updates database URIs from `private://` to `public://`
- **Preserves webform attachments** (stays private)
- Creates database backup before changes

**See**: `docs/PRIVATE_FILE_MIGRATION.md` for details

---

## Step 6: Import configuration

**On D10 server:**
```bash
cd ~/public_html/web
../vendor/bin/drush config:import -y
```

**⚠️ Troubleshooting:** If config import fails with theme dependency errors (e.g., "block.block.bartik_system_main konfiguráció egy másik sminket igényel"), this means there are unused theme block configs in `config/sync/` blocking the import.

**Fix:** Delete unused theme blocks locally and push:
```bash
# On local Mac
cd /Volumes/T9/Sites/kocsibeallo-hu/config/sync
rm block.block.bartik*.yml block.block.ohm*.yml block.block.omega*.yml \
   block.block.porto_sub*.yml block.block.tweme*.yml block.block.zen*.yml
git add -u config/sync/
git commit -m "Remove unused theme block configs"
git push origin main

# Then retry deployment from Step 2
```

See `docs/GALLERY_FIELD_DISPLAY_FIX.md` for details.

---

## Step 7: Fix localhost image URLs

**⚠️ NEW STEP** - Fix localhost:8090 URLs in content

**On D10 server:**
```bash
cd ~/public_html/web
../vendor/bin/drush sql-query --file=../database/migrations/fix_localhost_image_urls.sql
```

**What this does:**
- Fixes 29 nodes with localhost:8090 image URLs
- Replaces absolute localhost URLs with relative paths
- Creates backup before changes

**Affected pages**: Blog posts, Palram pages, product pages

---

## Step 8: Import slideshow data

**⚠️ NEW STEP** - Import homepage slideshow (MD Slider)

**On D10 server:**
```bash
cd ~/public_html/web
../vendor/bin/drush sql-query --file=../database/migrations/md_slider_homepage.sql
```

**What this does:**
- Imports homepage slideshow configuration
- Adds 8 slides with images
- References slideshow image files (must be synced in Step 4)

**See**: `docs/SLIDESHOW_MIGRATION.md` for details

---

## Step 9: Database updates

**On D10 server:**
```bash
cd ~/public_html/web
../vendor/bin/drush updatedb -y
```

---

## Step 10: Clear cache

**⚠️ CRITICAL** - Clear cache after ANY deployment (config, CSS, code changes)

**On D10 server:**
```bash
cd ~/public_html/web
../vendor/bin/drush cache:rebuild
```

**Why this is critical:**
- **CSS changes** are cached by Drupal - won't apply without cache clear
- **Config changes** are cached - won't take effect without cache clear
- **Twig templates** are cached
- **Theme registry** is cached

**If gallery grid layout doesn't appear**: You forgot to clear cache!

---

## Step 11: Fix sitemap

**⚠️ ONE-TIME FIX** - Only needed on first deployment or if sitemap is missing pages

**On D10 server:**
```bash
cd ~/public_html
./scripts/fix-sitemap.sh
```

**What this does:**
- Enables sitemap generation for all content types
- Regenerates sitemap with all 200+ URLs
- Gallery pages, blog posts, basic pages now indexed

**Expected result:**
- Before: 1 URL in sitemap (homepage only)
- After: 200+ URLs in sitemap (matching D7: 265)

**See**: `docs/SITEMAP_FIX.md` for details

---

## Credentials

From `.credentials` file:

### D10 Production Server
- **Host:** 159.223.220.3
- **User:** kocsid10ssh
- **Password:** KCSIssH3497!
- **Path:** ~/public_html

### D7 Old Server (files source)
- **Host:** 165.22.200.254
- **User:** kocsibeall.ssh.d10
- **Password:** D10Test99!
- **Files Path:** /home/969836.cloudwaysapps.com/pajfrsyfzm/public_html/sites/default/files

### Database (on D10)
- **Host:** localhost
- **Name:** xmudbprchx
- **User:** xmudbprchx
- **Password:** 9nJbkdMBbM

---

## Critical Notes

1. **Step 4 (File sync) is the blocker**
   - Option A: Requires manual password entry on D10 server
   - Option B: Fully automated via local Mac with sshpass

2. **Git restore Porto theme** MUST happen before cache clear
   - Restores custom CSS, JS, and templates
   - Path: `web/themes/contrib/porto_theme/`

3. **File sync takes 5-10 minutes** (~1.8GB transfer)

4. **Step 5 (Private file migration) is NEW**
   - Must run AFTER file sync (Step 4)
   - Fixes content article images with private:// URIs
   - **Preserves webform attachments** (keeps them private)
   - See `docs/PRIVATE_FILE_MIGRATION.md` for details

5. **Step 7 (Localhost URL fix) is NEW**
   - Fixes 29 nodes with localhost:8090 image URLs
   - Must run before cache clear
   - Affects blog posts, Palram pages, product pages

6. **Step 8 (Slideshow import) is NEW**
   - Must run AFTER file sync (Step 4)
   - Imports homepage slideshow data into database
   - See `docs/SLIDESHOW_MIGRATION.md` for details

7. **Run steps in order** - don't skip any

8. **After deployment, verify:**
   - Homepage: https://phpstack-958493-6003495.cloudwaysapps.com/
   - Gallery listing: https://phpstack-958493-6003495.cloudwaysapps.com/kepgaleria
   - **Gallery pages** (100+ pages affected):
     - https://phpstack-958493-6003495.cloudwaysapps.com/ximax-portoforte-y-dupla-eloregyartott-kocsibeallo-ivelt-tetovel
     - https://phpstack-958493-6003495.cloudwaysapps.com/egyedi-igenyek-szerint-tervezett-modern-kocsibeallo
     - **Verify**: 2-column grid layout (desktop), hover effects work
   - **Slideshow**: Check homepage slideshow appears and images display correctly
   - **Content articles**: Check article images load correctly (no 404 errors)
   - **Blog posts**: Check blog images display correctly
   - **Product pages**: Check Palram, fedett parkoló pages have images
   - **Sitemap**: https://phpstack-958493-6003495.cloudwaysapps.com/sitemap.xml
     - **Verify**: Shows "A hivatkozások száma a webhelytérképen: 200+" (not just 1)

---

## Why Server-to-Server is Limited

D10 server does **not** have:
- ❌ `sshpass` (can't install without sudo)
- ❌ `expect` (not installed)
- ❌ SSH keys to D7 (user prefers passwords)

**Therefore:** The only fully automated option is **Option B** (via local Mac).

Option A works but requires someone to enter the D7 password when prompted during the rsync command.

---

**Last Updated:** 2025-11-17
