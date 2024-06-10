if (keyboard_check_pressed(vk_escape)) {
	var _input = get_input()
	with (_input) {
		if (string_length(keyboard_string) > 0) {
		keyboard_string = ""
		} else if (!other.is_ulting()) {
			toggle_pause()
		} else {
			debug("Cannot pause during ult")
		}
	}
}