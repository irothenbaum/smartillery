if (!is_focused) {
	return
}

var _next_selected = selected_color

if(keyboard_check_pressed(vk_left)) {
	_next_selected -= 1
} else if (keyboard_check_pressed(vk_right)) {
	_next_selected += 1
}

_next_selected = (_next_selected + color_count) % color_count

if mouse_check_button_pressed(mb_left) {
    if (is_spot_in_bounds(mouse_x, mouse_y, bounds)) {
		_next_selected = floor((mouse_x - x) / (box_size + margin))
	}
}

if (_next_selected != selected_color) {
	selected_color = _next_selected
	if (typeof(on_select) == "method") {
		on_select(colors[selected_color])
	}
}
