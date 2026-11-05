-- Personal keybindings, loaded after Omarchy's defaults (list them all with
-- `omarchy menu keybindings --print`). Everything not changed here stays
-- Omarchy's.
--
-- Use o.rebind for a key Omarchy already binds (it unbinds it first; a plain
-- o.bind would add a second action on the same key). Omarchy actions displaced
-- that way move to the key noted.

-- Focus and swap windows with h/j/k/l ----------------------------------------
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.rebind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" })) -- was: toggle window split -> SUPER + ALT + J
o.rebind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" })) -- was: keybindings -> SUPER + F1
o.rebind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" })) -- was: cycle workspace layout -> SUPER + ALT + L

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + F1", "Keybindings", "omarchy-menu-keybindings")
-- was: cycle workspace layout back -> SUPER + ALT + SHIFT + L
o.rebind("SUPER + ALT + L", "Cycle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + SHIFT + L", "Cycle workspace layout back", "omarchy-hyprland-workspace-layout-toggle back")

-- Apps -----------------------------------------------------------------------
o.rebind("SUPER + BACKSPACE", "Terminal", { omarchy = "terminal" }) -- was: toggle window transparency -> SUPER + SHIFT + BACKSPACE
o.rebind("SUPER + SHIFT + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle") -- was: toggle window gaps -> Appearance menu
o.bind("SUPER + D", "Apps menu", "omarchy-menu toggle apps")

-- Capture --------------------------------------------------------------------
hl.unbind("PRINT") -- was: screenshot -> SUPER + ALT + P
hl.unbind("ALT + PRINT") -- was: screenrecording -> SUPER + ALT + R
hl.unbind("SUPER + CTRL + PRINT") -- was: extract text (OCR) -> SUPER + ALT + T

o.bind("SUPER + ALT + P", "Screenshot", "omarchy-capture-screenshot")
o.bind("SUPER + ALT + R", "Screenrecording", "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord")
o.bind("SUPER + ALT + T", "Extract text (OCR) from screenshot", "omarchy-capture-text")

-- Insta360 Link 2C: turn off auto framing, reset to a static frame
o.bind("ALT + SHIFT + C", "Webcam static frame", os.getenv("HOME") .. "/.local/scripts/link2c-static-frame.sh")

-- Quick notes (window rules in looknfeel.lua) ---------------------------------
o.bind("SUPER + ALT + N", "Quick capture", "kitty --class=local.capture " .. os.getenv("HOME") .. "/.local/scripts/capture")
o.bind("SUPER + ALT + I", "Open inbox", "kitty --class=local.inbox nvim " .. os.getenv("HOME") .. "/notes/inbox.md")
