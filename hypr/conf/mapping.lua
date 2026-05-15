local hs = require("hyprsplit")
local logic = require("conf.logic")

local mainMod = "SUPER"
local terminal = "ghostty"
local terminalCli = "kitty"
local scripts = os.getenv("HOME") .. "/.config/hypr/scripts/"
local hyprShotDir = os.getenv("HOME") .. "/Pictures/ScreenShots"

-- =====================================================================
-- BINDS HỆ THỐNG CƠ BẢN
-- =====================================================================
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + BACKSPACE", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd(terminalCli .. " btop"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- =====================================================================
-- QUICKSHELL DISPATCHERS (Dùng Native Lua hoàn toàn để Portal nhận diện)
-- =====================================================================
hl.bind(mainMod .. " + SPACE", hl.dsp.global("border:launcher"))
hl.bind(mainMod .. " + DELETE", hl.dsp.global("border:clearNotifs"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.global("border:session"))
hl.bind("ALT + ESCAPE", hl.dsp.global("border:showall"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scripts .. "bar.sh"))

-- =====================================================================
-- SCREENSHOTS & MULTIMEDIA
-- =====================================================================
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -o " .. hyprShotDir))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o " .. hyprShotDir))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o " .. hyprShotDir))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +1%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -1%"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"), { repeating = true })

-- =====================================================================
-- HYPRSPLIT WORKSPACES (Quản lý 5 workspaces độc lập mỗi monitor)
-- =====================================================================
for i = 1, 5 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hs.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + F12", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind(mainMod .. " + G", hs.dsp.grab_rogue_windows())

-- =====================================================================
-- SPECIAL WORKSPACES (Scratchpads)
-- =====================================================================
local specials = { P = "scratchpad", C = "chat", D = "debug", B = "browser", N = "note", M = "music" }
for key, name in pairs(specials) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.workspace.toggle_special(name))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "special:" .. name }))
end

-- =====================================================================
-- APP FOCUS LOGIC (Điều hướng thông minh qua logic.lua)
-- =====================================================================
hl.bind(mainMod .. " + CTRL + B", function()
	logic.app_focus("zen", "zen-browser", "special:browser")
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
hl.bind(mainMod .. " + CTRL + M", function()
	logic.app_focus("spotify", "spotify", "special:music", true)
end)

-- =====================================================================
-- LID SWITCH (Laptop)
-- =====================================================================
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(scripts .. "sleep.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd(scripts .. "unlock.sh"), { locked = true })

-- =====================================================================
-- MOVEMENT & RESIZE (Vim keys & Arrow keys)
-- =====================================================================
local directions = { H = "l", L = "r", K = "u", J = "d", left = "l", right = "r", up = "u", down = "d" }
for key, dir in pairs(directions) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Hoàn thiện hệ thống Resize động bằng phím tắt
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

-- =====================================================================
-- MOUSE BINDS NATIVE (Kéo thả chuẩn chỉ, KHÔNG chặn click thường)
-- =====================================================================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Trackpad Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
