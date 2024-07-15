if(keyboard_check_pressed(vk_enter)) {
	keyboard_string = "";
	
	if (!select_button_by_label()) {
		instance_create_layer(x, y - 200, LAYER_INSTANCES, obj_text_title, {
			message: "Enter a menu item to select it",
			duration: 5,
			align: ALIGN_CENTER
		})	
	}
} else {
	message = string_lower(keyboard_string);
	/*
	Disabling auto submit for now
	if (get_enemy_controller().is_answer_active(message)) {
		get_enemy_controller().handle_submit_answer(message)	
		keyboard_string = "";
	}
	*/
}