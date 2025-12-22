staged_selection = undefined
hovered_selection = undefined
x = global.xcenter
y = global.ycenter

hovered_scale = 0.20
default_scale = 0.12

square_size = 240

icon_space = 300

drawn_icon_scales = {
	ULTIMATE_STRIKE: default_scale,
	ULTIMATE_SLOW: default_scale,
	ULTIMATE_HEAL: default_scale,
	ULTIMATE_ASSIST: default_scale,
	ULTIMATE_COLLATERAL: default_scale,
	ULTIMATE_TURRET: default_scale,
}

drawn_icon_opacity = {
	ULTIMATE_STRIKE: 0,
	ULTIMATE_SLOW: 0,
	ULTIMATE_HEAL: 0,
	ULTIMATE_ASSIST: 0,
	ULTIMATE_COLLATERAL: 0,
	ULTIMATE_TURRET: 0,
}

function handle_select(_ult) {
	if (staged_selection == _ult and global.is_solo) {
		handle_start_game()
		return
	}
	
	staged_selection = _ult
	global.selected_ultimate[$ get_my_steam_id_safe()] = _ult
	broadcast(EVENT_SELECT_ULTIMATE, _ult, get_my_steam_id_safe())
}

function handle_start_game() {
	if (global.is_coop) {
		room_goto(rm_play_coop)
	} else {
		room_goto(rm_play_solo)
	}
}