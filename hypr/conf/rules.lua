-- Global Fixes
hl.window_rule({ match = { class = "^$", title = "^$" }, opacity = "1.0 override", no_blur = true })

-- Apps Specific
hl.window_rule({ match = { initial_class = "io.github.tdesktop_x64.TDesktop" }, workspace = "special:chat" })
hl.window_rule({ match = { class = "^jetbrains-.+$", float = true }, tag = "+jb" })
hl.window_rule({ match = { tag = "jb" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^$" }, stay_focused = true, min_size = { 1, 1 } })

hl.window_rule({ match = { initial_class = "zen" }, workspace = "special:browser" })
hl.window_rule({ match = { initial_title = "Steam", initial_class = "" }, workspace = "special:scratchpad" })

-- Browser Popups
hl.window_rule({
	match = { class = "^(floorp|zen|brave-.*)$", title = "^(Library|Đăng nhập.*|Extension.*|Untitled.*)$" },
	float = true,
})
