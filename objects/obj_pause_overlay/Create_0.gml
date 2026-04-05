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