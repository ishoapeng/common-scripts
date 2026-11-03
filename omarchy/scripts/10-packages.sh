#!/usr/bin/env bash
# Install pacman (incl. the Omarchy repo) and AUR packages.
set -euo pipefail
P="$ROOT/packages"

strip() { grep -vE '^\s*(#|$)' "$1"; }

# Packages that no longer exist in the repos are skipped instead of aborting the run.
mapfile -t want < <(strip "$P/pacman.txt")
avail=(); missing=()
for p in "${want[@]}"; do
  if pacman -Si "$p" &>/dev/null || pacman -Qq "$p" &>/dev/null; then avail+=("$p"); else missing+=("$p"); fi
done
[[ ${#missing[@]} -gt 0 ]] && echo "Not found in repos, skipping: ${missing[*]}"
sudo pacman -S --needed --noconfirm "${avail[@]}"

command -v yay >/dev/null || { echo "yay missing (it is in pacman.txt; install failed?)"; exit 1; }
mapfile -t aur < <(strip "$P/aur.txt")
yay -S --needed --noconfirm "${aur[@]}"
