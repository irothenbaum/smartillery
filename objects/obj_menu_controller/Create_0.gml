x = global.x_center
y = global.y_center

function start_game() {
	room_goto(rm_waves)
}

function change_game_mode(_t) {
	global.is_math_mode = !global.is_math_mode
	with(_t) {
		message = "Mode: " + (global.is_math_mode ? "MATH" : "TYPING")
	}
}

function is_math() {
	return global.is_math_mode
}


instance_create_layer(x, y - 80, LAYER_INSTANCES, obj_menu_toggle, {message: ("Mode: " + (global.is_math_mode ? "MATH" : "TYPING")), on_click: change_game_mode, is_selected: is_math})
instance_create_layer(x, y, LAYER_INSTANCES, obj_menu_button, {message: "Play", on_click: start_game})