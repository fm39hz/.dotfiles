local hs = require("hyprsplit")

hl.on("hyprland.start", function()
	-- =====================================================================
	-- 1. PERMISSIONS SYSTEM
	-- =====================================================================
	hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

	-- =====================================================================
	-- 2. KHÓA MÀN HÌNH LẬP TỨC VÀ GHIM TIÊU ĐIỂM WORKSPACE 2
	-- =====================================================================
	hl.exec_cmd("runapp hyprlock")
	hl.dispatch(hs.dsp.focus({ workspace = 2 }))

	-- =====================================================================
	-- 3. CORE SERVICES DAEMONS (Được dọn dẹp sang runapp)
	-- =====================================================================
	hl.exec_cmd("runapp fcitx5") -- Loại bỏ -d để hệ thống systemd quản lý chuẩn chỉ
	hl.exec_cmd("runapp hyprpaper")
	hl.exec_cmd("runapp hypridle")
	hl.exec_cmd("runapp hyprsunset")

	-- =====================================================================
	-- 4. PERFORMANCE PRE-PRIMING CACHE (Giữ nguyên luồng ngầm)
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
	-- 5. UI TIỆN ÍCH & MỒI ỨNG DỤNG NGẦM (Delay 300ms)
	-- =====================================================================
	hl.timer(function()
		-- Bật thanh Bar DMS qua kén C++ runapp siêu tốc
		hl.exec_cmd("runapp " .. os.getenv("HOME") .. "/.config/hypr/scripts/bar.sh")

		-- Khởi động Ghostty Terminal Daemon
		hl.exec_cmd("runapp ghostty --quit-after-last-window-closed=false --initial-window=false")

		-- Các thành phần quản lý thiết bị phần cứng
		hl.exec_cmd("runapp solaar --window=hide")
		hl.exec_cmd("runapp localsend --hidden")
		hl.exec_cmd("runapp mangohud steam -silent")

		-- Gọi ứng dụng đồ họa nặng trực tiếp qua runapp.
		-- Nhờ Window Rules, chúng tự chui ngầm vào Scratchpad không lệch một pixel tiêu điểm.
		hl.exec_cmd("runapp zen-browser")
		hl.exec_cmd("runapp 64gram-desktop")
	end, { timeout = 300, type = "oneshot" })
end)
