---
scope: shared
---

# GTM Framework - Updated Structure (v1.1)

## 🎉 What's New - 3 Major Additions!

### 1. ✅ Container JSON Organization
Two new folders for your container files:
- `containers/client_actual/` - Your deployed containers
- `containers/taggrs_recommended/` - Taggrs templates

### 2. ✅ Naming Convention Guide
Complete guide for consistent file naming:
- `NAMING_CONVENTION.md` - Standards for all files

### 3. ✅ Comprehensive READMEs
Instructions in each container folder:
- How to export containers
- How to name files
- How to organize versions

---

## 📁 Complete Updated Structure

```
gtm_debug_framework/
│
├── 🎯_START_HERE.md                    ⭐ YOUR ENTRY POINT
├── FRAMEWORK_OVERVIEW.md               Complete explanation
├── QUICK_START.md                      Step-by-step guide
├── README.md                           Structure overview
├── FOLDER_STRUCTURE.md                 This guide
├── NAMING_CONVENTION.md                ⭐ NEW - Naming standards
├── CLAUDE_CODE_INSTRUCTIONS.md         For Claude Code
├── DEPRECATED_original_instructions.md (Archive)
│
├── methodology/                        Universal debugging rules
│   ├── 01_core_debugging_process.md
│   ├── 02_data_consistency_rules.md
│   └── 03_meta_event_id_guide.md
│
├── platforms/                          Platform-specific knowledge
│   ├── _PLATFORM_TEMPLATE.md
│   └── wordpress_woocommerce.md
│
├── client_config/                      Your configuration
│   └── CLIENT_CONFIG_TEMPLATE.md
│
└── containers/                         ⭐ NEW - Container JSONs
    │
    ├── client_actual/                  ⭐ Your deployed containers
    │   ├── README.md                   (Instructions)
    │   ├── production_web_YYYYMMDD_v1.json     (you add)
    │   └── production_server_YYYYMMDD_v1.json  (you add)
    │
    └── taggrs_recommended/             ⭐ Taggrs templates
        ├── README.md                   (Instructions)
        ├── taggrs_web_ecommerce_YYYYMMDD.json  (you add)
        └── taggrs_server_ga4_meta_YYYYMMDD.json (you add)
```

---

## 📊 Updated File Count

### Framework Files
- **Root level**: 7 documentation files (+1 new)
- **methodology/**: 3 methodology files
- **platforms/**: 2+ platform files
- **client_config/**: 1 template
- **containers/**: 2 folders with READMEs (+4 new files)

### Your Files (to add)
- **client_config/**: `client_specific.md` (your config)
- **containers/client_actual/**: Your container JSONs (2+)
- **containers/taggrs_recommended/**: Taggrs templates (2+)

**Total Framework**: 17+ files (~25,000 words)

---

## 🎯 Quick Setup Workflow (Updated)

### Step 1: Export Your Containers (5 min)
```
1. Go to Google Tag Manager
2. Admin → Export Container
3. Export web container
4. Export server container
5. Save to: containers/client_actual/
6. Rename following naming convention
```

### Step 2: Add Taggrs Templates (2 min)
```
1. Locate Taggrs template files
2. Copy to: containers/taggrs_recommended/
3. Rename following naming convention
```

### Step 3: Configure Client (10 min)
```
1. Copy: client_config/CLIENT_CONFIG_TEMPLATE.md
2. Save as: client_config/client_specific.md
3. Fill in all details
4. Reference your container file locations
```

### Step 4: Run Analysis (5 min)
```
1. Claude Code with CLAUDE_CODE_INSTRUCTIONS.md
2. Reference your client_specific.md
3. Point to containers/ folder
4. Get comprehensive analysis
```

---

## 📋 Naming Convention Summary

### Container Files

**Client Actual**:
```
{environment}_{type}_{date}_{version}.json

Example:
production_web_20251111_v1.json
```

**Taggrs Templates**:
```
taggrs_{type}_{template}_{date}.json

Example:
taggrs_web_ecommerce_20251101.json
```

### For Complete Guide
See: `NAMING_CONVENTION.md`

---

## 🎓 What Goes Where

### containers/client_actual/
**Put here:**
- ✅ Current production containers (exported from GTM)
- ✅ Staging containers (if testing)
- ✅ Previous versions (for tracking changes)

**Naming:**
- `production_web_20251111_v1.json`
- `production_server_20251111_v1.json`

**See:** `containers/client_actual/README.md`

### containers/taggrs_recommended/
**Put here:**
- ✅ Taggrs template containers
- ✅ Taggrs reference configurations
- ✅ Updated templates (when Taggrs releases new versions)

**Naming:**
- `taggrs_web_ecommerce_20251101.json`
- `taggrs_server_ga4_meta_20251101.json`

**See:** `containers/taggrs_recommended/README.md`

---

## 🔍 How Claude Code Uses These

### Container Analysis Flow

```
1. Read client_specific.md
   ↓
2. Load containers from client_actual/
   ↓
3. Load containers from taggrs_recommended/
   ↓
4. Compare actual vs recommended
   ↓
5. Identify deviations
   ↓
6. Generate reports with findings
```

### What Gets Analyzed

**From client_actual/:**
- Your current tag configuration
- Variable setup
- Trigger logic
- Custom implementations
- Data flow

**From taggrs_recommended/:**
- Best practice baseline
- Recommended configuration
- Standard implementations
- Expected structure

**Comparison:**
- Missing tags
- Extra tags
- Configuration differences
- Naming inconsistencies
- Data flow issues

---

## ✅ Pre-Analysis Checklist (Updated)

Before running Claude Code:

**Container Files:**
- [ ] Web container exported from GTM
- [ ] Server container exported from GTM
- [ ] Files placed in `containers/client_actual/`
- [ ] Files named following convention
- [ ] Taggrs templates in `containers/taggrs_recommended/`

**Configuration:**
- [ ] `client_specific.md` created and filled
- [ ] Container file paths referenced in config
- [ ] Platform identified
- [ ] Business rules documented

**Ready to Analyze:**
- [ ] All files in correct locations
- [ ] Naming conventions followed
- [ ] Client config complete
- [ ] Claude Code ready

---

## 🆕 New Features in v1.1

### 1. Structured Container Management
```
Before: "Put containers somewhere..."
After:  Clear folders with READMEs and examples
```

### 2. Naming Standards
```
Before: "Name them however..."
After:  Specific patterns with validation
```

### 3. Comparison Capability
```
Before: Analyze actual containers only
After:  Compare actual vs Taggrs recommended
```

### 4. Better Organization
```
Before: Files scattered
After:  Everything in logical folders
```

### 5. Complete Documentation
```
Before: Minimal instructions
After:  README in every folder
```

---

## 📥 Download Updated Framework

[**Download Complete Framework v1.1**](computer:///mnt/user-data/outputs/gtm_debug_framework)

**What's Included:**
- ✅ All original files
- ✅ NAMING_CONVENTION.md (new)
- ✅ containers/ folder structure (new)
- ✅ README in each container folder (new)
- ✅ Updated main documentation

---

## 🚀 Migration from v1.0

If you have the old structure:

1. **Create new folders:**
   ```
   mkdir containers
   mkdir containers/client_actual
   mkdir containers/taggrs_recommended
   ```

2. **Move container files:**
   ```
   Move your GTM exports to: containers/client_actual/
   Move Taggrs templates to: containers/taggrs_recommended/
   ```

3. **Rename files:**
   ```
   Follow NAMING_CONVENTION.md patterns
   ```

4. **Download new files:**
   - NAMING_CONVENTION.md
   - containers/client_actual/README.md
   - containers/taggrs_recommended/README.md

5. **Update references:**
   - Update client_specific.md with new container paths

---

## 📚 Documentation Quick Links

| Document | Purpose | Link |
|----------|---------|------|
| START HERE | Entry point | [View](computer:///mnt/user-data/outputs/gtm_debug_framework/🎯_START_HERE.md) |
| Naming Convention | File naming standards | [View](computer:///mnt/user-data/outputs/gtm_debug_framework/NAMING_CONVENTION.md) |
| Client Containers README | Export instructions | [View](computer:///mnt/user-data/outputs/gtm_debug_framework/containers/client_actual/README.md) |
| Taggrs Templates README | Template instructions | [View](computer:///mnt/user-data/outputs/gtm_debug_framework/containers/taggrs_recommended/README.md) |
| Folder Structure | Complete structure | [View](computer:///mnt/user-data/outputs/gtm_debug_framework/FOLDER_STRUCTURE.md) |

---

## 🎯 Next Steps

1. **Download** the updated framework
2. **Read** NAMING_CONVENTION.md
3. **Export** your containers following the guide
4. **Organize** files in correct folders
5. **Run** analysis with Claude Code

---

**Framework Version**: 1.1  
**Updated**: November 11, 2025  
**Changes**: Added container organization, naming convention guide, comprehensive READMEs  
**Status**: Production Ready ✅
