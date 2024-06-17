if mouse_check_button_pressed(mb_left) {
	if (is_spot_in_bounds(mouse_x, mouse_y, bounds)) {
		on_click(self)
	}
}