if (keyboard_check_pressed(vk_escape)) {
	if (instance_number(obj_ultimate_strike) == 0 && !is_game_over) {
		toggle_pause()
		
		if (global.paused) {
			pause_overlay = instance_create_layer(x,y, LAYER_HUD, obj_pause_overlay)
		} else {
			instance_destroy(pause_overlay)
		}
	} else {
		debug("Cannot pause during ult or selection or game over")
	}
}

if (!global.paused) {
	// increase ult charge for each player
	for_each_player(method(self, function(_player_id) {
		// we only increase charge if the player is actively ulting
		if (is_ulting(_player_id)) {
			return
		}
		ultimate_charge[$ _player_id] = min(global.ultimate_requirement, ultimate_charge[$ _player_id] + delta_time_seconds())
	}))
}