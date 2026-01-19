if (keyboard_check_pressed(vk_escape)) {
	if (!is_ulting() && !is_game_over) {
		toggle_pause()
		
		if (global.paused) {
			tutorial = instance_create_layer(x,y, LAYER_HUD, obj_tutorial_overlay)
		} else {
			instance_destroy(tutorial)
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