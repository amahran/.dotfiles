-- Personal keybindings, loaded after Omarchy's defaults (list them all with
-- `omarchy menu keybindings --print`). Everything not changed here stays
-- Omarchy's.
--
-- Omarchy rule: a key Omarchy already binds must be unbound before it's
-- bound again. Omarchy actions displaced that way move to the key noted.

-- Focus and swap windows with h/j/k/l ----------------------------------------
hl.unbind("SUPER + J") -- was: toggle window split   -> SUPER + ALT + J
hl.unbind("SUPER + K") -- was: keybindings           -> SUPER + F1
hl.unbind("SUPER + L") -- was: toggle workspace layout -> SUPER + ALT + L

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + F1", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Apps -----------------------------------------------------------------------
hl.unbind("SUPER + BACKSPACE") -- was: toggle window transparency -> SUPER + SHIFT + BACKSPACE
hl.unbind("SUPER + SHIFT + BACKSPACE") -- was: toggle window gaps -> NONE

o.bind("SUPER + BACKSPACE", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle")
o.bind("SUPER + D", "Apps menu", "omarchy-menu toggle apps")

-- Insta360 Link 2C: turn off auto framing, reset to a static frame
o.bind("ALT + SHIFT + C", "Webcam static frame", os.getenv("HOME") .. "/.local/scripts/link2c-static-frame.sh")
