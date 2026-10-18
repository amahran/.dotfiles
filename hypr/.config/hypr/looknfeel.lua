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
