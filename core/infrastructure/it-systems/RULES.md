---
scope: shared
---

# Arcanian Rules

This document contains the operational rules and conventions for Arcanian.

---

## R001: Asana Project Naming Convention

**Identifier:** R001
**Category:** Project Management
**Status:** Active

### Rule

All Asana projects must follow the naming convention: `PREFIX:NAME` or `PREFIX:CLIENT-SERVICE`

### Prefixes

| Prefix | Meaning | Usage |
|--------|---------|-------|
| `A:` | Arcanian | Internal Arcanian projects, admin, operations |
| `C:` | Client | Client-related projects |
| `DH:` | DH Division | DH-specific projects |
| `NX:` | Nexus | Nexus-related projects |

### Client Project Hierarchy

For client projects with multiple services, use the following structure:

```
C:CLIENT           → Main client project
C:CLIENT-SERVICE   → Service-specific sub-project
```

**Example:**
```
C:DIEGO
├── C:DIEGO-Data & Analytics
├── C:DIEGO-Marketing Stratégia
├── C:DIEGO-Google Ads
├── C:DIEGO-SEO
├── C:DIEGO-Facebook/Meta
└── C:DIEGO-Nexus
```

### Exceptions

- `Inbox` - General inbox project (no prefix required)

---

## R002: Full-Service Client Structure (Legacy)

**Identifier:** R002
**Category:** Project Management
**Status:** Legacy (superseded by R003)

### Rule

~~A full-service client must have the following project structure with 6 standard service types:~~

```
C:CLIENT
├── C:CLIENT-Data & Analytics
├── C:CLIENT-Marketing Stratégia
├── C:CLIENT-Google Ads
├── C:CLIENT-SEO
├── C:CLIENT-Facebook/Meta
└── C:CLIENT-Nexus
```

### Standard Service Types

| Service | Description |
|---------|-------------|
| Data & Analytics | Tracking, GTM, pixels, data integration, reporting |
| Marketing Stratégia | Overall marketing strategy |
| Google Ads | Google Ads campaigns |
| SEO | Search engine optimization |
| Facebook/Meta | Facebook and Meta advertising |
| Nexus | Arcanian Nexus service |

### Notes

- **This rule is superseded by R003** - New clients should use consolidated projects
- Existing service-specific projects will be migrated to consolidated structure
- Service types are now managed via custom fields instead of separate projects

---

## R003: Client Project Consolidation

**Identifier:** R003
**Category:** Project Management
**Status:** Active

### Rule

Full-service clients use **one consolidated project** per client. Tasks are categorized using the **Service Type** custom field.

### Project Naming

```
C:CLIENTNAME
```

**Examples:**
- `C:DIEGO`
- `C:DLX`
- `C:VRS`

### Service Type Custom Field

| Field Property | Value |
|----------------|-------|
| Field GID | `1212617835819541` |
| Type | Multi-select dropdown |

### Service Type Options

| Option | GID | Description |
|--------|-----|-------------|
| Consultancy | `1212617835819542` | General consulting work |
| Data & Analytics | `1212617835819543` | Tracking, GTM, pixels, data integration, reporting |
| Facebook/Meta | `1212617835819544` | Facebook and Meta advertising |
| Google Ads | `1212617835819545` | Google Ads campaigns |
| Marketing Strategy | `1212617835819546` | Overall marketing strategy |
| Nexus | `1212617835819547` | Arcanian Nexus service |
| SEO | `1212617835819548` | Search engine optimization |
| Software Development | `1212617835819549` | Custom software development |
| TBD | `1212647007060403` | To be determined |

### Creating Tasks with Service Type

When creating tasks, set the custom field:

```
mcp__asana__asana_create_task(
  name: "Task name",
  project_id: "PROJECT_GID",
  custom_fields: "{\"1212617835819541\": [\"OPTION_GID\"]}"
)
```

### Migration from R002

Existing clients with separate service projects should be migrated:
1. Create consolidated project `C:CLIENTNAME`
2. Add Service Type custom field to project
3. Migrate tasks from service projects with appropriate Service Type
4. Archive old service projects

---
