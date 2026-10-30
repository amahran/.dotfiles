-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- Keep the two variable names below: Omarchy's SUPER + / scaling hotkey edits
-- them in place.

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Fallback for anything not listed below
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel (Dell Precision)
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto-left", scale = 1 })

-- Docked: the dock's MST hub gets its DP-n names handed out at connect time, so
-- they change between boots. Scale externals by resolution, not by DP-n.
local function scale_by_resolution()
	for _, monitor in ipairs(hl.get_monitors()) do
		local scale = (monitor.height >= 2160 and 1.5) or (monitor.height >= 1440 and 1.25)
		if scale then
			hl.monitor({ output = monitor.name, mode = "preferred", position = "auto", scale = scale })
		end
	end
end

-- Reloads drop the rules set here, and no monitor event fires, so also run on load
scale_by_resolution()
hl.on("hyprland.start", scale_by_resolution)
hl.on("monitor.added", scale_by_resolution)
