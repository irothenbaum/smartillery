range = ult_collateral_get_radius(level)
ultimate_initialize(self, ULTIMATE_COLLATERAL)

recently_struck_enemies = []

subscribe(self, EVENT_ENEMY_HIT, method(self, function(_target, _player_who_shot_id) {
	debug("Reveived HIT on ", _target)
	debug("_recently_struck_enemies length is", array_length(recently_struck_enemies))
	// wait 1/10th of a second before resetting recently_struck_enemies
	alarm[1] = 0.1 * game_get_speed(gamespeed_fps)
	if (array_contains(recently_struck_enemies, _target)) {
		// already struck this one recently, ignore
		debug("already struck this one recently, ignore", _target)
		return
	}
	
	var _on_streak = get_game_controller().has_point_streak(_player_who_shot_id)
	var _color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_COLLATERAL]
	
	instance_create_layer(_target.x, _target.y, LAYER_INSTANCES, obj_ult_collateral_explosion)
	var _nearby_enemies = find_enemies_near_point(_target.x, _target.y, range)
	
	debug("Found _nearby_enemies", array_length(_nearby_enemies))
	
	// add all nearby enemies to our list of recently struck (so we can ignore them) if they still exist
	_nearby_enemies = array_filter(_nearby_enemies, method({_target: _target, _recently_struck_enemies: recently_struck_enemies}, function(_e) {
		if (instance_exists(_e)) {
			array_push(_recently_struck_enemies, _e)
			
			// this basically removes the initial target from the list
			return _e.id != _target.id
		}
		return false
	}))
	
	debug("Final _nearby_enemies", array_length(_nearby_enemies))
	
	// we now strike all nearby enemies
	array_foreach(_nearby_enemies, method({_origin: _target, _c: _color, _player_who_shot_id: _player_who_shot_id}, function(_enemy) {
		debug("Striking nearby enemy", _enemy)
		
		instance_create_layer(_origin.x, _origin.y, LAYER_INSTANCES, obj_electric_beam, {
			target_x: _enemy.x,
			target_y: _enemy.y,
			width: global.beam_width,
			color: _c
		})
		 
		_enemy.last_hit_by_player_id = _player_who_shot_id
		_enemy.register_hit()
		broadcast(EVENT_ENEMY_HIT, _enemy, _player_who_shot_id)
	}))
}))