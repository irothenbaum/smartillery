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
	// a room fade is already underway (e.g. a second click) -- don't change any state for a room we're not going to
	if (is_room_transitioning()) {
		return
	}
	global.is_solo = true
	global.is_coop = false
	global.active_player_ids = [0]
	global.player_device_map[$ 0] = -1
	transition_to_room(rm_select_ultimates)
}

function start_coop() {
	// a room fade is already underway (e.g. a second click) -- don't change any state for a room we're not going to
	if (is_room_transitioning()) {
		return
	}
	global.is_coop = true
	global.is_solo = false
	transition_to_room(rm_coop_setup)
}

function start_training() {
	// a room fade is already underway (e.g. a second click) -- don't change any state for a room we're not going to
	if (is_room_transitioning()) {
		return
	}
	global.is_solo = true
	global.is_coop = false
	global.active_player_ids = [0]
	global.player_device_map[$ 0] = -1
	transition_to_room(rm_play_training)
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

// every item is as wide as the seed input (sized for a 10-digit seed, the most randomize() gives), and they
// line up on their left edges
var _item_width = get_menu_box_group_width(["Seed: 0000000000", "Seed: " + string(global.game_seed), "Train", "Play", "CoOp"])
// nudged left of the quadrant's center
var _item_x = x - (_item_width / 2) - 60
var _item_params = {align: ALIGN_LEFT, min_box_width: _item_width}

instance_create_layer(_item_x, y - 80, LAYER_INSTANCES, obj_menu_number_input, merge_structs(_item_params, {get_value: function() { return global.game_seed}, label: "Seed", on_change: function(_v) {
	global.game_seed = real(_v)
}}))

instance_create_layer(_item_x, y, LAYER_INSTANCES, obj_menu_button, merge_structs(_item_params, {label: "Train", on_click: start_training}))

instance_create_layer(_item_x, y + 80, LAYER_INSTANCES, obj_menu_button, merge_structs(_item_params, {label: "Play", on_click: start_game}))

instance_create_layer(_item_x, y + 160, LAYER_INSTANCES, obj_menu_button, merge_structs(_item_params, {label: "CoOp", on_click: start_coop}))
