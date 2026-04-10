---
scope: shared
---

> v1.0 --- 2026-04-10

# Decision Tree: Signal Routing

> When a signal is detected, where does it go?
> References: `SIGNAL_DETECTION_RULE.md`, `SIGNAL_DECAY_MODEL.md`

```mermaid
graph TD
    A[Signal Detected] --> B{Who is it?}
    
    B -->|Tracked Profile| C{Priority level?}
    B -->|Unknown person| D{Relevant topic?}
    B -->|Competitor| E[Log silently to Content Memory<br/>Do NOT engage]
    
    C -->|P0| F[Draft /linkedin-comment<br/>React within 30 min]
    C -->|P1| G{Topic relevant<br/>to us?}
    C -->|P2| H[Queue for next day<br/>Relationship building]
    
    G -->|Yes| I[Draft /linkedin-comment<br/>React same day]
    G -->|No| J[Skip or light engagement<br/>Like only]
    
    D -->|Yes| K{Person matches<br/>our ECP?}
    D -->|No| L[Ignore]
    
    K -->|Yes| M[Add to Content Memory<br/>Consider as lead signal]
    K -->|No| N[Note topic trend only]
    
    F --> O{Person has<br/>LEAD_STATUS.md?}
    I --> O
    H --> O
    M --> O
    
    O -->|Yes| P[Update Signal Log<br/>Recalculate lead_score<br/>per SIGNAL_DECAY_MODEL]
    O -->|No| Q{Worth creating<br/>a lead file?}
    
    Q -->|Yes| R[Create internal/leads/slug/<br/>Stage = Discovery]
    Q -->|No| S[Done — signal processed]
    
    P --> S
    R --> S
```

## Quick Reference

| Signal | Action | Time |
|---|---|---|
| P0 tracked profile posts | `/linkedin-comment` + lead score update | 30 min |
| P1 relevant topic | `/linkedin-comment` + lead score update | Same day |
| P1 irrelevant topic | Like only | When convenient |
| P2 any topic | Light engagement | Next day |
| Unknown person, relevant, matches ECP | Content Memory + consider lead | Same day |
| Competitor posts | Log to Content Memory, analyze silently | No engagement |
