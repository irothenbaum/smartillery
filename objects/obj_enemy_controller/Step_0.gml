if (spawned_count < enemy_count) {
	if (can_spawn) {
		var _enemy1_count = instance_number(obj_enemy_1)
	
		if (_enemy1_count < get_current_wave_number()) {
			spawn_enemy()
		}
	}
} else if (count_all_enemies() == 0 and !alarm[1]) {
	alarm[1] = 4 * game_get_speed(gamespeed_fps)
}
