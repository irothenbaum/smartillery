// bounds come from Draw GUI, so test against the GUI mouse (mouse_x/y are room coordinates, which the zoomed menu camera skews)
var _clicked = mouse_check_button_pressed(mb_left)
var _clicked_inside = _clicked && is_spot_in_bounds(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), bounds)

if (!editing) {
	if (_clicked_inside) {
		begin_edit()
	}
	exit
}

// something else took the keyboard -- treat it as a blur
if (global.focused_input != self) {
	commit_edit()
	exit
}

// letters and digits only, lowercase (like the menu input), capped. Writing it back keeps keyboard_string in sync
// so dropped characters stay dropped and backspace works
draft = string_copy(string_lower(string_lettersdigits(keyboard_string)), 1, max_chars)
keyboard_string = draft
caret_timer += step_seconds()

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape) || (_clicked && !_clicked_inside)) {
	commit_edit()
}
