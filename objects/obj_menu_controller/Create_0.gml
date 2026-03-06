x = global.xcenter
y = global.ycenter

// Menu controller should always reset the game state on start
reset_game_state()

function start_game() {
	global.is_solo = true
	global.is_coop = false
	room_goto(rm_select_ultimates)
}

function start_coop() {
	global.is_coop = true
	global.is_solo = false
	room_goto(rm_coop_setup)
}

function start_training() {
	global.is_solo = true
	global.is_coop = false
	room_goto(rm_play_training)
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

instance_create_layer(x, y - 80, LAYER_INSTANCES, obj_menu_number_input, {get_value: function() { return global.game_seed}, label: "Seed", on_change: function(_v) {
	global.game_seed = real(_v)
}})

instance_create_layer(x, y, LAYER_INSTANCES, obj_menu_button, {label: "Train", on_click: start_training})

instance_create_layer(x, y + 80, LAYER_INSTANCES, obj_menu_button, {label: "Play", on_click: start_game})

instance_create_layer(x, y + 160, LAYER_INSTANCES, obj_menu_button, {label: "CoOp", on_click: start_coop})