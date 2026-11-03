# Powerlevel10k instant prompt (keep at the very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Omarchy environment (OMARCHY_PATH + PATH)
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap
[[ -r /usr/share/omarchy/default/bash/envs ]] && source /usr/share/omarchy/default/bash/envs

# ---------------------------------------------------------------- Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"   # run `p10k configure` to restyle
DISABLE_AUTO_UPDATE=false
zstyle ':omz:update' mode reminder   # ask before updating Oh My Zsh
COMPLETION_WAITING_DOTS=true
HIST_STAMPS="yyyy-mm-dd"

# Extra completion definitions (must be on fpath before compinit)
fpath+="$ZSH/custom/plugins/zsh-completions/src"

plugins=(
  git                           # git aliases + completion
  sudo                          # press Esc twice to prefix last command with sudo
  extract                       # `extract <file>` for any archive type
  copypath                      # `copypath` copies current dir path
  copybuffer                    # Ctrl+O copies the current command line
  zsh-autosuggestions           # grey suggestions from history (→ to accept)
  zsh-history-substring-search  # type part of a command, ↑/↓ to search history
  zsh-syntax-highlighting       # colors valid/invalid commands as you type
)

# Live completion menu below the prompt (must load before compinit)
source "$ZSH/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

source "$ZSH/oh-my-zsh.sh"

# ---------------------------------------------------------------- History
HISTSIZE=32768
SAVEHIST=32768
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# ---------------------------------------------------------------- Completion tweaks
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'  # case-insensitive
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Autosuggestions: use history, then completion engine
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'   # visible grey on dark themes
bindkey '^ ' autosuggest-accept   # Ctrl+Space also accepts the suggestion

# Arrow keys are handled by zsh-autocomplete (menu navigation); Ctrl+P/N search history by substring
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# ---------------------------------------------------------------- Omarchy aliases & functions
source "$OMARCHY_PATH/default/bash/aliases"
unalias ga gd 2>/dev/null   # Omarchy defines these as worktree functions
for f in "$OMARCHY_PATH"/default/bash/fns/*; do source "$f"; done

# ---------------------------------------------------------------- Tool init
command -v mise     &>/dev/null && eval "$(mise activate zsh)"
command -v zoxide   &>/dev/null && eval "$(zoxide init zsh)"
command -v fzf      &>/dev/null && source <(fzf --zsh)   # Ctrl+R history, Ctrl+T files, Alt+C dirs

# Powerlevel10k prompt config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ---------------------------------------------------------------- Your own stuff
# omarchy-setup: n -> micro
n() { micro "$@"; }
