if (image_alpha < 1) {
	image_alpha += (1 - image_alpha) * 0.05;
}

if (strobing) {
	strobe_timer -= step_seconds()
	if (strobe_timer <= 0) {
		strobe_inverted = !strobe_inverted
		strobe_timer += strobe_interval
	}
	// we're on our way out -- don't take more clicks
	return
}

// bounds come from Draw GUI, so test against the GUI mouse (mouse_x/y are room coordinates, which the zoomed menu camera skews)
if mouse_check_button_pressed(mb_left) {
	if (is_spot_in_bounds(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), bounds)) {
		activate()
	}
}
