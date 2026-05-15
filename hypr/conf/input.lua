hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 2,
		touchpad = {
			natural_scroll = true,
		},
		mouse_refocus = false,
		sensitivity = 0,
		numlock_by_default = true,
		special_fallthrough = true,
	},
	cursor = {
		no_hardware_cursors = 2, -- 'auto' (nvidia) hoặc true/false tùy máy bạn, tài liệu ghi 0/1/2
	},
	gestures = {
		workspace_swipe_distance = 200,
	},
})

-- Per-device config
-- Chú ý: Tài liệu yêu cầu dùng hl.config cho device hoặc hl.bind với flag devices.
-- Thông thường device được định nghĩa trực tiếp trong hl.config:
hl.config({})
