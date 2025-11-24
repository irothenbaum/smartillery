number_of_strikes = ult_strike_get_count(level)
strikes_launched = 0
bombing_target = undefined
// wait 2 seconds, then strike
alarm[1] = 2 * game_get_speed(gamespeed_fps)
toggle_pause(true)

function strike_nearest_enemy() {
	strikes_launched++

	var _enemies = get_all_enemy_instances()
	var _enemy_count = array_length(_enemies)
	
	if (_enemy_count == 0) {
		debug("No more enemies, ending ultimate early")
		alarm[0] = 2 * game_get_speed(gamespeed_fps)
		return
	}
	
	var _target = _enemies[0]
	var _target_distance = point_distance(_target.x, _target.y, global.xcenter, global.ycenter)
	for (var _i = 1; _i < _enemy_count; _i++) {
		var _this_enemy = _enemies[_i]
		var _this_distance = point_distance(_this_enemy.x, _this_enemy.y, global.xcenter, global.ycenter)
		
		if (_this_distance < _target_distance) {
			_target = _this_enemy
			_target_distance = _this_distance
		}
	}
	
	bombing_target = _target
	var _targeting_effect = instance_create_layer(_target.x, _target.y, LAYER_INSTANCES, obj_ult_assist_target, {target: _target, color: c_white})
	alarm[2] = _targeting_effect.rotation_duration_ms * game_get_speed(gamespeed_fps) / 1000 
}

function render_bomb_lands() {
	// flash the screen
	instance_create_layer(x, y, LAYER_INSTANCES, obj_flash_screen, {duration: game_get_speed(gamespeed_fps) * 0.1})
	
	with(bombing_target) {
		last_hit_by_player_id = other.owner_player_id
		streak_ineligible = true
		register_hit(true)
		instance_create_layer(x, y, LAYER_INSTANCES, obj_ult_strike_explosion, {radius: 0})
	}

	if (strikes_launched < number_of_strikes) {
		// if we have more to launch, reset the alarm
		alarm[1] = random_range(0.2, 0.6) * game_get_speed(gamespeed_fps)
	} else {
		// wait 3 seconds then destroy self
		alarm[0] = 3 * game_get_speed(gamespeed_fps)
	}
	bombing_target = undefined
}

ultimate_initialize(self, ULTIMATE_STRIKE)