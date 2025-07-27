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
	ULTIMATE_ASSIST: default_scale,
	ULTIMATE_COLLATERAL: default_scale,
	ULTIMATE_SIMPLIFY: default_scale,
}

drawn_icon_opacity = {
	ULTIMATE_STRIKE: 0,
	ULTIMATE_SLOW: 0,
	ULTIMATE_HEAL: 0,
	ULTIMATE_ASSIST: 0,
	ULTIMATE_COLLATERAL: 0,
	ULTIMATE_SIMPLIFY: 0,
}

function handle_select(_ult) {
	global.selected_ultimate[$ owner_player_id] = _ult
	broadcast(EVENT_SELECT_ULTIMATE, _ult, owner_player_id)
	instance_destroy()
}