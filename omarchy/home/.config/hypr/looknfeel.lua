-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Rounded window corners.
hl.config({
  decoration = {
    rounding = 10,
  },
})

-- Focused window fully opaque (default was 0.985); unfocused stays slightly see-through.
o.window({ tag = "default-opacity" }, { opacity = "1.0 0.96" })

-- See-through terminals so the wallpaper shows through (blurred).
o.window({ tag = "terminal" }, { tag = "-default-opacity", opacity = "0.95 0.9" })
hl.config({ decoration = { blur = { enabled = true, size = 6, passes = 2 } } })

-- Strata file manager at 90% opacity (85% when unfocused).
o.window({ class = "^io\\.github\\.lgse\\.Strata$" }, { tag = "-default-opacity", opacity = "0.9 0.85" })

-- Don't recenter/warp the cursor when switching workspaces, monitors or focus.
hl.config({
  cursor = {
    no_warps = true,
    warp_on_change_workspace = 0,
  },
})
