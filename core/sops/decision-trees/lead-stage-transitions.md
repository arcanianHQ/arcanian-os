---
scope: shared
---

> v1.0 --- 2026-04-10

# Decision Tree: Lead Stage Transitions

> When should a lead advance, hold, or decay?
> References: `LEAD_TRACKING_STANDARD.md`, `SIGNAL_DECAY_MODEL.md`, `ENRICHMENT_WATERFALL.md`

```mermaid
graph TD
    A[Review Lead] --> B{Current Stage?}
    
    B -->|Signal| C{Company + contact<br/>identified?}
    C -->|Yes| D[Advance to Discovery]
    C -->|No| E[Stay in Signal<br/>Research more]
    
    B -->|Discovery| F{Enrichment Stage 1<br/>complete?}
    F -->|Yes| G[Advance to Diagnosed<br/>Run /7layer or First Signal]
    F -->|No| H[Stay in Discovery<br/>Complete: website scan,<br/>tracking, social]
    
    B -->|Diagnosed| I{lead_score >= 15?}
    I -->|Yes| J{Materials<br/>prepared?}
    I -->|No| K[Hold — warm the lead<br/>Engage with their content<br/>Create more signals]
    J -->|Yes| L[Advance to Pitched<br/>Send materials]
    J -->|No| M[Stay — prepare materials<br/>Analysis, Prism, or pitch]
    
    B -->|Pitched| N{Response<br/>received?}
    N -->|Yes, interested| O{lead_score >= 20?}
    N -->|Yes, declined| P[Move to Lost]
    N -->|No response| Q{Days since<br/>pitch?}
    
    O -->|Yes| R[Advance to Negotiating]
    O -->|No| S[Hold — score too low<br/>Need more engagement signals]
    
    Q -->|< 7 days| T[Wait — normal]
    Q -->|7-14 days| U[Follow up — gentle nudge]
    Q -->|14-30 days| V[Follow up — direct ask]
    Q -->|30-60 days| W[Move to Waiting<br/>Set quarterly check-in]
    Q -->|> 60 days| X[Move to Lost or Dormant]
    
    B -->|Negotiating| Y{4+ of 7 intelligence<br/>files started?}
    Y -->|Yes| Z{Contract<br/>agreed?}
    Y -->|No| AA[Build intelligence<br/>before closing]
    Z -->|Yes| AB[Won — run /onboard-client]
    Z -->|No| AC[Continue negotiation]
    
    B -->|Dormant| AD{Quarterly<br/>check-in due?}
    AD -->|Yes| AE{New signal<br/>in last 90d?}
    AD -->|No| AF[Stay Dormant<br/>Next check: +90d]
    AE -->|Yes| AG[Reactivate to Discovery<br/>Recalculate score]
    AE -->|No| AH[Stay Dormant<br/>or Archive]
```

## Score Gate Quick Reference

| Transition | Hard Gate | Soft Gate |
|---|---|---|
| Signal → Discovery | Company + contact identified | — |
| Discovery → Diagnosed | — | Enrichment Stage 1 complete |
| Diagnosed → Pitched | lead_score ≥ 15 | Materials prepared |
| Pitched → Negotiating | lead_score ≥ 20 | Response received |
| Negotiating → Won | — | 4+ intelligence files |
