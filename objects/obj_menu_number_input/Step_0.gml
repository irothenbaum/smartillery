if (global.focused_input == self) {
	if(keyboard_check_pressed(vk_escape)) {
		global.focused_input = global.default_focused_input
		keyboard_string = "";
	} else if(global.focused_input == self) {
		try {
			// keyboard_string can hold no digits at all (e.g. only letters were typed), and string_digits then
			// returns "", which on_change can't convert to a number, so only act once there's a digit to use
			var _digits = string_digits(keyboard_string)
			if (string_length(_digits) > 0) {
				cached_value = _digits
				if (real(cached_value) != get_value()) {
					on_change(cached_value)
				}
			}
		} catch(_e) {
			debug("Invalid seed, ignoring", _e)
		}
	}
}

// bounds come from Draw GUI, so test against the GUI mouse (mouse_x/y are room coordinates, which the zoomed menu camera skews)
if mouse_check_button_pressed(mb_left) {
	if (is_spot_in_bounds(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), bounds)) {
		global.focused_input = self
	}
}