/// @description Remove the Resume / Quit buttons
for (var _i = 0; _i < array_length(buttons); _i++) {
	if (instance_exists(buttons[_i])) {
		instance_destroy(buttons[_i])
	}
}
