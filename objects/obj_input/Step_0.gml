if(keyboard_check_pressed(vk_enter)) {
	get_enemy_controller().handle_submit_answer(message)
	keyboard_string = "";
} else {
	message = keyboard_string;
}