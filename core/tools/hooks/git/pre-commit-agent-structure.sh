#!/bin/bash
#
# pre-commit-agent-structure.sh — Git pre-commit hook for AOS agents
#
# For any staged core/agents/*.md file, run the agent-structure audit.
# Refuses the commit if any staged agent has a hard violation (missing
# frontmatter, id/name/type, scope, or title). Soft warnings (missing
# Purpose/BLUF, missing Trigger/When-to-use) surface but do NOT block.
#
# Rule: see core/scripts/test/check-agent-structure.sh for the check spec.
# Escape hatch: AOS_SKIP_AGENT_CHECK=1 git commit …

set -u

if [ "${AOS_SKIP_AGENT_CHECK:-}" = "1" ]; then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "${REPO_ROOT}" ] && exit 0

SCRIPT=""
for cand in \
  "${REPO_ROOT}/core/scripts/test/check-agent-structure.sh" \
  "${REPO_ROOT}/scripts/test/check-agent-structure.sh"; do
  if [ -x "$cand" ]; then SCRIPT="$cand"; break; fi
done

if [ -z "${SCRIPT}" ]; then
  exit 0   # not installed — silent skip
fi

OUTPUT="$("${SCRIPT}" --staged 2>&1)"
EXIT=$?

if [ "$EXIT" -eq 0 ]; then
  exit 0
fi

if [ "$EXIT" -eq 2 ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ⚠ AOS AGENT STRUCTURE — warnings (not blocking)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "${OUTPUT}"
  echo ""
  exit 0
fi

# Hard failures (exit 1)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✗ AOS AGENT STRUCTURE CHECK — COMMIT REFUSED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Staged agent file(s) have hard structural violations:"
echo ""
echo "${OUTPUT}"
echo ""
echo "What to do:"
echo "  - Each agent MUST have: YAML frontmatter, a 'scope:' field,"
echo "    either (id: AND name:) OR (type:) for identification,"
echo "    and a '# ' top-level title."
echo "  - See template: core/templates/AGENT_TEMPLATE.md"
echo "  - Audit locally: core/scripts/test/check-agent-structure.sh --staged"
echo ""
echo "Escape hatch (not recommended):"
echo "  AOS_SKIP_AGENT_CHECK=1 git commit …"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exit 1
