#!/bin/bash
#
# pre-commit-skill-structure.sh — Git pre-commit hook for AOS skills
#
# For any staged core/skills/*.md file, run the skill-structure audit.
# Refuses the commit if any staged skill has a hard violation (missing
# frontmatter, scope, or title). Soft warnings (missing Trigger, boilerplate
# drift) are surfaced but do NOT block.
#
# Rule: see core/scripts/test/check-skill-structure.sh for the check spec.
# Escape hatch: AOS_SKIP_SKILL_CHECK=1 git commit …  (audited at next review)

set -u

if [ "${AOS_SKIP_SKILL_CHECK:-}" = "1" ]; then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "${REPO_ROOT}" ] && exit 0   # not in a repo — nothing to check

# Locate the audit script. Works whether repo has core/ subdir or IS core/.
SCRIPT=""
for cand in \
  "${REPO_ROOT}/core/scripts/test/check-skill-structure.sh" \
  "${REPO_ROOT}/scripts/test/check-skill-structure.sh"; do
  if [ -x "$cand" ]; then SCRIPT="$cand"; break; fi
done

if [ -z "${SCRIPT}" ]; then
  # No audit script present — not installed in this repo. Silent skip.
  exit 0
fi

# Run in --staged mode (script reads git diff --cached itself)
OUTPUT="$("${SCRIPT}" --staged 2>&1)"
EXIT=$?

if [ "$EXIT" -eq 0 ]; then
  # Surface soft warnings if any (the script prints them to stdout in verbose mode,
  # but --staged is terse — run once more verbose if we want to show them)
  exit 0
fi

if [ "$EXIT" -eq 2 ]; then
  # Warnings only — print and allow
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ⚠ AOS SKILL STRUCTURE — warnings (not blocking)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "${OUTPUT}"
  echo ""
  exit 0
fi

# Hard failures (exit 1)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✗ AOS SKILL STRUCTURE CHECK — COMMIT REFUSED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Staged skill file(s) have hard structural violations:"
echo ""
echo "${OUTPUT}"
echo ""
echo "What to do:"
echo "  - Each skill MUST have: YAML frontmatter, a 'scope:' field, and a '# ' title."
echo "  - See template: core/templates/SKILL_TEMPLATE.md"
echo "  - Audit locally: core/scripts/test/check-skill-structure.sh --staged"
echo ""
echo "Escape hatch (not recommended):"
echo "  AOS_SKIP_SKILL_CHECK=1 git commit …"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exit 1
