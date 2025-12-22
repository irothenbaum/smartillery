range = ult_collateral_get_radius(level)
ultimate_initialize(self, ULTIMATE_COLLATERAL)
proximity_map = {}
recently_struck_enemies = []

proximity_beam_width = 2

function order_enemy_keys(_enemy1, _enemy2) {
	var _low = min(_enemy1.id, _enemy2.id)
	var _high = max(_enemy1.id, _enemy2.id)
	
	return [string(real(_low)), string(real(_high)), _low, _high]
}

function pair_enemies(_enemy1, _enemy2) {
	var _order = order_enemy_keys(_enemy1, _enemy2)
	var _key_1 = _order[0]
	var _key_2 = _order[1]
	var _inst_1 = _order[2]
	var _inst_2 = _order[3]
	
	if (!struct_exists(proximity_map, _key_1)) {
		proximity_map[$ _key_1] = {}
	}
	
	if (!struct_exists(proximity_map[$ _key_1], _key_2)) {
		// must be a new pair
		proximity_map[$ _key_1][$ _key_2] = instance_create_layer(_inst_1.x, _inst_1.y, LAYER_BG_EFFECTS, obj_electric_beam, {
			source: _inst_1,
			target: _inst_2,
			color: c_white,
			width: proximity_beam_width,
			persist: true
		})
	}
}

function unpair_enemies(_enemy1, _enemy2) {
	var _order = order_enemy_keys(_enemy1, _enemy2)
	var _key_1 = _order[0]
	var _key_2 = _order[1]
	
	if (!variable_struct_exists(proximity_map, _key_1) || !struct_exists(proximity_map[$ _key_1], _key_2)) {
		// already unpaired
		return
	}

	instance_destroy(proximity_map[$ _key_1][$ _key_2])
	struct_remove(proximity_map[$ _key_1], _key_2)
	
}

function cleanup_paired_enemies() {
	var _keys = variable_struct_get_names(proximity_map)
	var _count = array_length(_keys)
	for (var _i = 0; _i < _count; _i++) {
		var _enemy_1 = real(_keys[_i])
		
		var _pairs = proximity_map[$ _enemy_1]
		var _keys_2 = variable_struct_get_names(_pairs)
		var _count_2 = array_length(_keys_2)
		for (var _j = 0; _j < _count_2; _j++) {	
			var _enemy_2 = real(_keys_2[_j])
			if (!instance_exists(_enemy_1) || !instance_exists(_enemy_2)) {
				instance_destroy(proximity_map[$ _enemy_1][$ _enemy_2])
				struct_remove(proximity_map[$ _enemy_1], _enemy_2)
			}
		}
		
		var _keys_2_after = variable_struct_get_names(_pairs)
		if (array_length(_keys_2_after) == 0) {
			struct_remove(proximity_map, _enemy_1)
		}
	}
}

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
	
	instance_create_layer(_target.x, _target.y, LAYER_FG_EFFECTS, obj_ult_collateral_explosion)
	
	// TODO: rather than find the nearby enemies again, lets just reference the proximity map to see who should be hit
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
		
		instance_create_layer(_origin.x, _origin.y, LAYER_BG_EFFECTS, obj_electric_beam, {
			target: _enemy,
			width: global.beam_width,
			color: _c
		})
		 
		_enemy.last_hit_by_player_id = _player_who_shot_id
		_enemy.register_hit()
		broadcast(EVENT_ENEMY_HIT, _enemy, _player_who_shot_id)
	}))
}))