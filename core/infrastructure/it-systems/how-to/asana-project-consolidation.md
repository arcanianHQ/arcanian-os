---
scope: shared
---

# How to Consolidate Asana Client Projects

**Related Rule:** R003 (Client Project Consolidation)

---

## Overview

This guide explains how to migrate from multiple service-specific projects (R002 legacy) to a single consolidated project per client using custom fields (R003).

---

## Prerequisites

1. **Service Type custom field** must exist in the organization's field library
   - Field GID: `1212617835819541`
   - See `how-to/asana-custom-fields.md` for creation instructions

2. **Consolidated project** created with naming: `C:CLIENTNAME`

3. **Service Type field added** to the consolidated project

---

## Migration Steps

### Step 1: Create Consolidated Project

Create a new project for the client:

```
Name: C:CLIENTNAME
Team: Arcanian Consulting (1210213282346183)
```

### Step 2: Add Service Type Custom Field

1. Open the consolidated project
2. Click **Customize** (top right)
3. Click **Add Field**
4. Search for "Service Type"
5. Select the existing field from the library

### Step 3: Identify Source Projects

Find all service-specific projects for the client:

```
C:CLIENT-Data & Analytics
C:CLIENT-Marketing Stratégia
C:CLIENT-Google Ads
C:CLIENT-SEO
C:CLIENT-Facebook/Meta
C:CLIENT-Nexus
```

### Step 4: Migrate Tasks

For each source project:

1. Get all tasks from the project
2. For each task, create a new task in the consolidated project with:
   - Same name
   - Same assignee
   - Same due date
   - Same notes
   - Same completion status
   - **Service Type** set based on source project

**Service Type Mapping:**

| Source Project Suffix | Service Type GID |
|-----------------------|------------------|
| Data & Analytics | `1212617835819543` |
| Marketing Stratégia | `1212617835819546` (Marketing Strategy) |
| Google Ads | `1212617835819545` |
| SEO | `1212617835819548` |
| Facebook/Meta | `1212617835819544` |
| Nexus | `1212617835819547` |

### Step 5: Verify Migration

1. Check task count in consolidated project matches total from source projects
2. Verify Service Type is set correctly on all tasks
3. Confirm assignees and due dates are preserved

### Step 6: Archive Source Projects

After successful migration:

1. Open each source project
2. Click project header dropdown
3. Select **Archive project**

---

## MCP Task Creation Example

```
mcp__asana__asana_create_task(
  name: "Task name",
  project_id: "CONSOLIDATED_PROJECT_GID",
  assignee: "user@email.com",
  due_on: "2025-06-30",
  notes: "Task description",
  completed: false,
  custom_fields: "{\"1212617835819541\": [\"SERVICE_TYPE_GID\"]}"
)
```

---

## Notes

- MCP cannot move tasks between projects; tasks must be recreated
- MCP cannot add custom fields to projects; this must be done manually
- Subtasks are not automatically migrated; handle separately if needed
- Comments/activity history is not migrated; only task data is preserved

---

*Last updated: 2026-01-04*
