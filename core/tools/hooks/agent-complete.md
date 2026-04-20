---
name: agent-complete
description: Processes results when a validation agent completes
trigger: on_agent_complete
agents_monitored:
  - code-reviewer
  - bug-detector
  - security-scanner
  - compliance-checker
  - test-analyzer
scope: shared
---

# Agent Complete Hook

## Purpose
Collect and aggregate results from validation agents as they complete, enabling the orchestrator to make decisions when all agents have reported.

## Trigger
Runs when any monitored validation agent completes its task.

## Behavior

### 1. Receive Agent Result

```bash
# Agent result comes as JSON
AGENT_NAME="$AGENT_NAME"
AGENT_RESULT="$AGENT_OUTPUT"

# Parse result
CONFIDENCE=$(echo "$AGENT_RESULT" | jq -r '.confidence')
APPROVED=$(echo "$AGENT_RESULT" | jq -r '.approved')
ISSUES=$(echo "$AGENT_RESULT" | jq -r '.issues // .bugs // .vulnerabilities | length')
```

### 2. Store Result

```bash
# Store in temporary aggregation file
RESULTS_FILE=".arcflux/execution/validation-results.json"

# Initialize if needed
if [ ! -f "$RESULTS_FILE" ]; then
  echo '{"agents":{}}' > "$RESULTS_FILE"
fi

# Add this agent's result
jq --arg name "$AGENT_NAME" \
   --argjson result "$AGENT_RESULT" \
   '.agents[$name] = $result' \
   "$RESULTS_FILE" > "${RESULTS_FILE}.tmp" && mv "${RESULTS_FILE}.tmp" "$RESULTS_FILE"

echo "📊 Agent completed: $AGENT_NAME (confidence: $CONFIDENCE)"
```

### 3. Check Completion

```bash
# Expected agents
EXPECTED_AGENTS=("code-reviewer" "bug-detector" "security-scanner" "compliance-checker" "test-analyzer")

# Count completed
COMPLETED=$(jq '.agents | keys | length' "$RESULTS_FILE")

if [ "$COMPLETED" -eq "${#EXPECTED_AGENTS[@]}" ]; then
  echo "✅ All agents complete - triggering aggregation"
  # Signal orchestrator
  touch ".arcflux/execution/.validation-complete"
fi
```

### 4. Display Progress

```
═══ Validation Progress ═══

Completed: 3/5 agents

✅ code-reviewer     (88% confidence)
✅ security-scanner  (100% confidence)
✅ bug-detector      (82% confidence)
⏳ compliance-checker
⏳ test-analyzer

Waiting for remaining agents...
```

## Aggregation Logic

When all agents complete:

```bash
# Calculate weighted score
WEIGHTS='{"code-reviewer":0.20,"bug-detector":0.25,"security-scanner":0.25,"compliance-checker":0.15,"test-analyzer":0.15}'

TOTAL_SCORE=$(jq --argjson weights "$WEIGHTS" '
  .agents | to_entries |
  map(.value.confidence * $weights[.key]) |
  add
' "$RESULTS_FILE")

# Check for blocking issues
HAS_BLOCKERS=$(jq '
  .agents | to_entries |
  any(.value.vulnerabilities[]?.severity == "critical" or
      .value.bugs[]?.severity == "critical")
' "$RESULTS_FILE")

# Determine overall result
if [ "$HAS_BLOCKERS" = "true" ]; then
  OVERALL_APPROVED="false"
  REASON="Critical issues found"
elif [ "$(echo "$TOTAL_SCORE > 0.8" | bc)" -eq 1 ]; then
  OVERALL_APPROVED="true"
  REASON="Score above threshold"
else
  OVERALL_APPROVED="false"
  REASON="Score below 0.8 threshold"
fi
```

## Output Format

### Individual Agent
```
📊 Agent: security-scanner
   Confidence: 100%
   Approved: true
   Issues: 0
   Warnings: 1
```

### All Complete
```
═══ Validation Complete ═══

All 5 agents have reported:

  Agent               Confidence  Approved  Issues
  ─────────────────────────────────────────────────
  code-reviewer       88%         ✅        0
  bug-detector        82%         ✅        2 warnings
  security-scanner    100%        ✅        0
  compliance-checker  95%         ✅        0
  test-analyzer       75%         ✅        3 suggestions

Weighted Score: 0.87 (threshold: 0.80)
Overall Result: ✅ APPROVED

💡 2 warnings and 3 suggestions for consideration
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Agent result recorded |

Note: This hook never blocks. It only aggregates and reports.

## Configuration

In `.arcflux/config.json`:

```json
{
  "validation": {
    "agents": ["code-reviewer", "bug-detector", "security-scanner", "compliance-checker", "test-analyzer"],
    "weights": {
      "code-reviewer": 0.20,
      "bug-detector": 0.25,
      "security-scanner": 0.25,
      "compliance-checker": 0.15,
      "test-analyzer": 0.15
    },
    "threshold": 0.80
  }
}
```

## Integration

- Works with /arcflux:validate command
- Signals orchestrator when all agents complete
- Results stored for commit message context
- Can trigger auto-commit if enabled and all pass
