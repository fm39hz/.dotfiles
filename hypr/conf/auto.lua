local hs = require("hyprsplit")

hl.on("hyprland.start", function()
	-- =====================================================================
	-- 1. PERMISSIONS
	-- =====================================================================
	hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

	-- =====================================================================
	-- 2. SHELL
	-- =====================================================================
	hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/bar.sh")
	hl.dispatch(hs.dsp.focus({ workspace = 2 }))

	-- =====================================================================
	-- 3. CORE SERVICES DAEMONS
	-- =====================================================================
	hl.exec_cmd("runapp fcitx5")
	hl.exec_cmd("runapp hyprpaper")
	hl.exec_cmd("runapp hypridle")
	hl.exec_cmd("runapp hyprsunset")

	-- =====================================================================
	-- 4. PERFORMANCE PRE-PRIMING CACHE
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
	-- 5. BOOTSTRAP UI & ESSENTIALS
	-- =====================================================================
	hl.timer(function()
		-- hl.exec_cmd("runapp ghostty --quit-after-last-window-closed=false --initial-window=false")
		hl.exec_cmd("runapp kitty -1 —start-as=hidden")

		hl.exec_cmd("runapp solaar --window=hide")
		hl.exec_cmd("runapp localsend --hidden")
		hl.exec_cmd("runapp mangohud steam -silent")

		hl.exec_cmd("runapp zen-browser")
		hl.exec_cmd("runapp 64gram-desktop")
	end, { timeout = 300, type = "oneshot" })
end)
