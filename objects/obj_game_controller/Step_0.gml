if (!variable_global_exists("boot_steps")) { global.boot_steps = 0 } if (global.boot_steps < 5) { global.boot_steps++; var _boot_msg = "BOOT 7: controller step " + string(global.boot_steps); show_debug_message(_boot_msg); var _boot_f = file_text_open_append("boot_log.txt"); file_text_write_string(_boot_f, _boot_msg); file_text_writeln(_boot_f); file_text_close(_boot_f) } // BOOT-DEBUG
if (keyboard_check_pressed(vk_escape)) {
	// no pausing/unpausing during a room fade (e.g. after Quit, which leaves the game paused while it fades out)
	if (instance_number(obj_ultimate_strike) == 0 && !is_game_over && !instance_exists(obj_room_transition)) {
		if (global.paused) {
			resume_game()
		} else {
			pause_game()
		}
	} else {
		debug("Cannot pause during ult or selection or game over")
	}
}

if (room == rm_test) {
	// only hold still the enemies placed by configure_test_room -- ones spawned via test words (e.g. "_e") move normally
	with (obj_enemy_parent) {
		if (frozen) {
			speed = 0
		}
	}
}

if (!global.paused) {
	advance_play_time()

	// assign power items / extra ultimates their evenly spaced orbit slots (they move themselves in orbiter_step)
	update_orbit_formation()
	
	// increase ult charge for each player
	for_each_player(method(self, function(_player_id) {
		// we only increase charge if the player is actively ulting
		if (is_ulting(_player_id)) {
			return
		}
		ultimate_charge[$ _player_id] = min(global.ultimate_requirement, ultimate_charge[$ _player_id] + step_seconds())
	}))
}