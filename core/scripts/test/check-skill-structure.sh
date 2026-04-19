#!/usr/bin/env bash
# check-skill-structure.sh — audit core/skills/*.md for BLUF + Trigger + frontmatter hygiene
#
# Usage: ./core/scripts/test/check-skill-structure.sh [--verbose]
#
# Exit codes:
#   0 = all skills pass
#   1 = one or more skills have hard violations (missing frontmatter, missing title)
#   2 = soft warnings only (missing Trigger, boilerplate drift)

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_DIR="$ROOT/skills"
VERBOSE=0
[[ "${1:-}" == "--verbose" ]] && VERBOSE=1

pass=0
warn=0
fail=0
warn_files=()
fail_files=()

for f in "$SKILLS_DIR"/*.md "$SKILLS_DIR"/*/*.md; do
  [[ -f "$f" ]] || continue
  # Skip files reached via symlinked directories (e.g. skills/skills → .)
  case "$f" in *"/skills/skills/"*) continue;; esac
  rel="${f#$ROOT/}"
  name="$(basename "$f")"

  # Skip pure reference docs (ALL_CAPS filenames like README.md, INTEGRATED_BUSINESS_WORKFLOW.md)
  [[ "$name" =~ ^[A-Z_]+\.md$ ]] && continue

  issues=()
  warnings=()

  # Hard checks
  head -1 "$f" | grep -q '^---$' || issues+=("no frontmatter")
  grep -q '^scope:' "$f" || issues+=("no scope: field")
  grep -qE '^# .' "$f" || issues+=("no top-level title")

  # Soft checks
  grep -qE '^## (Purpose|Cél)' "$f" || grep -qE '^\*\*BLUF:\*\*' "$f" || warnings+=("no Purpose/BLUF")
  grep -qE '^## (Trigger|When to (Use|invoke)|Mikor használd)' "$f" || warnings+=("no Trigger section")
  grep -qF '**File versioning:** When generating .md output files' "$f" && warnings+=("duplicated File-versioning boilerplate")

  if (( ${#issues[@]} > 0 )); then
    fail=$((fail+1))
    fail_files+=("$rel  →  ${issues[*]}")
  elif (( ${#warnings[@]} > 0 )); then
    warn=$((warn+1))
    warn_files+=("$rel  →  ${warnings[*]}")
  else
    pass=$((pass+1))
  fi
done

total=$((pass + warn + fail))
echo "Skill structure audit — $total files scanned"
echo "  ✅ pass: $pass"
echo "  ⚠️  warn: $warn"
echo "  ❌ fail: $fail"
echo

if (( fail > 0 )); then
  echo "FAILURES (hard violations):"
  printf '  %s\n' "${fail_files[@]}"
  echo
fi

if (( warn > 0 )) && (( VERBOSE == 1 || fail == 0 )); then
  echo "WARNINGS:"
  printf '  %s\n' "${warn_files[@]}"
fi

(( fail > 0 )) && exit 1
(( warn > 0 )) && exit 2
exit 0
