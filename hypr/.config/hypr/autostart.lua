-- Extra apps at login.
--
-- Chrome and kitty are started directly (not through Omarchy's launchers,
-- which detach them) so the workspace rule can match the new window.
hl.on("hyprland.start", function()
  hl.exec_cmd("google-chrome-stable", { workspace = "1 silent" })
  hl.exec_cmd("kitty", { workspace = "3 silent" })
  hl.exec_cmd("claude-desktop")
  -- Tray applet for the work VPN (package installed by ~/work/setup)
  hl.exec_cmd("command -v nm-applet >/dev/null && nm-applet --indicator")
end)

-- claude-desktop is a launcher script, so match its window class instead.
o.window("^com\\.anthropic\\.Claude$", { workspace = "4 silent" })
