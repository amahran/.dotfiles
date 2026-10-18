-- Personal input overrides, loaded after Omarchy's defaults.
-- (Keyboard layout comes from the installer; set kb_layout here to override.)

hl.config({
  input = {
    touchpad = {
      natural_scroll = true,
    },
  },
})

-- Three-finger swipe to change workspace
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
