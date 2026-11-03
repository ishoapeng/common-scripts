#!/usr/bin/env bash
# Rebuild this Omarchy machine's setup on a fresh Omarchy install.
#
#   ./setup.sh            run every step
#   ./setup.sh packages   run only the named step(s)
#   ./setup.sh -l         list steps
#
# Steps live in scripts/NN-name.sh and run in order. Each is idempotent.
# Run as your normal user (not root); sudo is used where needed.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root." >&2
  exit 1
fi

mapfile -t ALL < <(ls "$ROOT/scripts" | grep -E '^[0-9]+-.*\.sh$' | sort)

name_of() { local n="${1#*-}"; echo "${n%.sh}"; }

if [[ ${1:-} == -l ]]; then
  for s in "${ALL[@]}"; do name_of "$s"; done
  exit 0
fi

want=("$@")
for s in "${ALL[@]}"; do
  n="$(name_of "$s")"
  if [[ ${#want[@]} -gt 0 ]] && [[ ! " ${want[*]} " == *" $n "* ]]; then continue; fi
  echo
  echo "==> $n"
  bash "$ROOT/scripts/$s"
done

echo
echo "Done. See README.md for the manual steps (logins, SSH keys, Tailscale)."
