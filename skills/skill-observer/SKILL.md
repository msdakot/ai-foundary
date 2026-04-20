---
name: skill-observer
description: Review pending skill suggestions collected by the background observer. Use when the user wants to see, approve, reject, or apply pattern suggestions that the observer flagged during past sessions.
---

# Skill Observer — Suggestion Review

The background observer watches conversation turns and flags repeated correction patterns. This skill lets the user review and act on those findings.

## Step 1 — Read pending suggestions

```bash
cat ~/.claude/observer/pending-suggestions.jsonl 2>/dev/null || echo "No pending suggestions."
```

If empty, tell the user: "No suggestions pending. The observer will flag patterns as they accumulate across sessions."

## Step 2 — Present each finding clearly

For each entry in the file, show the user:

```
┌─ Suggestion ─────────────────────────────────────────────────────┐
│ Type:       <claude-md | new-skill | patch-skill>                │
│ Theme:      <theme>                                              │
│ Confidence: <high | medium | low>                                │
│ Evidence:   <evidence>                                           │
│                                                                  │
│ Proposed:   <suggestion text>                                    │
└──────────────────────────────────────────────────────────────────┘
```

Ask: "Apply this suggestion? [y]es / [n]o / [e]dit"

## Step 3 — Act on user response

**y — approve:**
- `claude-md`: append the suggestion text as a bullet to `~/.claude/CLAUDE.md`. Create the file if it doesn't exist.
- `new-skill`: create a new SKILL.md at `~/.claude/skills/<slugified-theme>/SKILL.md` with the suggestion as the body. Tell the user to register it in their settings if needed.
- `patch-skill`: show the user which skill file to edit, display the suggested change, and apply it if they confirm.

**n — reject:**
- Mark dismissed. Do not apply.

**e — edit:**
- Show the suggestion text in full, let the user dictate changes, then apply the edited version.

## Step 4 — Clear applied/rejected suggestions

After processing all suggestions, remove handled entries from the pending file:

```bash
# Clear the file after all suggestions are resolved
> ~/.claude/observer/pending-suggestions.jsonl
```

Tell the user how many were applied vs dismissed.

## Notes

- Low-confidence suggestions: flag these explicitly and recommend the user scrutinize before approving.
- If a `patch-skill` suggestion names a skill that doesn't exist, treat it as `new-skill` instead.
- Never auto-apply without explicit user approval.
