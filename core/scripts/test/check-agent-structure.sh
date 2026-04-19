#!/usr/bin/env bash
# check-agent-structure.sh — audit core/agents/*.md for frontmatter + BLUF + routing hygiene
#
# Usage:
#   ./core/scripts/test/check-agent-structure.sh [--verbose]        full repo audit
#   ./core/scripts/test/check-agent-structure.sh --staged            audit only git-staged agent files
#   ./core/scripts/test/check-agent-structure.sh --files f1.md ...   audit listed files only
#
# Exit codes:
#   0 = all agents pass
#   1 = one or more agents have hard violations (missing frontmatter, id, name, scope, title)
#   2 = soft warnings only (missing Purpose/BLUF, missing When to Use / Trigger)
#
# Hard checks:
#   - YAML frontmatter present
#   - id: field
#   - name: field
#   - scope: field
#   - `# Agent: ...` or `# ...` top-level title
#
# Soft checks:
#   - `## Purpose` or `**BLUF:**`
#   - `## When to Use` or `## Trigger` or `## When to invoke`

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
AGENTS_DIR="$ROOT/agents"
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
    for f in "$AGENTS_DIR"/*.md "$AGENTS_DIR"/*/*.md; do
      [[ -f "$f" ]] || continue
      case "$f" in *"/agents/agents/"*) continue;; esac
      files_to_check+=("$f")
    done
    ;;
  staged)
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
    [[ -z "$repo_root" ]] && { echo "--staged requires a git repo"; exit 2; }
    while IFS= read -r rel; do
      [[ -z "$rel" ]] && continue
      case "$rel" in
        core/agents/*.md|core/agents/*/*.md|agents/*.md|agents/*/*.md) files_to_check+=("$repo_root/$rel") ;;
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

if (( ${#files_to_check[@]} == 0 )); then
  [[ "$MODE" != "full" ]] && { echo "No agent files to audit (mode=$MODE)."; exit 0; }
fi

for f in "${files_to_check[@]}"; do
  [[ -f "$f" ]] || continue
  rel="${f#$ROOT/}"
  [[ "$rel" == "$f" ]] && rel="$(basename "$(dirname "$f")")/$(basename "$f")"
  name="$(basename "$f")"

  # Skip pure reference docs (ALL_CAPS filenames like README.md)
  [[ "$name" =~ ^[A-Z_]+\.md$ ]] && continue

  issues=()
  warnings=()

  # Hard checks
  head -1 "$f" | grep -q '^---$' || issues+=("no frontmatter")
  grep -qE '^scope:' "$f" || issues+=("no scope: field")

  # Agents follow one of three frontmatter schemas:
  #   Schema A (AOS system agents):    id: + name: + scope: + `# Agent:` title
  #   Schema B (AOS managed agents):   type: + scope: + `# ` title
  #   Schema C (Claude native agents): name: + description: + scope:  (no title — body is prompt)
  has_id=0;   grep -qE '^id:'          "$f" && has_id=1
  has_name=0; grep -qE '^name:'        "$f" && has_name=1
  has_type=0; grep -qE '^type:'        "$f" && has_type=1
  has_desc=0; grep -qE '^description:' "$f" && has_desc=1
  is_schema_c=0

  if   [[ "$has_id" -eq 1 && "$has_name" -eq 1 ]]; then :
  elif [[ "$has_type" -eq 1 ]]; then :
  elif [[ "$has_name" -eq 1 && "$has_desc" -eq 1 ]]; then is_schema_c=1
  else issues+=("no valid identification (need id+name, type, or name+description)")
  fi

  # Title required for Schema A + B; Schema C is a prompt-agent, no title expected
  if [[ "$is_schema_c" -eq 0 ]]; then
    grep -qE '^# ' "$f" || issues+=("no top-level title")
  fi

  # Soft checks — Purpose/BLUF can be a ## section, **BLUF:** line, or frontmatter purpose:/description:
  grep -qE '^## (Purpose|Cél)' "$f" \
    || grep -qE '^\*\*BLUF:\*\*' "$f" \
    || grep -qE '^purpose:' "$f" \
    || grep -qE '^description:' "$f" \
    || warnings+=("no Purpose/BLUF")
  grep -qE '^## (Trigger|When to (Use|invoke)|Mikor használd)' "$f" || warnings+=("no Trigger/When-to-use section")

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
echo "Agent structure audit — $total files scanned"
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
