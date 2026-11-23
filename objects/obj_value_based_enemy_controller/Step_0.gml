if (global.paused) {
	return
}

if (spawned_count < enemy_count) {
	// the time slow ultimate also slows how quickly the enemy value reservoir refills -- but only while there are
	// enemies on the map. With none left there's nothing to slow, so refill at the normal rate instead of leaving
	// the player waiting on an empty screen
	var _slow_multiplier = instance_number(obj_enemy_parent) > 0 ? get_active_slow_multiplier() : 1

	// reduce our value by value_per_second
	current_value = max(0, current_value - (value_per_second * _slow_multiplier * step_seconds()))
} else if (instance_number(obj_enemy_parent) == 0) {
	get_game_controller().mark_wave_completed()
}
