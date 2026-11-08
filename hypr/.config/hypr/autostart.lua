-- Extra apps at login.
--
-- Omarchy gives every monitor its own workspaces 1-10, backed by a block of
-- real Hyprland ids (the Dell 1-10, the laptop 11-20, the Acer 21-30, ...).
-- So ask Omarchy for the real id of a slot on the focused monitor instead of
-- hardcoding a number, or the windows land on another monitor's workspaces and
-- show up in the bar as extra "guest" workspaces.
local function slot(n)
  local monitor = hl.get_active_monitor()
  if not monitor then
    return tostring(n) .. " silent"
  end
  return tostring(o.workspaces.workspace_id(monitor, n)) .. " silent"
end

-- claude-desktop is a launcher script, so match its window class instead.
-- Registered at config load (for reloads) and again at start, since monitors
-- may not exist yet when the config is first read.
local function claude_rule()
  if hl.get_active_monitor() then
    o.window("^com\\.anthropic\\.Claude$", { workspace = slot(4) })
  end
end

claude_rule()

-- Chrome and Ghostty are started directly (not through Omarchy's launchers,
-- which detach them) so the workspace rule can match the new window.
hl.on("hyprland.start", function()
  claude_rule()
  hl.exec_cmd("google-chrome-stable", { workspace = slot(1) })
  hl.exec_cmd("ghostty", { workspace = slot(3) })
  hl.exec_cmd("claude-desktop")
  -- Tray applet for the work VPN (package installed by ~/work/setup)
  hl.exec_cmd("command -v nm-applet >/dev/null && nm-applet --indicator")
end)

o.launch_on_start("bitwarden-desktop")
