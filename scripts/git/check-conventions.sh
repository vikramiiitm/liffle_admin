#!/bin/bash
# Checks branch names and commit messages against docs/GIT_CONVENTIONS.md (GIT-01). The same file is
# in every Liffle repository; keep the copies identical.
#
#   check-conventions.sh message <file>      a commit message (the commit-msg hook)
#   check-conventions.sh range <base> <head> every non-merge commit in base..head (CI)
#   check-conventions.sh branch <name>       a branch name (CI)
set -euo pipefail

TYPES_COMMIT='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'
TYPES_BRANCH='feat|fix|chore|docs|refactor'
ID='[A-Z][A-Z0-9]*(-[A-Z0-9]+)*[a-z]?'
SUBJECT="^($TYPES_COMMIT)\\((MAINT|$ID(,$ID)*)\\)!?: .{1,72}\$"
BRANCH="^($TYPES_BRANCH)/$ID-[a-z0-9]+(-[a-z0-9]+)*\$"
# Long-lived branches and branches a tool assigns keep their names (GIT_CONVENTIONS.md §1).
BRANCH_EXCEPTIONS='^(main|master|release/(dev|staging|production)-tf|claude/[a-z0-9-]+)$'
HELP='See docs/GIT_CONVENTIONS.md in liffle_backend: type(ID): subject, then a blank line and a detailed body.'

subject_ok() {
  local subject="$1"
  # Git's own merge and revert messages, and fixups that are squashed away, are allowed as they are.
  [[ "$subject" =~ ^(Merge\ |Revert\ \"|fixup!\ |squash!\ ) ]] && return 0
  [[ "$subject" =~ $SUBJECT ]]
}

case "${1:-}" in
  message)
    file="${2:?usage: check-conventions.sh message <file>}"
    subject=$(grep -v '^#' "$file" | head -n 1)
    if ! subject_ok "$subject"; then
      echo "Commit message does not follow the convention: \"$subject\"" >&2
      echo "$HELP" >&2
      exit 1
    fi
    # A commit that changes how Liffle works says what it means for security, scale, gaps and the
    # architecture (owner, 26 Oct: "add hooks for scalability, security and gaps, architecture too").
    # Checked when a commit is made, not over old ranges, so history from before the rule stays valid.
    if [[ "$subject" =~ ^(feat|fix|refactor|perf)\( ]]; then
      missing=()
      for field in Security Scale Gaps Architecture; do
        grep -v '^#' "$file" | grep -qE "^(- )?\*{0,2}$field:" || missing+=("$field:")
      done
      if [ "${#missing[@]}" -gt 0 ]; then
        echo "A $(echo "$subject" | cut -d'(' -f1) commit needs these lines in its body: ${missing[*]}" >&2
        echo "Each says what the change means for it, or why it does not touch it (\"Scale: no new per-person work\")." >&2
        echo "$HELP" >&2
        exit 1
      fi
    fi
    ;;
  range)
    base="${2:?usage: check-conventions.sh range <base> <head>}"; head="${3:?head}"
    bad=0
    while IFS=$'\t' read -r sha subject; do
      [ -z "$sha" ] && continue
      if ! subject_ok "$subject"; then echo "::error::${sha:0:12} \"$subject\" does not follow the convention" >&2; bad=1; fi
    done < <(git log --no-merges --format='%H%x09%s' "$base..$head")
    [ "$bad" -eq 0 ] || { echo "$HELP" >&2; exit 1; }
    echo "Every commit in ${base:0:12}..${head:0:12} follows the convention"
    ;;
  branch)
    name="${2:?usage: check-conventions.sh branch <name>}"
    if [[ "$name" =~ $BRANCH_EXCEPTIONS ]] || [[ "$name" =~ $BRANCH ]]; then echo "Branch name $name is fine"; exit 0; fi
    echo "::error::Branch name \"$name\" does not follow type/ID-description" >&2
    echo "$HELP" >&2
    exit 1
    ;;
  *) echo "usage: check-conventions.sh message <file> | range <base> <head> | branch <name>" >&2; exit 2 ;;
esac
