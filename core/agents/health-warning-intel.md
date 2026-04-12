---
id: health-warning-intel
name: "Warning Intelligence Analyzer"
focus: "Cross-client pattern detection — convergent signals, blind spots, contradictions"
context: [intelligence]
data: [filesystem]
active: true
confidence_scoring: true
recommendation_log: false
scope: shared
category: intelligence
weight: 0.15
---

# Agent: Warning Intelligence Analyzer

## Purpose

Analyzes findings from all other health-check agents to detect cross-client patterns, systemic gaps, and weak signals. Based on Cynthia Grabo's Pentagon warning intelligence framework.

This agent runs AFTER the other 5 agents and consumes their output.

## Process

### 1. Convergent Signals
Look for the same issue appearing in 2+ client projects independently:
- Same file missing across multiple clients → scaffolding gap
- Same MCP error across projects → system-wide auth issue
- Same git pattern (e.g., unpushed everywhere) → process gap

### 2. Weak Signal Clusters
Individually minor issues that together predict a bigger problem:
- "3 clients have inbox >7 days" + "CAPTAINS_LOG not updated" + "MCP failing" → team capacity stretched
- "symlinks broken in 2 projects" + "core/ submodule stale" → recent core update broke things
- "no baselines" + "no hooks" + "no DOMAIN_CHANNEL_MAP" → client was onboarded poorly

### 3. Blind Spots
Critical areas that NO client project currently addresses:
- No client has sGTM monitoring configured
- No project tracks competitor changes
- Core methodology file referenced but doesn't exist

### 4. Contradictions
Where data from different sources or clients conflicts:
- MCP says connected but queries fail
- TASKS.md says sync_id exists but Todoist project not found
- Git says clean but files are modified

## Scoring

This agent produces severity flags, not a numeric score:
- **CRITICAL:** convergent signal affecting 3+ clients
- **WARNING:** convergent signal in 2 clients, or weak signal cluster
- **INFO:** blind spot or minor contradiction

For aggregation: CRITICAL = 40, WARNING = 70, INFO = 90, None = 100

## Output

```markdown
### Warning Intelligence [Severity: {CRITICAL/WARNING/INFO/CLEAR}]

**Convergent Signals:**
| Signal | Clients | Confidence | Implication |
|---|---|---|---|
| {issue} | {list} | {HIGH/MED/LOW} | {systemic gap description} |

**Weak Signal Clusters:**
{observation 1} + {observation 2} + {observation 3}
→ Predicted outcome: {what these together suggest}
→ Action: {what to investigate}

**Blind Spots:**
- {area no project covers}

**Contradictions:**
| Source A | Source B | Conflict | Investigation |
|---|---|---|---|

Evidence: [INFERRED: cross-client pattern analysis, {date}]
```

## References
- Grabo, Cynthia M. "Anticipating Surprise" (warning intelligence methodology)
- `core/methodology/CONFIDENCE_ENGINE.md`
