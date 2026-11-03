#!/usr/bin/env bash
# Omarchy themes and shell plugins, pinned to the commits used on the reference machine.
set -euo pipefail
PLUG="$HOME/.config/omarchy/plugins"
THEMES="$HOME/.config/omarchy/themes"
mkdir -p "$PLUG" "$THEMES"

grep -vE '^\s*(#|$)' "$ROOT/packages/omarchy-themes.txt" | while read -r name url; do
  [[ -d $THEMES/$name ]] || git clone --depth 1 "$url" "$THEMES/$name"
done

grep -vE '^\s*(#|$)' "$ROOT/packages/omarchy-plugins.txt" | while read -r id url sha; do
  if [[ ! -d $PLUG/$id/.git ]]; then
    git clone "$url" "$PLUG/$id"
  fi
  git -C "$PLUG/$id" fetch --quiet origin || true
  git -C "$PLUG/$id" checkout --quiet "$sha" || echo "WARN: $id: could not check out $sha"
done

# Current theme on the reference machine.
omarchy theme set solitude || echo "WARN: could not set theme"
omarchy-restart-hyprland 2>/dev/null || hyprctl reload 2>/dev/null || true
