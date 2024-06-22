debug("ULTIMATE!");
number_of_strikes = 0
strikes_launched = 0
alarm[1] = 3 * game_get_speed(gamespeed_fps)

function execute(_num_strikes) {
	number_of_strikes = _num_strikes
	
	// TODO: run fyover animation
	
	// wait one second, then start bombing
	alarm[0] = 1 * game_get_speed(gamespeed_fps)
}

function strike_nearest_enemy() {
	strikes_launched++
	debug("Launching strike", strikes_launched)

	var _enemies = get_all_enemy_instances()
	var _enemy_count = array_length(_enemies)
	
	debug("Found enemies", _enemy_count)
	
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
	}
}