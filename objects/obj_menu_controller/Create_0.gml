// the menu sits in the lower-left quadrant, over the darkest part of obj_menu_scene's dim
// (the player is up in the top-right, see set_menu_viewport_dimensions). The items below span y-80 to y+160,
// so shift up by 40 to center them on the quadrant
x = global.room_width * 0.25
y = global.room_height * 0.75 - 40

// Menu controller should always reset the game state on start
reset_game_state()

// the live background scene (must come after reset_game_state)
instance_create_layer(0, 0, LAYER_INSTANCES, obj_menu_scene)

function start_game() {
	global.is_solo = true
	global.is_coop = false
	global.active_player_ids = [0]
	global.player_device_map[$ 0] = -1
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
	global.active_player_ids = [0]
	global.player_device_map[$ 0] = -1
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