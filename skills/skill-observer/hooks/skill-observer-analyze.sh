#!/usr/bin/env bash
# Background analysis: reads last 20 turns, calls claude -p, saves suggestions

set -euo pipefail

TRANSCRIPT_PATH="${1:-}"
TURN_COUNT="${2:-0}"
OBSERVER_DIR="$HOME/.claude/observer"
PENDING_FILE="$OBSERVER_DIR/pending-suggestions.jsonl"
ANALYZED_FILE="$OBSERVER_DIR/analyzed-checkpoints.txt"

mkdir -p "$OBSERVER_DIR"

# Dedup: skip if we already analyzed at this turn count for this transcript
CHECKPOINT_KEY="${TRANSCRIPT_PATH}:${TURN_COUNT}"
if [ -f "$ANALYZED_FILE" ] && grep -qF "$CHECKPOINT_KEY" "$ANALYZED_FILE"; then
  exit 0
fi

# Extract last 20 assistant+user turn pairs from transcript JSONL
# Each line is a JSON object; grab last 40 lines to cover ~20 turn pairs
LAST_TURNS=$(tail -n 40 "$TRANSCRIPT_PATH" 2>/dev/null | \
  jq -r 'select(.role == "user" or .role == "assistant") |
    "[" + .role + "]: " + (
      if .content | type == "string" then .content
      elif .content | type == "array" then
        [.content[] | select(.type == "text") | .text] | join(" ")
      else ""
      end
    )' 2>/dev/null | head -n 60)

[ -z "$LAST_TURNS" ] && exit 0

ANALYSIS=$(claude -p "You are a silent skill observer. Analyze the following conversation excerpt and detect repeated correction patterns.

Look for:
- The user correcting Claude on the same thing 3+ times (e.g., \"use const not var\", \"don't add trailing newlines\")
- The user re-explaining the same workflow Claude should already know
- Claude repeatedly making the same mistake across turns

For each pattern found, classify it as one of:
- \"claude-md\": a standing rule or preference (best captured as a CLAUDE.md instruction)
- \"new-skill\": a reusable multi-step workflow Claude doesn't know
- \"patch-skill\": an existing skill that seems outdated or wrong

IMPORTANT: Distinguish skill gaps from task structure. If something is repeated because the TASK requires it (e.g., always escaping SQL in a DB project), that is NOT a skill gap — ignore it.

Respond in this exact JSON format (no markdown, no explanation):
{
  \"findings\": [
    {
      \"type\": \"claude-md\" | \"new-skill\" | \"patch-skill\",
      \"theme\": \"one-line description of the pattern\",
      \"evidence\": \"brief quote or summary of the repeated corrections\",
      \"suggestion\": \"exact text to add to CLAUDE.md, or skill name + outline\",
      \"confidence\": \"high\" | \"medium\" | \"low\"
    }
  ]
}

If no genuine skill gaps are found, respond with: {\"findings\": []}

Conversation excerpt:
---
$LAST_TURNS
---" 2>/dev/null)

# Validate JSON and check if findings exist
FINDING_COUNT=$(echo "$ANALYSIS" | jq '.findings | length' 2>/dev/null || echo 0)

[ "$FINDING_COUNT" -eq 0 ] && {
  echo "$CHECKPOINT_KEY" >> "$ANALYZED_FILE"
  exit 0
}

# Save findings to pending file with metadata
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID=$(basename "$TRANSCRIPT_PATH" .jsonl)

echo "$ANALYSIS" | jq --arg ts "$TIMESTAMP" --arg sid "$SESSION_ID" --arg turn "$TURN_COUNT" \
  '{timestamp: $ts, session_id: $sid, turn_count: ($turn | tonumber), findings: .findings}' \
  >> "$PENDING_FILE"

# Mark checkpoint as analyzed
echo "$CHECKPOINT_KEY" >> "$ANALYZED_FILE"

# Nudge user — prints to stderr so it appears in terminal between turns
echo "" >&2
echo "💡 skill-observer: found $(echo "$ANALYSIS" | jq '.findings | length') pattern(s) worth reviewing." >&2
echo "   Run /skill-observer to see suggestions." >&2
echo "" >&2
