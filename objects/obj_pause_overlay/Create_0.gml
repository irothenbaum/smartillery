/// @description Store references to postitions
hud = instance_find(obj_hud, 0)
player = get_player()
game_controller = get_game_controller()
tip_copy = undefined
fade_duration = 1 * game_get_speed(gamespeed_fps)

/**
 * @param {Id.Instance} _i
 */
function set_hovered_instance(_i) {
	debug("SETTING HOVERED", _i)
	if (is_undefined(_i)) {
		tip_copy = undefined
		return
	}

	var _tip_copy_entry = ds_map_find_value(global.tip_copy_map, _i.object_index)
	if (is_undefined(_tip_copy_entry)) {
		debug("Object missing tool tip:", _i.object_index)
		return
	}

	// Support callback functions that generate tip copy dynamically
	if (is_method(_tip_copy_entry)) {
		tip_copy = _tip_copy_entry(_i)
	} else {
		tip_copy = _tip_copy_entry
	}

	tip_copy.position = {x: _i.x, y: _i.y}
	alarm[0] = fade_duration
}

// Resume / Quit, side by side near the bottom (the tip box uses the middle of the screen), both the same width.
// In training they go in the middle instead (see _button_y).
// One depth above the overlay so they draw over its dimming. Destroyed with the overlay (see Destroy)
var _button_width = get_menu_box_group_width(["Resume", "Quit"])
var _button_offset = (_button_width / 2) + global.margin_lg
// training puts the player's input box at 85% height (see obj_training_controller), so use the middle there instead
var _button_y = room == rm_play_training ? global.ycenter : global.room_height * 0.85
var _button_params = {min_box_width: _button_width, image_alpha: 0}
buttons = [
	instance_create_depth(global.xcenter - _button_offset, _button_y, depth - 1, obj_menu_button, merge_structs(_button_params, {
		label: "Resume",
		on_click: function() {
			get_game_controller().resume_game()
		},
	})),
	instance_create_depth(global.xcenter + _button_offset, _button_y, depth - 1, obj_menu_button, merge_structs(_button_params, {
		label: "Quit",
		on_click: function() {
			get_game_controller().quit_to_menu()
		},
	})),
]
