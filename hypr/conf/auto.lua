hl.on("hyprland.start", function()
	-- =====================================================================
	-- Permission
	-- =====================================================================
	hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

	-- =====================================================================
	-- Environment & Core Services
	-- =====================================================================
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && "
			.. "/usr/libexec/polkit-gnome-authentication-agent-1 & "
			.. "hyprctl setcursor everforest-cursors 32 && "
			.. "hyprpm reload && "
			.. "lxsession & fcitx5 -d & hyprpaper & hypridle & hyprsunset"
	)

	-- =====================================================================
	-- Cache
	-- =====================================================================
	hl.exec_cmd([[
        NU_VENDOR_DIR=$(nu -c 'print ($nu.data-dir | path join "vendor/autoload")')
        mkdir -p "$NU_VENDOR_DIR"
        sesh list >/dev/null 2>&1 &
        starship init nu > "$NU_VENDOR_DIR/starship.nu" &
        zoxide init nushell > "$NU_VENDOR_DIR/zoxide.nu" &
        STARSHIP_SHELL="nu" starship prompt --status=0 >/dev/null 2>&1 &
    ]])

	-- =====================================================================
	-- UI
	-- =====================================================================
	hl.timer(function()
		-- Bar
		hl.exec_cmd("~/.config/hypr/scripts/bar.sh")

		-- Terminal
		hl.exec_cmd("ghostty --quit-after-last-window-closed=false --initial-window=false")

		-- Devices
		hl.exec_cmd("solaar --window=hide")
		hl.exec_cmd("localsend --hidden")
		hl.exec_cmd("mangohud steam -silent")

		-- Bootstrap workspace
		local logic = require("conf.logic")
		logic.app_focus("zen", "zen-browser", "special:browser", true)
		logic.app_focus("64Gram", "64gram-desktop", "special:chat", true)

		-- Default workspace focus
		hl.dispatch(hl.dsp.focus({ workspace = 2 }))
	end, { timeout = 250, type = "oneshot" })
end)
