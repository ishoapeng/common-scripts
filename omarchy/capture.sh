#!/usr/bin/env bash
# Refresh this repo from the current machine (the reverse of setup.sh).
#   ./capture.sh          update home/, packages/ and plugin pins
#   ./capture.sh --push   same, then commit and push if anything changed
# Files copied are exactly those listed in dotfiles.txt; add a path there to track a new file.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

grep -vE '^\s*(#|$)' dotfiles.txt | while read -r f; do
  if [[ -f $HOME/$f ]]; then
    mkdir -p "home/$(dirname "$f")"
    cp -p "$HOME/$f" "home/$f"
  else
    echo "missing on this machine, kept repo copy: $f" >&2
  fi
done

pacman -Qeq | grep -vxFf <(pacman -Qemq) | sort > packages/pacman.txt
pacman -Qemq | sort > packages/aur.txt
command -v code >/dev/null && code --list-extensions | grep -v '^local\.' | sort > packages/vscode-extensions.txt

# Re-pin plugin commits for the plugins already listed.
tmp="$(mktemp)"
while read -r line; do
  if [[ $line =~ ^# || -z $line ]]; then echo "$line"; continue; fi
  read -r id url sha <<<"$line"
  d="$HOME/.config/omarchy/plugins/$id"
  [[ -d $d/.git ]] && sha="$(git -C "$d" rev-parse HEAD)"
  echo "$id $url $sha"
done < packages/omarchy-plugins.txt > "$tmp"
mv "$tmp" packages/omarchy-plugins.txt

# Safety net: refuse to commit anything that looks like a secret.
if grep -rnEI 'BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|(api[_-]?key|secret|password)\s*[=:]\s*\S{8,}' home packages; then
  echo "Possible secret found above. Not committing." >&2; exit 1
fi

git -C "$ROOT" status --short .
if [[ ${1:-} == --push ]]; then
  git -C "$ROOT" add -A .
  git -C "$ROOT" diff --cached --quiet && { echo "Nothing to commit."; exit 0; }
  git -C "$ROOT" commit -q -m "Update Omarchy setup from machine"
  git -C "$ROOT" push
fi
