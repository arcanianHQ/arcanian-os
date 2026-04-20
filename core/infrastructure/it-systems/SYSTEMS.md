---
scope: shared
---

# Connected Systems Documentation

> **INTERNAL ONLY — core/ repo (László only).** Contains team emails and system IDs.
> Never copy to client repos. Never commit API tokens here — use .env files.

This document contains configuration details and usage instructions for connected systems.

---

## Arcanian Team

| Name | Role | Email | Asana GID |
|------|------|-------|-----------|
| László Fazakas | Co-founder | laszlo.fazakas@arcanian.ai | `1210213396806890` |
| Dóra Diószegi | Co-founder | dora.dioszegi@arcanian.ai | `1210280424575354` |
| Éva Erdei | Co-worker | eva.erdei@arcanian.ai | `1210519907330840` |

---

## Systems & MCP Connections

This section documents all systems used at Arcanian and their MCP (Model Context Protocol) availability for Claude Code.

| System | MCP Available | Auth Method | Status | Lead Account | Notes |
|--------|---------------|-------------|--------|--------------|-------|
| Asana | Yes | Personal Access Token | Active | laszlo.fazakas@arcanian.ai | Full API access |
| GitHub | Yes | Personal Access Token | Active | info@arcanian.ai | Limited access to private repos |
| Todoist | Yes | OAuth2 (browser) | Active | laszlo.fazakas@arcanian.ai | Task management, hosted MCP server |
| Forklift | No | - | Active | - | macOS file manager |
| Tailscale | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | Zero-config mesh VPN |
| Ubiquiti/UniFi | No | Browser-based | Active | - | Network infrastructure |
| SSH (macOS) | No | Key-based | Active | - | Remote terminal access |
| Screen Sharing | No | Password | Active | - | macOS remote GUI access |
| Zoom | No | SSO/Email | Active | hello@arcanian.cloud | Teleconferencing |
| Akiflow | No | Email | Active | laszlo.fazakas@arcanian.ai | Daily to-do & time boxing |
| Linear | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | Issue tracking & project management |
| HubSpot | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | CRM & marketing automation |
| Loom | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | Screen recording + webcam capture |
| Vimeo Pro | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | Video hosting, showcases, embed |
| Descript | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | AI video editing (transcript-based) |
| Canva | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | Design: title screens, thumbnails, brand kit |
| Elgato Facecam | No | — | Active | — | Camera, mounted behind Prompter |
| Elgato Prompter | No | — | Active | — | Teleprompter, Facecam sits behind glass |
| RodeCaster Duo | No | — | Active | — | Audio mixer/interface, USB to Mac, 48kHz/24-bit |
| Stream Deck | No | — | Active | — | Hardware shortcuts, scene switching, recording control |
| Godox ES45 | No | — | Active | — | Key light (1x), LED panel |
| Godox ES30 | No | — | Active | — | Fill + hair/rim light (2x), LED panel |
| RGB color lights (x2) | No | — | Active | — | Background accent lighting |
| Rode Wireless GO II | No | — | Active | — | Wireless mic — video voice recording (into RodeCaster) |
| Boya BoyaLink 3 | No | — | Active | — | Wireless mic — dedicated to Wispr Flow dictation |
| Wispr Flow | No | — | Active | — | AI voice-to-text dictation (script drafting, notes) |
| LG 35" Ultrawide | No | — | Active | — | Primary demo display (Loom records this screen) |
| Tresorit | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | Encrypted cloud storage (EU), video + file backup |
| Soundverse DNA | No | SSO/Email | Active | laszlo.fazakas@arcanian.ai | AI sonic branding — generates raw material, Agent mode for brand briefs |
| Audacity | No | — | Active | — | Precision audio editing — sculpt sonic logo clips from Soundverse output |

### Authentication Methods

| Method | Description | Setup |
|--------|-------------|-------|
| Personal Access Token | Long-lived token generated in system settings | Manual token creation, stored in MCP config |
| OAuth2 | Browser-based authentication flow | Redirect to auth page, token refresh handled automatically |
| Browser-based | Session cookie authentication | Login via browser, session shared with MCP |

### Asana MCP

- **Auth:** Personal Access Token
- **Capabilities:** Full API access (read/write projects, tasks, users, etc.)
- **Limitations:** Cannot rename projects (no update project endpoint exposed)

### GitHub MCP

- **Auth:** Personal Access Token
- **Capabilities:** Repository access, issues, PRs, file operations
- **Limitations:** May not access private repos depending on token scope; cannot create repos (permission denied)

### Todoist MCP

- **Auth:** OAuth2 (browser-based, first use triggers auth)
- **Server URL:** `https://ai.todoist.net/mcp`
- **Capabilities:** Full task/project/section/label/comment management
- **Setup:** `claude mcp add --transport http todoist https://ai.todoist.net/mcp`

---

## Asana

### Workspace

| Property | Value |
|----------|-------|
| Workspace Name | arcanian.ai |
| Workspace GID | `1206169144105850` |

### Teams

| Team Name | GID | Usage |
|-----------|-----|-------|
| Arcanian Consulting | `1210213282346183` | Client projects (C:) |
| Dora's First Team | `1210280470659247` | - |
| Laszlo's First Team | `1206169144105852` | - |

### Default User

| Property | Value |
|----------|-------|
| Name | Laszlo Fazakas |
| Email | laszlo.fazakas@arcanian.ai |
| User GID | `1210213396806890` |

### Creating Projects

When creating projects in Asana:

1. **Team is required** - The workspace is an organization, so a `team` parameter must be specified
2. **Use Arcanian Consulting team** (`1210213282346183`) for client projects
3. **Follow naming convention** - See R001 in RULES.md

**Example:**
```
mcp__asana__asana_create_project(
  name: "C:CLIENT-Service",
  team: "1210213282346183"
)
```

### Project Prefixes Reference

| Prefix | Meaning | Team |
|--------|---------|------|
| `A:` | Arcanian internal | Arcanian Consulting |
| `C:` | Client | Arcanian Consulting |
| `DH:` | DH Division | Arcanian Consulting |
| `NX:` | Nexus | Arcanian Consulting |

### Custom Fields

#### Service Type (Multi-select)

Used to categorize tasks by service type in consolidated client projects (see R003).

| Property | Value |
|----------|-------|
| Field GID | `1212617835819541` |
| Type | `multi_enum` |

**Options:**

| Option | GID |
|--------|-----|
| Consultancy | `1212617835819542` |
| Data & Analytics | `1212617835819543` |
| Facebook/Meta | `1212617835819544` |
| Google Ads | `1212617835819545` |
| Marketing Strategy | `1212617835819546` |
| Nexus | `1212617835819547` |
| SEO | `1212617835819548` |
| Software Development | `1212617835819549` |
| TBD | `1212647007060403` |

**Usage:**
```
custom_fields: "{\"1212617835819541\": [\"1212617835819543\"]}"  // Data & Analytics
```

### Consolidated Client Projects

| Client | Project GID |
|--------|-------------|
| DIEGO | `1212622388934290` |
| DLX | `1212647059168035` |
| VRS | `1212621087339134` |

---

## GitHub

### Repository

| Property | Value |
|----------|-------|
| Owner | ArcanianAi |
| Repository | new-it-arcanian |
| URL | https://github.com/ArcanianAi/new-it-arcanian |
| Visibility | Private |
| Default Branch | main |

### Access Notes

- MCP GitHub tools may not have access to private repos
- Use local git commands for push/pull operations
- GitHub CLI (`gh`) is not installed on this system

---

## Quick Reference

### Common Operations

| Task | Command/Tool |
|------|--------------|
| List Asana workspaces | `mcp__asana__asana_list_workspaces()` |
| Get current user | `mcp__asana__asana_get_user()` |
| List projects | `mcp__asana__asana_get_projects(workspace: "1206169144105850")` |
| Create client project | `mcp__asana__asana_create_project(name: "C:NAME", team: "1210213282346183")` |
| Search in Asana | `mcp__asana__asana_typeahead_search(workspace_gid: "1206169144105850", resource_type: "project", query: "...")` |

---

## Pending Manual Tasks

Tasks that require manual action (cannot be done via MCP):

| Task | Details | Status |
|------|---------|--------|
| Rename `C:DLX (consolidated)` → `C:DLX` | In Asana, rename project after migration | Pending |
| Rename `C:VRS (consolidated)` → `C:VRS` | In Asana, rename project after migration | Pending |
| Archive old VRS service projects | Archive `C:VRS-Data & Analytics`, `C:VRS-Google Ads` after rename | Pending |

---
