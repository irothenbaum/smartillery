// Menu controller should always reset the game state on start
reset_game_state()

// the room's backdrop follows the game mode's colors (and changes with it, see set_game_mode)
apply_bg_color_to_room()

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
	// training skips the select-ultimate screen, so clear out whatever was picked last game -- with nothing set,
	// get_player_ultimate falls back to the default
	global.selected_ultimate = {}
	transition_to_room(rm_play_training)
}

function quit_game() {
	// don't close out from under a room fade that's already started (e.g. Play was just chosen)
	if (is_room_transitioning()) {
		return
	}
	game_end()
}

function get_game_mode_name() {
	return global.is_math_mode ? "MATH" : "TYPING"
}

function toggle_game_mode() {
	set_game_mode(!global.is_math_mode)
}

// Layout (GUI coordinates, which match the room's): the item stack sits in the bottom-left corner, its left and
// bottom edges margin_xxl from the screen's; Quit sits alone in the bottom-right corner, the same margin_xxl from
// the bottom and right. The player is up in the top-right (see set_menu_viewport_dimensions)
var _margin = global.margin_xxl
var _item_spacing = 80 // px between item centers

// every item is as wide as the seed input (sized for a 10-digit seed, the most randomize() gives), and they
// line up on their left edges
var _item_width = get_menu_box_group_width(["Seed: 0000000000", "Seed: " + global.game_seed_text, "Train", "Play", "CoOp", "Mode: MATH", "Mode: TYPING"])
var _item_x = _margin
// the bottom item (Mode) sits margin_xxl up from the bottom; the rest stack above it
var _bottom_y = global.room_height - _margin - get_menu_box_size("Mode: MATH", _item_width).below
var _item_params = {align: ALIGN_LEFT, min_box_width: _item_width}

instance_create_layer(_item_x, _bottom_y - _item_spacing * 4, LAYER_INSTANCES, obj_menu_number_input, merge_structs(_item_params, {get_value: function() { return global.game_seed_text }, label: "Seed", on_change: function(_v) {
	// any letters/digits -- empty re-randomizes (see set_game_seed)
	set_game_seed(_v)
}}))

instance_create_layer(_item_x, _bottom_y - _item_spacing * 3, LAYER_INSTANCES, obj_menu_button, merge_structs(_item_params, {label: "Train", on_click: start_training}))

instance_create_layer(_item_x, _bottom_y - _item_spacing * 2, LAYER_INSTANCES, obj_menu_button, merge_structs(_item_params, {label: "Play", on_click: start_game}))

instance_create_layer(_item_x, _bottom_y - _item_spacing, LAYER_INSTANCES, obj_menu_button, merge_structs(_item_params, {label: "CoOp", on_click: start_coop}))

// type "mode" (or click it) to flip between Math and Typing
instance_create_layer(_item_x, _bottom_y, LAYER_INSTANCES, obj_menu_toggle, merge_structs(_item_params, {
	label: "Mode",
	get_value: get_game_mode_name,
	is_selected: function() { return false }, // a two-way switch, not an on/off -- never drawn filled
	on_click: toggle_game_mode,
}))

// Quit, alone in the bottom-right corner, sized to its own label
var _quit_size = get_menu_box_size("Quit", 0)
instance_create_layer(global.room_width - _margin - _quit_size.width, global.room_height - _margin - _quit_size.below, LAYER_INSTANCES, obj_menu_button, {
	label: "Quit",
	align: ALIGN_LEFT, // x is the box's left edge, worked out from its width so its right edge lands on the margin
	min_box_width: 0,
	on_click: quit_game,
})
