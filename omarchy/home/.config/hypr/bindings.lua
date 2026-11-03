-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- omarchy-setup: close window with SUPER + Q instead of SUPER + W
hl.unbind("SUPER + W")
-- Don't close fullscreen windows (Hyprland fullscreen mode 2 or 3); exit fullscreen first.
function close_unless_fullscreen()
  local window = hl.get_active_window()
  if not window then
    return
  end

  if (tonumber(window.fullscreen) or 0) >= 2 then
    hl.exec_cmd("notify-send -t 1500 'Close blocked' 'Exit fullscreen first (Super+F)'")
    return
  end

  hl.dispatch(hl.dsp.window.close())
end

o.bind("SUPER + Q", "Close window", close_unless_fullscreen)

-- Screenshot a region/window: save to Pictures and copy to the clipboard.
o.bind("SUPER + SHIFT + S", "Screenshot (save + clipboard)", "omarchy-capture-screenshot smart slurp")

-- strata-installer: file-manager start
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = "/home/ishoapeng/.local/bin/strata" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)",
  "uwsm-app -- /home/ishoapeng/.local/bin/strata \"$(omarchy-cmd-terminal-cwd)\"")
-- strata-installer: file-manager end

-- Use Strata as the file manager (was: Nautilus).
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = "strata" })
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", 'uwsm-app -- strata "$(omarchy-cmd-terminal-cwd)"')

-- Power button does nothing (was: power menu). logind already ignores it.
hl.unbind("XF86PowerOff")


-- Background switcher: pull in new images from ~/Pictures/wallpapers first (was: same menu without the sync)
hl.unbind("SUPER + CTRL + SPACE")
o.bind("SUPER + CTRL + SPACE", "Background switcher", "$HOME/.local/bin/pictures-bg-sync; omarchy-menu toggle background")
