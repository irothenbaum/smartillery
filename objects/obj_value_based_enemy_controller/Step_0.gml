if (global.paused) {
	return
}

if (spawned_count < enemy_count) {
	// the time slow ultimate also slows how quickly the enemy value reservoir refills
	var _slow_multiplier = 1
	with (obj_ultimate_slow) {
		_slow_multiplier = min(_slow_multiplier, slow_multiplier)
	}

	// reduce our value by value_per_second
	current_value = max(0, current_value - (value_per_second * _slow_multiplier * delta_time_seconds()))
} else if (count_all_enemies() == 0) {
	get_game_controller().mark_wave_completed()
}
