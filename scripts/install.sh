#!/usr/bin/env bash
set -e

REPO="msdakot/ai-foundary"
DEST="${HOME}/.claude/plugins/ai-foundary"

echo "Installing ai-foundry → ${DEST}"

if [ -d "$DEST" ]; then
  echo "Already installed. Pulling latest..."
  git -C "$DEST" pull --ff-only
else
  git clone "https://github.com/${REPO}.git" "$DEST"
fi

echo "Done. ai-foundry installed at ${DEST}"
