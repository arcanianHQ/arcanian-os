---
scope: shared
---

> v1.0 --- 2026-04-10

# Decision Tree: Inbox Triage

> A file lands in inbox/. Where does it go?
> References: `core/sops/arcanian/09-inbox-management.md`, `FILE_INTAKE_RULE.md`

```mermaid
graph TD
    A[File in inbox/] --> B{What type<br/>of file?}
    
    B -->|Email / message| C{From whom?}
    B -->|Document / PDF| D{What's the<br/>subject?}
    B -->|Data export / CSV| E{Which system?}
    B -->|Screenshot / image| F{What does it show?}
    B -->|Meeting recording| G[Route to meetings/<br/>Rename: YYYY-MM-DD_topic.md]
    
    C -->|Client contact| H{Action needed<br/>from us?}
    C -->|Lead| I[Route to internal/leads/slug/received/<br/>Update LEAD_STATUS timeline]
    C -->|Agency / vendor| J[Route to client/takeover/correspondence/<br/>Create task if action needed]
    C -->|Unknown| K{Relevant to<br/>a client?}
    
    H -->|Yes| L[Route to client/takeover/correspondence/<br/>Create task in TASKS.md<br/>Set owner + due date]
    H -->|No, FYI only| M[Route to client/takeover/correspondence/<br/>No task needed]
    
    K -->|Yes| L
    K -->|No| N[Archive or delete]
    
    D -->|Contract / proposal| O[Route to client/proposals/<br/>or internal/leads/slug/received/]
    D -->|Report / analysis| P[Route to client/data/<br/>or client/docs/]
    D -->|SOP / process| Q[Route to client/processes/<br/>or core/sops/]
    D -->|Invoice / financial| R[Route to client/admin/<br/>Flag for finance review]
    
    E -->|GA4 / GTM| S[Route to client/data/gtm-exports/<br/>or client/data/ga4/]
    E -->|ActiveCampaign| T[Route to client/data/ac/]
    E -->|Ads platform| U[Route to client/data/ads/]
    E -->|Other| V[Route to client/data/<br/>Descriptive subfolder]
    
    F -->|Bug / issue| W[Route to client/audit/evidence/<br/>Create FND if new finding]
    F -->|Design / creative| X[Route to client/brand/<br/>or client/assets/]
    F -->|Dashboard / metrics| Y[Route to client/data/<br/>Reference in analysis]
    
    G --> Z[Extract action items<br/>Create tasks in TASKS.md]
    L --> Z
    
    Z --> AA[Rename per convention<br/>YYYY-MM-DD_prefix_slug.ext]
    AA --> AB[Add ontology header<br/>Log to CAPTAINS_LOG]
    AB --> AC[Done — file routed]
```

## Routing Quick Reference

| Input | Destination | Task? |
|---|---|---|
| Client email with action | `client/takeover/correspondence/` | Yes |
| Client email FYI | `client/takeover/correspondence/` | No |
| Lead reply | `internal/leads/slug/received/` | Update LEAD_STATUS |
| Meeting recording | `client/meetings/` or `internal/meetings/` | Extract tasks |
| Data export | `client/data/{source}/` | No |
| Screenshot of issue | `client/audit/evidence/` | Create FND |
| Contract/proposal | `client/proposals/` | Review task |

## Rules
- No file stays in inbox/ > 7 days
- Every routed file gets YYYY-MM-DD prefix
- Every routed file gets ontology header
- Every file with action items → tasks extracted to TASKS.md
