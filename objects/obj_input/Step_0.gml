var _game_controller = get_game_controller()

if (is_controlled) {
	if (global.paused) {
		keyboard_string = message
		return
	}

	if (device_index >= 0) {
		// ── Gamepad input ──────────────────────────────────────────────
		var _submit  = gamepad_button_check_pressed(device_index, gp_face1)
		var _pad_up  = gamepad_button_check_pressed(device_index, gp_padu)
		var _pad_dn  = gamepad_button_check_pressed(device_index, gp_padd)
		var _pad_lt  = gamepad_button_check_pressed(device_index, gp_padl)
		var _pad_rt  = gamepad_button_check_pressed(device_index, gp_padr)

		if (_submit && string_length(message) > 0) {
			_game_controller.handle_submit_code(message, owner_player_id)
			last_guess = message
			guess_numeric = 0
			message = ""
		} else if (_pad_up) {
			guess_numeric = 0
			message = string(guess_numeric)
		} else if (_pad_dn) {
			guess_numeric += 4
			message = string(guess_numeric)
		} else if (_pad_lt) {
			guess_numeric += 1
			message = string(guess_numeric)
		} else if (_pad_rt) {
			guess_numeric += 10
			message = string(guess_numeric)
		}

	} else {
		// ── Keyboard input ─────────────────────────────────────────────
		if (keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space)) {
			if (string_length(message) > 0) {
				_game_controller.handle_submit_code(message, owner_player_id)
				last_guess = message
				guess_numeric = 0
			}
			keyboard_string = "";
		} else if (keyboard_check_pressed(vk_up)) {
			guess_numeric = 0
			message = string(guess_numeric)
			keyboard_string = string(guess_numeric)
		} else if (keyboard_check_pressed(vk_down)) {
			guess_numeric += 4
			message = string(guess_numeric)
			keyboard_string = string(guess_numeric)
		} else if (keyboard_check_pressed(vk_left)) {
			guess_numeric += 1
			message = string(guess_numeric)
			keyboard_string = string(guess_numeric)
		} else if (keyboard_check_pressed(vk_right)) {
			guess_numeric += 10
			message = string(guess_numeric)
			keyboard_string = string(guess_numeric)
		} else {
			keyboard_string = string_copy(keyboard_string, 0, global.is_math_mode ? 4 : global.max_word_length + 1);

			if (keyboard_string != message) {
				message = keyboard_string
			}

			if (!is_undefined(shake_start) && string_length(message) > 0) {
				alarm[0] = 1
			}
		}
	}
}

streak_ratio = min(get_game_controller().streak[$ owner_player_id] / global.point_streak_requirement, 1)

if (!is_undefined(shake_start)) {
	var _play_time = get_play_time()
	x = initial_x + (sin(total_shakes * TAU * (_play_time - shake_start) / total_shake_time) * shake_magnitude)
	render_x = x
}

render_x = lerp(render_x, x, global.fade_speed)

if (!is_undefined(streak_fire)) {
	size_streak_fire()
}
