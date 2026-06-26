/// @description Detect gamepad joins and keyboard start/cancel

if (keyboard_check_pressed(vk_return)) {
	if (array_length(global.active_player_ids) >= 2) {
		handle_start()
	}
}

if (keyboard_check_pressed(vk_escape)) {
	handle_cancel()
}

// Any face button on an unassigned gamepad claims the next open slot
for (var _d = 0; _d < 4; _d++) {
	if (!gamepad_is_connected(_d)) {
		continue
	}
	if (gamepad_button_check_pressed(_d, gp_face1)
	 || gamepad_button_check_pressed(_d, gp_face2)
	 || gamepad_button_check_pressed(_d, gp_face3)
	 || gamepad_button_check_pressed(_d, gp_face4)) {
		try_join_with_device(_d)
	}
}
