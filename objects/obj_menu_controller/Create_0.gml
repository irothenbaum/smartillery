x = global.xcenter
y = global.ycenter

// Menu controller should always reset the game state on start
reset_game_state()

function start_game() {
	room_goto(rm_play_solo)
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


instance_create_layer(x, y - 80, LAYER_INSTANCES, obj_menu_toggle, {label: "Mode", get_value: function() {return (global.is_math_mode ? "MATH" : "TYPING")}, on_click: change_game_mode, is_selected: is_math})
instance_create_layer(x, y, LAYER_INSTANCES, obj_menu_number_input, {get_value: function() { return global.game_seed}, label: "Seed", on_change: function(_v) {
	global.game_seed = real(_v)
}})
instance_create_layer(x, y + 80, LAYER_INSTANCES, obj_menu_button, {label: "Play", on_click: start_game})