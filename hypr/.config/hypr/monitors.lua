-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- Omarchy's scaling hotkey (SUPER + /, SUPER + ALT + /) and the shell's monitor
-- panel write here:
--   - `omarchy_gdk_scale` is set to the lowest monitor scale, rounded, so keep
--     that variable name.
--   - The scale on a one-line rule naming the focused connector (eDP-1 below)
--     is replaced with the new number. For a monitor with no such rule, a new
--     DP-n line is added after the fallback. For a docked monitor, move that
--     value into `known_monitors` and delete the DP-n line.
-- `omarchy_monitor_scale` is just a name for the fallback's scale; nothing
-- edits it.

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Fallback for any monitor not listed below: Hyprland picks the scale
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel (Dell Precision)
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto-left", scale = 1.25 })

-- External monitors, matched by make/model/serial instead of the DP-n
-- connector: the dock's MST hub hands DP-n names out at connect time, so they
-- change between boots. This is the same identity Omarchy's per-monitor
-- workspaces use.
--
-- To add one: plug it in, then copy its description
--   hyprctl monitors -j | jq -r '.[] | "\(.name)  \(.description)  \(.width)x\(.height)"'
-- (or the `description:` line of plain `hyprctl monitors`) into the table
-- below with the scale you want. Changes apply on save.
local known_monitors = {
	["Dell Inc. DELL U2724D F5BS4Z3"] = 1.25, -- 27" 1440p
    ["Acer Technologies XB323QK"] = 1.5, -- 32" 2160p
}

for description, scale in pairs(known_monitors) do
	hl.monitor({ output = "desc:" .. description, mode = "preferred", position = "auto", scale = scale })
end
