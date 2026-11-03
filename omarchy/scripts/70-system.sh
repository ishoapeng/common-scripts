#!/usr/bin/env bash
# System-level tweaks: docker, firewall rules, timezone, SDDM autologin.
set -euo pipefail

# Docker
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json >/dev/null <<'JSON'
{
    "log-driver": "json-file",
    "log-opts": { "max-size": "10m", "max-file": "5" },
    "dns": ["172.17.0.1"],
    "bip": "172.17.0.1/16"
}
JSON
sudo usermod -aG docker "$USER"

# Timezone
sudo timedatectl set-timezone Asia/Taipei

# SDDM autologin
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/autologin.conf >/dev/null <<CONF
[Autologin]
User=$USER
Session=omarchy.desktop
CONF

# Firewall: Sunshine (game streaming) + Samba over Tailscale, LocalSend on all interfaces.
sudo ufw default deny incoming
sudo ufw default allow outgoing
for p in 47984/tcp 47989/tcp 48010/tcp 47998/udp 47999/udp 48000/udp 48002/udp 48010/udp 5353/udp 445/tcp; do
  sudo ufw allow in on tailscale0 to any port "${p%/*}" proto "${p#*/}"
done
sudo ufw allow 53317            # LocalSend
command -v ufw-docker >/dev/null && sudo ufw-docker install || true
sudo ufw --force enable
echo "Log out and back in for the docker group to apply."
