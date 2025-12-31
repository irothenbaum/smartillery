if (global.paused) {
	return
}

if (spawned_count < enemy_count) {
	// reduce our value by value_per_second
	current_value = max(0, current_value - (value_per_second * delta_time_seconds()))
	attempt_spawn()
} else if (count_all_enemies() == 0) {
	get_game_controller().mark_wave_completed()
}
