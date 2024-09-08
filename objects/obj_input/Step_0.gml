var _game_controller = get_game_controller()

if (global.paused && !_game_controller.is_ulting()) {
	// can't change message while paused
	keyboard_string = message
	return
}

if(keyboard_check_pressed(vk_enter)) {
	if (string_length(message) > 0) {
		_game_controller.handle_submit_code(message)
	}
	keyboard_string = "";
} else {
	keyboard_string = string_copy(keyboard_string, 0, 20);
	message = keyboard_string
}

var _target_streak_ratio = min(get_game_controller().streak / global.point_streak_requirement, 1)
var _dif = _target_streak_ratio - streak_ratio
if (abs(_dif) > 0.001) {
	streak_ratio += _dif * 0.1
} else {
	streak_ratio = _target_streak_ratio
}