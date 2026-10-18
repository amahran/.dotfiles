-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- Keep the two variable names below: Omarchy's SUPER + / scaling hotkey edits
-- them in place.

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Fallback for anything not listed below
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel (Dell Precision)
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })

-- Docked: the external monitor shows up as DP-4, DP-5 or DP-6 depending on
-- the dock port. Check the current name with `hyprctl monitors` and adjust.
hl.monitor({ output = "DP-4", mode = "preferred", position = "auto", scale = 1.5 })
hl.monitor({ output = "DP-5", mode = "preferred", position = "auto", scale = 1.25 })
hl.monitor({ output = "DP-6", mode = "preferred", position = "auto", scale = 1.25 })
