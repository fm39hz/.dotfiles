hl.config({
	decoration = {
		rounding = 10,
		active_opacity = 1.0,
		inactive_opacity = 0.8,
		blur = {
			enabled = true,
			size = 2,
			passes = 3,
			new_optimizations = true,
		},
	},
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		["col.active_border"] = "rgba(a7c080ff)",
		["col.inactive_border"] = "rgba(3d484dff)",
		layout = "dwindle",
	},
	misc = {
		vrr = 1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		["col.splash"] = "rgba(a7c080ff)",
	},
	dwindle = {
		force_split = 2,
		preserve_split = true,
	},
	master = {
		mfact = 0.5,
	},
})
