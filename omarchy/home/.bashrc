# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# ble.sh: as-you-type suggestions and Tab menu (loads only if installed)
[[ $- == *i* && -f /usr/share/blesh/ble.sh ]] && source /usr/share/blesh/ble.sh --noattach


# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# omarchy-setup: n -> micro
n() { micro "$@"; }

# Terminal greeting: system info + a random quote (once per terminal window)
if [[ -z $TERMINAL_GREETED && -t 1 && -z $TMUX ]]; then
  export TERMINAL_GREETED=1
  command -v fastfetch >/dev/null && fastfetch
  if command -v fortune >/dev/null; then
    fortune -s
  else
    quotes=(
      "Simplicity is prerequisite for reliability. — Edsger Dijkstra"
      "Talk is cheap. Show me the code. — Linus Torvalds"
      "Make it work, make it right, make it fast. — Kent Beck"
      "The best way to predict the future is to invent it. — Alan Kay"
      "First, solve the problem. Then, write the code. — John Johnson"
      "Programs must be written for people to read. — Harold Abelson"
      "Stay hungry, stay foolish. — Stewart Brand"
      "Done is better than perfect."
    )
    printf '\e[3;90m%s\e[0m\n' "${quotes[RANDOM % ${#quotes[@]}]}"
  fi
  echo
fi

# Let Tab complete individual omarchy-* commands too (Omarchy hides them by default)
complete -I -A command

# Save each command to history right away and share it between open terminals
if [[ ${BLE_VERSION-} ]]; then bleopt history_share=1; ble-face auto_complete=fg=244; else PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"; fi

# Start ble.sh (keep this last)
[[ ${BLE_VERSION-} ]] && ble-attach
