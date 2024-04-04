if (can_spawn) {
	if (spawned_count < enemy_count) {
		var _enemy1_count = instance_number(obj_enemy_1)
	
		if (_enemy1_count < wave_number) {
			// TODO: should space them out somehow
			spawn_enemy()
		}
	} else if (count_all_enemies() <= 0 and !alarm[1]) {
		alarm[1] = MESSAGE_SHOW_DURATION * game_get_speed(gamespeed_fps)
	}
}
