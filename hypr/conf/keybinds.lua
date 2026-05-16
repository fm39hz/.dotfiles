local hs = require("hyprsplit")
local logic = require("conf.logic")

local mainMod = "SUPER"
local terminal = "ghostty"
local terminalCli = "kitty"
local scripts = os.getenv("HOME") .. "/.config/hypr/scripts/"

-- =====================================================================
-- BINDS HỆ THỐNG CƠ BẢN (Đã bọc runapp cho Terminal tốc độ cao)
-- =====================================================================
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("runapp " .. terminal))
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + BACKSPACE", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd("runapp " .. terminalCli .. " btop"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- =====================================================================
-- DANK MATERIAL SHELL (DMS) - IPC CORE CALLS (Giữ nguyên Direct IPC)
-- =====================================================================
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind(mainMod .. " + SHIFT + ALT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))

hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind(mainMod .. " + ALT + M", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))

-- =====================================================================
-- SCREENSHOTS DMS (Bọc runapp để systemd quản lý bộ nhớ đệm ảnh)
-- =====================================================================
hl.bind("PRINT", hl.dsp.exec_cmd("runapp dms screenshot full"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("runapp dms screenshot"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("runapp dms screenshot window"))

-- Multimedia & Brightness (DMS Native IPC)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })
hl.bind(
	"CTRL + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("dms ipc call mpris increment 3"),
	{ repeating = true, locked = true }
)
hl.bind(
	"CTRL + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("dms ipc call mpris decrement 3"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("dms ipc call brightness increment 5 ''"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("dms ipc call brightness decrement 5 ''"),
	{ repeating = true, locked = true }
)

-- =====================================================================
-- HYPRSPLIT WORKSPACES
-- =====================================================================
for i = 1, 5 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hs.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + F12", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind(mainMod .. " + G", hs.dsp.grab_rogue_windows())

-- =====================================================================
-- SPECIAL WORKSPACES & APP LOGIC
-- =====================================================================
local specials = { P = "scratchpad", C = "chat", D = "debug", B = "browser", N = "note" }
for key, name in pairs(specials) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.workspace.toggle_special(name))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "special:" .. name }))
end

hl.bind(mainMod .. " + CTRL + B", function()
	logic.app_focus("zen", "zen-browser", "special:browser", true)
end)
hl.bind(mainMod .. " + CTRL + C", function()
	logic.app_focus("64Gram", "64gram-desktop", "special:chat", true)
end)
hl.bind(mainMod .. " + CTRL + N", function()
	logic.app_focus(
		"obsidian",
		"obsidian",
		"special:note",
		true,
		"--enable-features=UseOzonePlatform --ozone-platform=wayland"
	)
end)

-- =====================================================================
-- WINDOW NAVIGATION & RESIZE
-- =====================================================================
local directions = { H = "l", L = "r", K = "u", J = "d", left = "l", right = "r", up = "u", down = "d" }
for key, dir in pairs(directions) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

hl.bind(mainMod .. " + R", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"))

-- =====================================================================
-- LAPTOP PARTS
-- =====================================================================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("runapp " .. scripts .. "sleep.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("runapp " .. scripts .. "unlock.sh"), { locked = true })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
