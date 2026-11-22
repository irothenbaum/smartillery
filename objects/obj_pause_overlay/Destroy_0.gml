/// @description Remove the Resume / Quit buttons and the menu input
for (var _i = 0; _i < array_length(buttons); _i++) {
	if (instance_exists(buttons[_i])) {
		instance_destroy(buttons[_i])
	}
}

if (instance_exists(menu_input)) {
	if (instance_exists(menu_input.hint)) {
		instance_destroy(menu_input.hint)
	}
	instance_destroy(menu_input)
}

// hand the keyboard back to the game. Clear key states first so the Enter that typed "resume" isn't also seen by
// the game input as a submit this frame, then restore its in-progress guess
io_clear()
keyboard_string = saved_keyboard_string
global.focused_input = saved_focused_input
global.default_focused_input = saved_default_focused_input
