-- Global Fixes
hl.window_rule({ match = { class = "^$", title = "^$" }, opacity = "1.0 override", no_blur = true })

-- Apps Specific
hl.window_rule({ match = { initial_class = "io.github.tdesktop_x64.TDesktop" }, workspace = "special:chat" })
hl.window_rule({ match = { class = "^jetbrains-.+$", float = true }, tag = "+jb" })
hl.window_rule({ match = { tag = "jb" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^$" }, stay_focused = true, min_size = { 1, 1 } })

-- Browser Popups (Phối hợp từ firefox.conf/electron.conf)
hl.window_rule({
	match = { class = "^(floorp|zen|brave-.*)$", title = "^(Library|Đăng nhập.*|Extension.*|Untitled.*)$" },
	float = true,
})
