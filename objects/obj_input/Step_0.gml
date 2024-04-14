if (global.paused && !get_game_controller().is_ulting()) {
	// can't change message while paused
	keyboard_string = message
	return
}
if(keyboard_check_pressed(vk_enter)) {
	get_enemy_controller().handle_submit_answer(message)
	keyboard_string = "";
} else {
	message = keyboard_string;
}