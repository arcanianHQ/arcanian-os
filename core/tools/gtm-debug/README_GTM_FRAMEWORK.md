---
scope: shared
---

# GTM Debugging Framework - Structure Overview

## Purpose
This framework provides a scalable, modular approach to debugging GTM (Google Tag Manager) implementations across different e-commerce platforms and client-specific configurations.

## Framework Structure

```
gtm_debug_framework/
├── README.md                          # This file
├── CLAUDE_CODE_INSTRUCTIONS.md        # Main instructions for Claude Code
├── methodology/
│   ├── 01_core_debugging_process.md   # Platform-agnostic debugging methodology
│   ├── 02_data_consistency_rules.md   # Universal data consistency requirements
│   └── 03_meta_event_id_guide.md      # Meta/Facebook event ID deduplication
├── platforms/
│   ├── _PLATFORM_TEMPLATE.md          # Template for adding new platforms
│   ├── wordpress_woocommerce.md       # WordPress/WooCommerce specific
│   ├── magento.md                     # Magento/Adobe Commerce specific
│   ├── shopify.md                     # Shopify specific
│   ├── shoprenter.md                  # Shoprenter specific (Hungarian)
│   └── unas.md                        # Unas specific (Hungarian)
└── client_config/
    ├── CLIENT_CONFIG_TEMPLATE.md      # Template for client-specific config
    └── client_specific.md             # Your client's specific configuration
```

## How It Works

### 1. Core Methodology (Platform-Agnostic)
The `methodology/` folder contains universal debugging principles that apply regardless of platform:
- Data consistency verification steps
- Event ID matching requirements
- Container analysis procedures
- Report generation guidelines

### 2. Platform-Specific Knowledge
The `platforms/` folder contains detailed information about how each e-commerce platform implements:
- Data layer structure and naming conventions
- Default product ID formats
- Price handling (tax inclusion, decimal separators)
- Checkout flow event sequencing
- Common platform-specific issues
- Plugin/extension considerations

### 3. Client-Specific Configuration
The `client_config/` folder contains:
- Your specific implementation details
- Custom variables and modifications
- Taggrs template locations
- Specific business rules (e.g., "we use parent SKU not variant SKU")
- Known customizations or extensions

## Usage Flow for Claude Code

```
1. Read CLAUDE_CODE_INSTRUCTIONS.md (main entry point)
   ↓
2. Identify platform from client_config/client_specific.md
   ↓
3. Load methodology/* (universal rules)
   ↓
4. Load platforms/{identified_platform}.md (platform-specific knowledge)
   ↓
5. Load client_config/client_specific.md (client overrides & specifics)
   ↓
6. Execute debugging with combined knowledge
   ↓
7. Generate platform-aware and client-aware reports
```

## Customization

### Adding a New Platform
1. Copy `platforms/_PLATFORM_TEMPLATE.md`
2. Rename to `platforms/{platform_name}.md`
3. Fill in platform-specific details
4. Update this README

### Adding Client Configuration
1. Copy `client_config/CLIENT_CONFIG_TEMPLATE.md`
2. Rename to `client_config/client_specific.md` (or use client name)
3. Fill in all client-specific details
4. Reference Taggrs template locations

## Benefits of This Structure

✅ **Scalable**: Easy to add new platforms or clients  
✅ **Modular**: Each file has a single responsibility  
✅ **Reusable**: Core methodology applies to all projects  
✅ **Maintainable**: Update platform knowledge without touching methodology  
✅ **Context-Aware**: Claude Code gets full context (general + platform + client)  
✅ **Version Controlled**: Each component can be versioned separately

## Quick Start

1. Fill in `client_config/client_specific.md` with your details
2. Point Claude Code to `CLAUDE_CODE_INSTRUCTIONS.md`
3. Let Claude Code analyze using combined knowledge from all three layers

## File Relationships

```
Core Methodology (Universal)
      ↓
Platform Knowledge (E-commerce System Specific)
      ↓
Client Configuration (Your Implementation)
      ↓
Debugging Execution with Full Context
```

Each layer adds specificity without contradicting previous layers.
