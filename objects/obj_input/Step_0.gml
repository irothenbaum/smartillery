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

	// if we were shaking, but the user started typing again, then stop shaking
	if (!is_undefined(shake_start) && string_length(message) > 0) {
		alarm[0] = 1
	}
}

streak_ratio = min(get_game_controller().streak / global.point_streak_requirement, 1)

// if we're shaking
if (!is_undefined(shake_start)) {
	var _play_time = get_play_time()
	// change our x position based on where we are with the shake
	x = initial_x + (sin(total_shakes * TAU * (_play_time - shake_start) / total_shake_time) * shake_magnitude)
	// when we're shaking we handle the "lerp" ourselves with the sine equation
	render_x = x
}

// update our render_x in case we were shaking (modifying x)
render_x = lerp(render_x, x, global.fade_speed)