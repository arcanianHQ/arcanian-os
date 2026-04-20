---
scope: shared
---

# Quick Start Guide - GTM Debugging with Claude Code

## For Developers: How to Use This Framework

### Step 1: Fill In Your Client Configuration (5-10 minutes)

1. Copy `client_config/CLIENT_CONFIG_TEMPLATE.md`
2. Save as `client_config/client_specific.md`
3. Fill in all sections with your actual implementation details

**Most Critical Fields** (don't skip these!):
- Platform and version
- Taggrs template folder location
- Product ID format (SKU/ID/Custom)
- Tax inclusion (does price include tax?)
- Event ID generation method (for Meta)
- Currency

### Step 2: Point Claude Code to the Framework

Open Claude Code in your terminal and provide this context:

```bash
# Navigate to your project
cd /path/to/your/project

# Start Claude Code with context
claude-code

# Then in Claude Code, reference the framework:
@/path/to/gtm_debug_framework/CLAUDE_CODE_INSTRUCTIONS.md

# Provide your client config location:
My client configuration is at: @/path/to/client_specific.md
My Taggrs templates are in: @/path/to/taggrs_templates/

Please analyze my GTM implementation for data consistency issues.
```

### Step 3: Let Claude Code Work

Claude Code will:
1. Load the framework structure
2. Identify your platform from client config
3. Load platform-specific knowledge
4. Analyze your Taggrs templates
5. Generate comprehensive reports

### Step 4: Review Generated Reports

Claude Code will generate:
- `EXECUTIVE_SUMMARY.md` - High-level findings
- `TECHNICAL_ANALYSIS.md` - Detailed technical report
- `ISSUES_DETAILED.csv` - Structured issue list
- `FIX_RECOMMENDATIONS.md` - How to fix each issue
- `TESTING_PLAN.md` - How to verify fixes

## For Analysts: Adding a New Platform

If you need to add platform support:

1. Copy `platforms/_PLATFORM_TEMPLATE.md`
2. Rename to `platforms/your_platform.md`
3. Fill in platform-specific details:
   - Default data layer structure
   - Product ID conventions
   - Common issues
   - Platform quirks
4. Update `README.md` to list the new platform

## For Taggrs Users: Quick Setup

If you're using Taggrs:

1. Your Taggrs consultant should have provided:
   - Container JSON files (usually in a folder)
   - Documentation of your setup
   
2. Fill in client config:
   ```
   Taggrs Integration: Yes
   Template Folder Location: /path/to/taggrs_templates
   Client Container: client_container.json
   Server Container: server_container.json
   ```

3. Point Claude Code to both:
   - The framework: `CLAUDE_CODE_INSTRUCTIONS.md`
   - Your Taggrs folder: `/path/to/taggrs_templates`

## Common Use Cases

### Use Case 1: Initial Audit
**Goal**: Understand what's working and what's not

**Command**:
```
Load the framework and analyze my GTM setup. 
Focus on product ID consistency and Meta event ID matching.
Generate all reports.
```

### Use Case 2: Troubleshooting Specific Issue
**Goal**: Understand why Meta conversions are doubled

**Command**:
```
Load the framework. I'm seeing doubled Meta conversions.
Focus your analysis on event_id matching between client and server.
Show me exactly where the mismatch is happening.
```

### Use Case 3: Pre-Launch Verification
**Goal**: Verify everything before going live

**Command**:
```
Load the framework and verify my GTM setup against:
1. Platform best practices (for [your platform])
2. Data consistency rules
3. Meta event ID requirements

Generate a launch checklist.
```

### Use Case 4: Post-Migration Check
**Goal**: Verify migration from old system didn't break anything

**Command**:
```
Load the framework. We just migrated from [old setup] to Taggrs.
Compare our implementation against [platform] standards.
Identify any data consistency issues that might affect historical data comparison.
```

## Framework File Reference

### Core Files (Don't modify these)
```
methodology/
├── 01_core_debugging_process.md    # Universal debugging steps
├── 02_data_consistency_rules.md    # What must match
└── 03_meta_event_id_guide.md       # Event ID deduplication
```

### Platform Files (Reference, don't modify unless updating)
```
platforms/
├── _PLATFORM_TEMPLATE.md           # Template for new platforms
├── wordpress_woocommerce.md        # WooCommerce specific
├── shopify.md                      # Shopify specific
├── magento.md                      # Magento specific
└── [others as needed]
```

### Your Files (YOU modify these)
```
client_config/
├── CLIENT_CONFIG_TEMPLATE.md       # Copy this
└── client_specific.md              # Your actual config
```

## Tips for Best Results

### Do's ✅
- ✅ Fill in client config completely and accurately
- ✅ Provide real product IDs/SKUs as examples
- ✅ Specify exact folder path to Taggrs templates
- ✅ Be explicit about business rules (e.g., "we always use parent SKU")
- ✅ Note any known issues or customizations
- ✅ Provide test product URLs for validation

### Don'ts ❌
- ❌ Don't skip filling in client config
- ❌ Don't assume Claude Code knows your setup
- ❌ Don't provide generic examples (use YOUR actual data)
- ❌ Don't forget to specify tax inclusion/exclusion
- ❌ Don't leave currency ambiguous if you use multiple
- ❌ Don't forget to document custom events/variables

## Expected Time Investment

- **Initial Setup** (client config): 10-15 minutes
- **Claude Code Analysis**: 5-15 minutes (automatic)
- **Report Review**: 15-30 minutes
- **Issue Prioritization**: 15-30 minutes
- **Implementation of Fixes**: Varies by issue count

**Total**: ~1-2 hours for complete audit and action plan

## Getting Help

### Framework Issues
If the framework itself has issues or you find gaps:
1. Check if platform file exists for your platform
2. If not, use `_PLATFORM_TEMPLATE.md` to create one
3. Update `README.md` if you add a platform

### Client-Specific Questions
If you're unsure how to fill in client config:
1. Check your platform's admin panel (links in platform files)
2. Consult with your developer/Taggrs contact
3. Look at your website's actual data layer (browser DevTools)
4. Check GTM container for variable configurations

### Claude Code Questions
Refer to Claude Code documentation:
https://docs.claude.com/en/docs/claude-code

## Success Indicators

You'll know it's working when:
- ✅ Claude Code correctly identifies your platform
- ✅ Analysis references YOUR specific product IDs
- ✅ Reports mention YOUR container variable names
- ✅ Issues are specific, not generic
- ✅ Fix recommendations reference YOUR implementation
- ✅ Testing plan uses YOUR test products

If reports are too generic, you likely need to provide more detail in client config!

## What This Framework Does NOT Do

This framework helps Claude Code:
- ❌ It doesn't automatically fix issues (Claude Code can suggest fixes)
- ❌ It doesn't access your live site (you provide the data)
- ❌ It doesn't make changes to your GTM containers
- ❌ It doesn't have opinions on your business rules (it documents them)

It's an analysis and documentation framework, not an automation tool.

## Next Steps After Analysis

1. **Review Reports**: Read executive summary first
2. **Prioritize**: Focus on P0 (Critical) issues first
3. **Plan Fixes**: Use fix recommendations as guide
4. **Test**: Follow testing plan before deploying
5. **Document**: Keep client config updated with changes
6. **Re-analyze**: Run analysis again after fixes to verify

## Example Workflow

```
Day 1 Morning:
- Fill in client_config/client_specific.md
- Run initial analysis with Claude Code
- Review reports

Day 1 Afternoon:
- Prioritize issues with team
- Plan fix implementation

Day 2:
- Implement P0 fixes
- Test using generated testing plan

Day 3:
- Implement P1 fixes
- Re-run analysis to verify
- Deploy to production
- Monitor
```

---

**Ready to start? Fill in your client config and point Claude Code to CLAUDE_CODE_INSTRUCTIONS.md!**
