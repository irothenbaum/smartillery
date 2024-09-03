number_of_strikes = 2 + level
strikes_launched = 0
// wait one second, then strike
alarm[0] = game_get_speed(gamespeed_fps)
toggle_pause(true)

function strike_nearest_enemy() {
	strikes_launched++

	var _enemies = get_all_enemy_instances()
	var _enemy_count = array_length(_enemies)
	
	if (_enemy_count == 0) {
		debug("No more enemies, ending ultimate early")
		return
	}
	
	var _player = get_player()
	var _target = _enemies[0]
	var _target_distance = point_distance(_target.x, _target.y, _player.x, _player.y)
	for (var _i = 1; _i < _enemy_count; _i++) {
		var _this_enemy = _enemies[_i]
		var _this_distance = point_distance(_this_enemy.x, _this_enemy.y, _player.x, _player.y)
		
		if (_this_distance < _target_distance) {
			_target = _this_enemy
			_target_distance = _this_distance
		}
	}
	
	instance_create_layer(_target.x, _target.y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_ultimate_strike})
	with(_target) {
		register_hit(true)
	}

	if (strikes_launched < number_of_strikes) {
		// if we have more to launch, reset the alarm
		alarm[0] = 0.2 * game_get_speed(gamespeed_fps)
	} else {
		alarm[1] =game_get_speed(gamespeed_fps)
	}
}