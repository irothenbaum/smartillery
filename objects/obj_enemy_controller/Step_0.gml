if (spawned_count < enemy_count) {
	var _enemy1_count = instance_number(obj_enemy_1)
	
	if (_enemy1_count < wave_number) {
		// TODO: should space them out somehow
		spawn_enemy()
	}
}

