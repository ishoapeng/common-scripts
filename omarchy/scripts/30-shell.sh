#!/usr/bin/env bash
# zsh as login shell + Oh My Zsh, plugins and Powerlevel10k.
set -euo pipefail

if [[ ! -d $HOME/.oh-my-zsh ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
grep -vE '^\s*(#|$)' "$ROOT/packages/oh-my-zsh-extras.txt" | while read -r kind name url; do
  [[ -d $ZC/$kind/$name ]] || git clone --depth 1 "$url" "$ZC/$kind/$name"
done

# 20-dotfiles installs the real .zshrc; re-run it in case Oh My Zsh replaced it.
bash "$ROOT/scripts/20-dotfiles.sh" >/dev/null

if [[ $SHELL != */zsh ]]; then
  chsh -s "$(command -v zsh)"
fi
