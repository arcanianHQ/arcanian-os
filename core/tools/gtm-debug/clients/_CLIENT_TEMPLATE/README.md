---
scope: shared
---

# Client Actual Containers

## Purpose

This folder contains **your actual, deployed GTM container JSON exports** from your production, staging, or development environments.

These are the containers currently running on your website that Claude Code will analyze for issues.

---

## What Goes Here

### Container Types

**Client-Side (Web) Containers:**
- Containers that run in the user's browser
- Usually have container IDs like `GTM-XXXXXX`
- Handle client-side tracking (pixels, client-side GA4, etc.)

**Server-Side Containers:**
- Containers that run on your server
- Usually have container IDs like `GTM-YYYYYYY`
- Handle server-side tracking (GA4 Measurement Protocol, Meta CAPI, etc.)

---

## How to Export Containers

### Export from GTM Interface

1. **Log in to Google Tag Manager**
   - Go to: https://tagmanager.google.com

2. **Select Your Container**
   - Click on the container you want to export

3. **Go to Admin → Export Container**
   - Admin (top right) → Export Container

4. **Select Version**
   - Choose current workspace (latest)
   - Or select a published version

5. **Export**
   - Click "Export"
   - Save the JSON file

6. **Rename File**
   - Follow naming convention: `{env}_{type}_{date}_{ver}.json`
   - Example: `production_web_20251111_v1.json`

7. **Place in This Folder**
   - Save to: `containers/client_actual/`

---

## Naming Convention

**Format:**
```
{environment}_{container_type}_{date}_{version}.json
```

**Components:**
- `environment`: production | staging | dev
- `container_type`: web | server
- `date`: YYYYMMDD format
- `version`: v1, v2, v3 (increment for same-day exports)

**Examples:**
```
✅ production_web_20251111_v1.json
✅ production_server_20251111_v1.json
✅ staging_web_20251110_v2.json
✅ dev_web_20251015_v1.json
```

See `NAMING_CONVENTION.md` for complete guide.

---

## Typical Setup

Most clients will have **2 containers**:

```
containers/client_actual/
├── production_web_20251111_v1.json       (client-side container)
└── production_server_20251111_v1.json    (server-side container)
```

Some clients may have additional environments:
```
containers/client_actual/
├── production_web_20251111_v1.json
├── production_server_20251111_v1.json
├── staging_web_20251110_v1.json
└── staging_server_20251110_v1.json
```

---

## Version Control

### Multiple Exports Same Day
If you export multiple times in one day:
```
production_web_20251111_v1.json  (first export)
production_web_20251111_v2.json  (after fix)
production_web_20251111_v3.json  (after another change)
```

### Tracking Changes Over Time
Keep dated exports to track evolution:
```
production_web_20251101_v1.json  (Nov 1)
production_web_20251115_v1.json  (Nov 15 - after updates)
production_web_20251130_v1.json  (Nov 30 - after fixes)
```

---

## What Claude Code Does With These Files

1. **Parses JSON Structure**
   - Reads all tags, triggers, variables
   - Identifies configuration

2. **Analyzes for Issues**
   - Data consistency problems
   - Meta event_id mismatches
   - Product ID inconsistencies
   - Price format issues

3. **Compares Client vs Server**
   - If you have both web and server containers
   - Verifies data flows correctly between them

4. **Generates Reports**
   - Issues found
   - Fix recommendations
   - Testing plan

---

## Security Note

⚠️ **These files may contain sensitive information:**
- API keys (GA4 Measurement IDs, Meta Pixel IDs)
- Container configurations
- Business logic

**Recommendations:**
- Don't commit to public repositories
- Add to `.gitignore` if needed
- Share securely with consultants
- Remove before sharing publicly

**If using Git:**
```gitignore
# .gitignore
containers/client_actual/*.json
```

---

## Checklist Before Analysis

Before running Claude Code analysis, ensure:

- [ ] Containers exported from GTM
- [ ] Files named according to convention
- [ ] Both web and server containers included (if applicable)
- [ ] Files are current (recently exported)
- [ ] Files placed in `containers/client_actual/` folder
- [ ] Client config updated with container locations

---

## Common Issues

### "My export has a different structure"
GTM exports are standardized JSON. If structure looks different:
- Verify you exported from GTM (not a different tool)
- Check you downloaded the complete file
- Ensure it's a container export (not workspace or version)

### "Which version should I export?"
- **For analysis**: Export current workspace (latest changes)
- **For production state**: Export latest published version
- **For debugging**: Export the version currently live on site

### "I have multiple workspaces"
Export the workspace you want analyzed. Usually:
- Default Workspace (current changes)
- Or specific workspace you're working on

---

## Example Workflow

1. **Export Containers**
   ```
   GTM → Admin → Export Container → Save
   ```

2. **Rename Files**
   ```
   GTM-ABC123-export.json → production_web_20251111_v1.json
   GTM-XYZ789-export.json → production_server_20251111_v1.json
   ```

3. **Place in Folder**
   ```
   Move to: containers/client_actual/
   ```

4. **Update Client Config**
   ```
   Edit: client_config/client_specific.md
   Add: Container file locations
   ```

5. **Run Analysis**
   ```
   Claude Code → Analyze containers
   ```

---

## Need Help?

- **Export Issues**: See GTM documentation
- **Naming Questions**: See `NAMING_CONVENTION.md`
- **Analysis Questions**: See `QUICK_START.md`

---

**Ready to analyze?** Make sure you have your container files here, then proceed to client configuration!

Last Updated: November 11, 2025
