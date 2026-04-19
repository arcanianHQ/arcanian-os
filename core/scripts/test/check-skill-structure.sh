#!/usr/bin/env bash
# check-skill-structure.sh — audit core/skills/*.md for BLUF + Trigger + frontmatter hygiene
#
# Usage:
#   ./core/scripts/test/check-skill-structure.sh [--verbose]        full repo audit
#   ./core/scripts/test/check-skill-structure.sh --staged            audit only git-staged skill files
#   ./core/scripts/test/check-skill-structure.sh --files f1.md ...   audit listed files only
#
# Exit codes:
#   0 = all skills pass
#   1 = one or more skills have hard violations (missing frontmatter, missing title)
#   2 = soft warnings only (missing Trigger, boilerplate drift)

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_DIR="$ROOT/skills"
VERBOSE=0
MODE=full
EXPLICIT_FILES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose) VERBOSE=1; shift ;;
    --staged)  MODE=staged; shift ;;
    --files)   MODE=files; shift; while [[ $# -gt 0 && "$1" != --* ]]; do EXPLICIT_FILES+=("$1"); shift; done ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Build the file list based on mode
files_to_check=()
case "$MODE" in
  full)
    for f in "$SKILLS_DIR"/*.md "$SKILLS_DIR"/*/*.md; do
      [[ -f "$f" ]] || continue
      case "$f" in *"/skills/skills/"*) continue;; esac
      files_to_check+=("$f")
    done
    ;;
  staged)
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
    [[ -z "$repo_root" ]] && { echo "--staged requires a git repo"; exit 2; }
    while IFS= read -r rel; do
      [[ -z "$rel" ]] && continue
      case "$rel" in
        core/skills/*.md|core/skills/*/*.md|skills/*.md|skills/*/*.md) files_to_check+=("$repo_root/$rel") ;;
      esac
    done < <(git diff --cached --name-only --diff-filter=ACMR)
    ;;
  files)
    for f in "${EXPLICIT_FILES[@]}"; do
      [[ -f "$f" ]] && files_to_check+=("$f")
    done
    ;;
esac

pass=0
warn=0
fail=0
warn_files=()
fail_files=()

# Handle empty file list (e.g. --staged with no skill changes)
if (( ${#files_to_check[@]} == 0 )); then
  [[ "$MODE" != "full" ]] && { echo "No skill files to audit (mode=$MODE)."; exit 0; }
fi

for f in "${files_to_check[@]}"; do
  [[ -f "$f" ]] || continue
  rel="${f#$ROOT/}"
  [[ "$rel" == "$f" ]] && rel="$(basename "$(dirname "$f")")/$(basename "$f")"
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
