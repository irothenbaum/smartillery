if (global.paused) {
	return
}

if (spawned_count < enemy_count) {
	if (can_spawn && count_all_enemies() < get_current_wave_number()) {
		spawn_enemy()
	}
} else if (count_all_enemies() == 0) {
	get_game_controller().mark_wave_completed()
}
