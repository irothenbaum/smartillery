if (global.paused) {
	return
}

if (spawned_count < enemy_count) {
	if (can_spawn && instance_number(obj_enemy_parent) < get_current_wave_number()) {
		spawn_enemy()
	}
} else if (instance_number(obj_enemy_parent) == 0) {
	game_controller.mark_wave_completed()
}
