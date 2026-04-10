#!/bin/bash
# post-tool-use-mcp-error-classifier.sh
# Classifies MCP tool errors into categories for intelligent retry decisions.
# Matches: mcp__* tools (all MCP server tool calls)
# Output: stderr message with error classification (visible to Claude)

# Read tool result from stdin
TOOL_RESULT=$(cat)

# Only process if the result contains error indicators
if echo "$TOOL_RESULT" | grep -qiE '(error|failed|exception|status.*[45][0-9][0-9]|rate.limit|too.many.requests|unauthorized|forbidden|not.found|timeout|timed.out)'; then

  # Classify the error
  if echo "$TOOL_RESULT" | grep -qiE '(429|rate.limit|too.many.requests|throttl)'; then
    echo "MCP ERROR CLASSIFIED: Category=transient | Retryable=yes | Type=rate_limit | Action=wait retry_after or halve batch + wait 5s. See MCP_RATE_LIMITS.md" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(500|502|503|504|internal.server|bad.gateway|service.unavailable|gateway.timeout)'; then
    echo "MCP ERROR CLASSIFIED: Category=transient | Retryable=yes | Type=server_error | Action=exponential backoff, max 3 attempts" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(timeout|timed.out|ETIMEDOUT|ECONNRESET)'; then
    echo "MCP ERROR CLASSIFIED: Category=transient | Retryable=yes | Type=timeout | Action=retry with longer timeout or smaller payload" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(400|bad.request|invalid|malformed|missing.required|validation)'; then
    echo "MCP ERROR CLASSIFIED: Category=validation | Retryable=no | Type=bad_input | Action=fix request parameters, retry once" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(422|unprocessable)'; then
    echo "MCP ERROR CLASSIFIED: Category=validation | Retryable=no | Type=unprocessable | Action=check field types and values" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(404|not.found|does.not.exist|no.such)'; then
    echo "MCP ERROR CLASSIFIED: Category=business | Retryable=no | Type=not_found | Action=verify resource ID, check correct instance/account" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(409|conflict|already.exists|duplicate)'; then
    echo "MCP ERROR CLASSIFIED: Category=business | Retryable=no | Type=conflict | Action=fetch current state, resolve conflict" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(401|unauthorized|unauthenticated|invalid.token|expired.token)'; then
    echo "MCP ERROR CLASSIFIED: Category=permission | Retryable=no | Type=auth_failure | Action=check MCP token, may need session restart" >&2
  elif echo "$TOOL_RESULT" | grep -qiE '(403|forbidden|insufficient.permission|access.denied)'; then
    echo "MCP ERROR CLASSIFIED: Category=permission | Retryable=no | Type=access_denied | Action=check MCP server scope and permissions" >&2
  else
    echo "MCP ERROR CLASSIFIED: Category=unknown | Retryable=uncertain | Action=review error details, classify manually per MCP_ERROR_HANDLING.md" >&2
  fi
fi
