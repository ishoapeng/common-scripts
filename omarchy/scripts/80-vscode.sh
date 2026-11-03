#!/usr/bin/env bash
# VS Code extensions (settings.json is installed by the dotfiles step).
set -euo pipefail
command -v code >/dev/null || { echo "code not installed"; exit 0; }
grep -vE '^\s*(#|$)' "$ROOT/packages/vscode-extensions.txt" | while read -r ext; do
  code --install-extension "$ext" --force
done
