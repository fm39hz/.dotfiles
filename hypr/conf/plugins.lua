-- Nếu bạn clone vào ~/.config/hypr/hyprsplit
local hs = require("hyprsplit")

hs.config({
	num_workspaces = 5,
	persistent_workspaces = true,
})

-- Thiết lập thứ tự ưu tiên monitor
hs.monitor_priority({ "eDP-1", "DP-1", "HDMI-A-1" })
