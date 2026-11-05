-- Look'n'feel overrides.
-- Border colours are left to the Omarchy theme.

hl.config({
  general = {
    gaps_in = 0, -- no gaps between windows
    gaps_out = 0, -- or around the screen edges
    border_size = 1,
    resize_on_border = true,
  },

  decoration = {
    rounding = 5,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = false,
  },
})

-- Floating calculator
o.window({ title = "^(Calculator)$" }, { float = true })

-- Quick notes popups (keys in bindings.lua)
o.window("^local\\.capture$", { name = "quick-capture", float = true, center = true, size = { 700, 240 } })
o.window("^local\\.inbox$", { name = "inbox", float = true, center = true, size = { 1100, 700 } })

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
