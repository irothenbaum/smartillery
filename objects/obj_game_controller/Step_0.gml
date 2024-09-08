if (keyboard_check_pressed(vk_escape)) {
	if (!is_ulting() && !is_selecting_ult) {
		toggle_pause()
	} else {
		debug("Cannot pause during ult or selection")
	}
}
