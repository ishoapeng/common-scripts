#!/usr/bin/env bash
# Enable the system and user services in use on the reference machine.
set -euo pipefail

sudo systemctl enable --now \
  NetworkManager bluetooth cups.socket avahi-daemon docker.socket power-profiles-daemon \
  thermald intel_lpmd tailscaled ufw smb sddm systemd-resolved systemd-timesyncd systemd-oomd \
  || echo "WARN: some system services failed to enable"
sudo systemctl enable --now snapper-cleanup.timer limine-snapper-sync.service 2>/dev/null || true

systemctl --user daemon-reload
systemctl --user enable --now voxtype.service hyprmoncfgd.service 2>/dev/null || true
# macbook-mount needs the `mac` host in ~/.ssh/config and Tailscale logged in; enable it yourself:
#   systemctl --user enable --now macbook-mount.service
systemctl --user disable --now macbook-mount.service 2>/dev/null || true
