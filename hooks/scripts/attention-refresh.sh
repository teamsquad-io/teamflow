#!/bin/bash
set -euo pipefail

state=".workflow/state.md"
[ -f "$state" ] || { printf '{}'; exit 0; }

phase=$(grep -i 'phase:' "$state" 2>/dev/null | head -1 | sed 's/.*: *//' || true)
feature=$(grep -i 'feature:' "$state" 2>/dev/null | head -1 | sed 's/.*: *//' || true)

case "$phase" in
  *work*|*executing*|*Work*|*Executing*)
    tasks=".workflow/wip/${feature}/tasks.md"
    if [ -n "$feature" ] && [ -f "$tasks" ]; then
      ctx=$(head -20 "$tasks" | tr '\n' '\\' | sed 's/\\/\\n/g' | sed 's/"/\\"/g')
      printf '{"additionalContext":"Active tasks for %s:\\n%s"}' "$feature" "$ctx"
    else
      printf '{}'
    fi
    ;;
  *)
    printf '{}'
    ;;
esac
