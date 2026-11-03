# Omarchy setup

Rebuilds my Omarchy laptop (ASUS ROG, NVIDIA + Intel, 2560x1600@240) on a fresh Omarchy install.

```bash
git clone git@github.com-personal:ishoapeng/common-scripts.git
cd common-scripts/omarchy
./setup.sh          # everything, in order
./setup.sh -l       # list steps
./setup.sh dotfiles # just one step (or several: ./setup.sh dotfiles shell)
```

Run as your normal user. Every step is idempotent. Existing files that differ are saved once as `<file>.pre-setup`.

## Steps

| Step | What it does |
|---|---|
| `packages` | `packages/pacman.txt` (explicitly installed repo packages, incl. the Omarchy repo) and `packages/aur.txt` via yay. Packages that no longer exist are skipped with a message. |
| `dotfiles` | Copies `home/` into `$HOME`: Hyprland (Lua) config, Omarchy shell/bar layout, hooks, menu extension, custom theme `alfa-palette`, zsh/bash/p10k, git, mise, starship, Voxtype, Sunshine, ROG, fcitx5, VS Code settings, systemd user units, autostart entries, hyprmoncfg profile. |
| `shell` | Oh My Zsh + plugins + Powerlevel10k, zsh as login shell. |
| `mise` | node, claude, codex, gh, Shopify CLI from `~/.config/mise/config.toml`. |
| `omarchy-extras` | Themes (`ash`, `abyssal-cartographer`), 17 shell plugins pinned to exact commits, then sets theme `solitude`. |
| `services` | Enables system and user services. |
| `system` | Docker daemon config + group, timezone (Asia/Taipei), SDDM autologin, UFW rules (Sunshine/Samba on Tailscale, LocalSend). |
| `vscode` | Extensions. |
| `strata` | Strata file manager (upstream installer). |

## Manual steps (not scripted on purpose)

- **SSH keys**: never stored here. Generate or restore them, then recreate `~/.ssh/config` (the `mac` host is needed by `macbook-mount.service`, which is left disabled).
- **Logins**: `tailscale up`, Dropbox, Discord (Vesktop), `gh auth login`, `claude`, AWS (`aws configure`), ngrok, Snyk.
- **Sunshine**: set the admin user/password in the web UI at https://localhost:47990 and re-pair devices (credentials are not saved).
- **Wallpapers**: put images in `~/Pictures/wallpapers`; `pictures-bg-sync` links them into the background picker.
- **Docker group**: log out and in after the `system` step.
- **Disk encryption / TPM unlock, bootloader, mkinitcpio, NVIDIA modules**: hardware- and install-specific; handled by the Omarchy installer, not here.

## Not captured

Secrets and state: `~/.ssh`, `~/.aws`, `~/.claude*`, Sunshine credentials/state, browser profiles, Strata settings, clipboard history, audio device preferences (Bluetooth MAC), shell history, Steam/game data, and `*.bak*` files.

## Refreshing this repo from the machine

`packages/*.txt` came from `pacman -Qeq` (split by `pacman -Qemq` for AUR), `code --list-extensions`, and `git rev-parse HEAD` in each plugin directory. Config files under `home/` are plain copies of the originals.
