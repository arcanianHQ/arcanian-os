---
scope: shared
---

> v1.0 --- 2026-04-10

# Decision Tree: Deliverable Routing

> You've written something. Where does it get saved?
> References: `save-deliverable.md`, `ENRICHMENT_WATERFALL.md`

```mermaid
graph TD
    A[Deliverable Created] --> B{What type?}
    
    B -->|Email| C{For whom?}
    B -->|LinkedIn post| D[internal/content/linkedin/posts/<br/>LINKEDIN_POST_NN_TITLE.md]
    B -->|LinkedIn comment| E[internal/content/linkedin/comments/<br/>LINKEDIN_COMMENT_NN_DESC.md]
    B -->|Memo| F{Client or<br/>internal?}
    B -->|Report / Analysis| G{Client or<br/>hub-level?}
    B -->|Proposal| H{Lead or<br/>existing client?}
    B -->|Diagnostic| I[clients/slug/docs/<br/>CLIENT_SKILL_DATE.md]
    B -->|Audit| J[clients/slug/audit/<br/>CLIENT_AUDIT_TOPIC_DATE.md]
    
    C -->|Client contact| K[clients/slug/takeover/correspondence/<br/>recipient-topic-draft.md]
    C -->|Lead| L[internal/leads/slug/sent/<br/>DATE_topic.md]
    C -->|Internal team| M[internal/correspondence/<br/>recipient-topic-draft.md]
    
    F -->|Client| N[clients/slug/<br/>DATE_memo_topic.md]
    F -->|Internal| O[internal/<br/>DATE_memo_topic.md]
    
    G -->|Client| P[clients/slug/docs/<br/>CLIENT_ANALYSIS_TOPIC_PERIOD.md]
    G -->|Hub-level| Q[internal/analyses/<br/>ANALYSIS_TOPIC_DATE.md]
    
    H -->|Lead| R[internal/leads/slug/sent/<br/>DATE_proposal.md]
    H -->|Client| S[clients/slug/proposals/<br/>client-arajanlat-vN.md]
    
    D --> T{Enrichment<br/>gate check}
    K --> T
    L --> T
    
    T --> U{input_context<br/>identified?}
    U -->|Yes| V[Add to ontology block:<br/>input_context, quality_rating,<br/>engagement fields]
    U -->|No| W[Add input_context: freeform<br/>to ontology block]
    
    V --> X[Save + Open in Typora<br/>Check glossary for banned terms]
    W --> X
    
    X --> Y{Lead-related<br/>deliverable?}
    Y -->|Yes| Z[Update LEAD_STATUS.md<br/>timeline + check enrichment level]
    Y -->|No| AA[Done]
    Z --> AA
```

## Save Location Quick Reference

| Type | Client context | Location |
|---|---|---|
| Email | Client contact | `clients/slug/takeover/correspondence/` |
| Email | Lead | `internal/leads/slug/sent/` |
| Email | Internal | `internal/correspondence/` |
| LinkedIn post | — | `internal/content/linkedin/posts/` |
| LinkedIn comment | — | `internal/content/linkedin/comments/` |
| Memo | Client | `clients/slug/` |
| Memo | Internal | `internal/` |
| Report/Analysis | Client | `clients/slug/docs/` |
| Report/Analysis | Hub | `internal/analyses/` |
| Proposal | Lead | `internal/leads/slug/sent/` |
| Proposal | Client | `clients/slug/proposals/` |
| Diagnostic | Client | `clients/slug/docs/` |
| Audit | Client | `clients/slug/audit/` |
