#!/usr/bin/env bash
# Install the tools pinned in ~/.config/mise/config.toml (node, claude, codex, gh, shopify cli).
set -euo pipefail
command -v mise >/dev/null || { echo "mise not installed"; exit 1; }
mise install --yes
mise ls
