#!/usr/bin/env bash
# Copy home/ into $HOME. Existing differing files are kept once as <file>.pre-setup.
set -euo pipefail
SRC="$ROOT/home"

cd "$SRC"
find . -type f | while read -r f; do
  f="${f#./}"
  dst="$HOME/$f"
  mkdir -p "$(dirname "$dst")"
  if [[ -e $dst ]] && ! cmp -s "$f" "$dst" && [[ ! -e $dst.pre-setup ]]; then
    cp -p "$dst" "$dst.pre-setup"
  fi
  cp -p "$f" "$dst"
done
chmod +x "$HOME/.local/bin/pictures-bg-sync" "$HOME"/.config/omarchy/hooks/post-update.d/*.hook \
         "$HOME/.config/omarchy/hooks/theme-set.d/pictures-backgrounds"
mkdir -p "$HOME/Pictures/wallpapers"   # background picker source (add your own images)
echo "Dotfiles installed."
