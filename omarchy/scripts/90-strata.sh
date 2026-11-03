#!/usr/bin/env bash
# Strata file manager (bound to SUPER+SHIFT+F in hypr/bindings.lua). Not packaged; upstream installer.
set -euo pipefail
if [[ -x $HOME/.local/bin/strata ]]; then echo "Strata already installed."; exit 0; fi
curl -fsSL https://raw.githubusercontent.com/lgse/strata/main/install.sh | bash
