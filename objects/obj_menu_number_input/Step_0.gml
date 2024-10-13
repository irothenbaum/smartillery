if (global.focused_input == self) {
	if(keyboard_check_pressed(vk_escape)) {
		global.focused_input = global.default_focused_input
		keyboard_string = "";
	} else {
		try {
			cached_value = string_digits(keyboard_string)
			if (cached_value != get_value()) {
				on_change(cached_value)
			}
		} catch(_e) {
			debug("Invalid seed, ignoring")
		}
	}
}

if mouse_check_button_pressed(mb_left) {
	if (is_spot_in_bounds(mouse_x, mouse_y, bounds)) {
		global.focused_input = self
	}
}