hl.on("hyprland.start", function()
	-- Core Services
	hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("/usr/libexec/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("hyprctl setcursor everforest-cursors 32")
	hl.exec_cmd("hyprpm reload")
	hl.exec_cmd("lxsession & fcitx5 -d & hyprpaper & hypridle & hyprsunset")
	hl.exec_cmd("~/.config/hypr/scripts/bar.sh")

	-- Priming Performance (Giữ nguyên logic static init của bạn)
	hl.exec_cmd([[
        NU_VENDOR_DIR=$(nu -c 'print ($nu.data-dir | path join "vendor/autoload")')
        mkdir -p "$NU_VENDOR_DIR"
        starship init nu > "$NU_VENDOR_DIR/starship.nu" &
        zoxide init nushell > "$NU_VENDOR_DIR/zoxide.nu" &
        sesh list >/dev/null 2>&1 &
        STARSHIP_SHELL="nu" starship prompt --status=0 >/dev/null 2>&1 &
    ]])

	-- Apps Autostart
	hl.timer(function()
		hl.exec_cmd("ghostty --quit-after-last-window-closed=false --initial-window=false")

		-- Gọi trực tiếp logic focus (Sẽ khởi chạy vì chưa có window)
		local logic = require("conf.logic")
		logic.app_focus("zen", "zen-browser", "special:browser")
		logic.app_focus("64Gram", "64gram-desktop", "special:chat", true)

		hl.dispatch(hl.dsp.workspace.focus({ workspace = 2 }))
	end, { timeout = 1000, type = "oneshot" })
end)
