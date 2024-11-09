toggle_pause(true)

staged_selection = undefined
x = global.xcenter
y = global.ycenter

hovered_scale = 0.18
default_scale = 0.12

square_size = 240

icon_space = 300

drawn_icon_scales = {
	ULTIMATE_STRIKE: default_scale,
	ULTIMATE_SLOW: default_scale,
	ULTIMATE_HEAL: default_scale,
}

drawn_icon_opacity = {
	ULTIMATE_STRIKE: 0,
	ULTIMATE_SLOW: 0,
	ULTIMATE_HEAL: 0,
}

function handle_select(_ult) {
	global.selected_ultimate = _ult
	instance_destroy()
}