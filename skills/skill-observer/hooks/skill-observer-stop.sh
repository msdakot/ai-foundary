#!/usr/bin/env bash
# Stop hook: counts turns in live transcript, forks analysis every 20 turns

set -euo pipefail

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Nothing to work with
[ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ] && exit 0

# Count assistant turns as a proxy for conversation turns
TURN_COUNT=$(grep -c '"role":"assistant"' "$TRANSCRIPT_PATH" 2>/dev/null || echo 0)

# Only analyze at multiples of 20, minimum 20
[ "$TURN_COUNT" -lt 20 ] && exit 0
[ $(( TURN_COUNT % 20 )) -ne 0 ] && exit 0

SCRIPT_DIR="$(dirname "$0")"
ANALYZE_SCRIPT="$SCRIPT_DIR/skill-observer-analyze.sh"

[ ! -f "$ANALYZE_SCRIPT" ] && exit 0

# Fork analysis to background — don't block Claude's next response
bash "$ANALYZE_SCRIPT" "$TRANSCRIPT_PATH" "$TURN_COUNT" &
disown

exit 0
