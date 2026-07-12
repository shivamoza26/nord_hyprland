hl.config({

	general = {
		gaps_in = 3,
		gaps_out = 10,
		border_size = 1,
		["col.active_border"] = "rgba(8fbcbbff)",
		["col.inactive_border"] = "rgba(2e3440ff)",
		resize_on_border = true,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		active_opacity = 0.85,
		inactive_opacity = 0.70,
		fullscreen_opacity = 0.85,

		blur = {
			enabled = true,
			size = 5,
			passes = 1,
			new_optimizations = true,
			xray = true,
			noise = 0.1125,
			contrast = 1.2,
			vibrancy = 0.1696,
			brightness = 0.5,
		},

		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			color = "rgba(00000055)",
		},
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
		disable_splash_rendering = false,
	},

	animations = {
		enabled = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})
