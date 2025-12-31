if (global.paused) {
	return
}

if (spawned_count < enemy_count) {
	// TODO: maybe this shouldn't be in here???
	current_value = max(0, current_value - 1)
	attempt_spawn()
} else if (count_all_enemies() == 0) {
	game_controller.mark_wave_completed()
}
