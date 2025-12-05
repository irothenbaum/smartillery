var _game_controller = get_game_controller()

if (is_controlled) {
	if (global.paused && !_game_controller.is_ulting()) {
		// can't change message while paused
		keyboard_string = message
		return
	}

	if(keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space)) {
		if (string_length(message) > 0) {
			_game_controller.handle_submit_code(message)
			broadcast(EVENT_INPUT_SUBMIT, message, owner_player_id)
			last_guess = message
			guess_numeric = 0
		}
		keyboard_string = "";
		broadcast(EVENT_INPUT_CHANGED, "")
	} else if(keyboard_check_pressed(vk_up)) {
		guess_numeric = 0
		message = string(guess_numeric)
		keyboard_string = string(guess_numeric)
	} else if(keyboard_check_pressed(vk_down)) {
		guess_numeric += 5
		message = string(guess_numeric)
		keyboard_string = string(guess_numeric)
	} else if(keyboard_check_pressed(vk_left)) {
		guess_numeric += 1
		message = string(guess_numeric)
		keyboard_string = string(guess_numeric)
	} else if(keyboard_check_pressed(vk_right)) {
		guess_numeric += 10
		message = string(guess_numeric)
		keyboard_string = string(guess_numeric)
	} else {
		keyboard_string = string_copy(keyboard_string, 0, global.is_math_mode ? 4 : global.max_word_length + 1);
	
		if (keyboard_string != message) {
			message = keyboard_string
			broadcast(EVENT_INPUT_CHANGED, message)
		}

		// if we were shaking, but the user started typing again, then stop shaking
		if (!is_undefined(shake_start) && string_length(message) > 0) {
			alarm[0] = 1
		}
	}
} else {
	// do nothing, our string is modified by events
}

streak_ratio = min(get_game_controller().streak[$ owner_player_id] / global.point_streak_requirement, 1)

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

if (!is_undefined(streak_fire)) {
	size_streak_fire()
}