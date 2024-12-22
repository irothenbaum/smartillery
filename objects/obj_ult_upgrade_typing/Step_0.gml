/// @description Listen for keyboard

if (keyboard_check_pressed(vk_anykey)) {
	if (string_length(keyboard_string) == total_letters) {
		check_solution(build_solution_from_keyboard_input(keyboard_string, blocks))
		keyboard_string = ""
	}
}