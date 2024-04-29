if mouse_check_button_pressed(mb_left) {
    if (bounds.x0 < mouse_x and bounds.x1 > mouse_x and bounds.y0 < mouse_y and bounds.y1 > mouse_y) {
		on_click(self)
	}
}