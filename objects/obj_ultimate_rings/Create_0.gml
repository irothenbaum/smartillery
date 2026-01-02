ring_range = ult_rings_get_ring_range(level)
ultimate_initialize(self, ULTIMATE_RINGS)
recently_struck_enemies = []
recently_struck_rings = array_create(global.bg_number_of_circles, 0)

function find_enemies_on_rings(_target_ring, _ring_range) {
	var _min_ring = max(0, _target_ring - _ring_range[0])
	var _max_ring = _target_ring + _ring_range[1]

	debug("Finding enemies on rings", _min_ring, "to", _max_ring)

	var _enemies_on_rings = []
	for_each_enemy(function(_e, _index, _min_ring, _max_ring, _enemies_on_rings) {
		if (!instance_exists(_e)) {
			return;
		}

		var _distance_to_center = point_distance(_e.x, _e.y, global.xcenter, global.ycenter)
		var _enemy_ring = get_ring_from_distance(_distance_to_center)

		if (_enemy_ring >= _min_ring && _enemy_ring <= _max_ring) {
			array_push(_enemies_on_rings, _e)
		}
	}, _min_ring, _max_ring, _enemies_on_rings)

	return _enemies_on_rings
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
	var _color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_RINGS]

	instance_create_layer(_target.x, _target.y, LAYER_FG_EFFECTS, obj_ult_collateral_explosion)

	// Calculate which ring the target is on
	var _distance_to_center = point_distance(_target.x, _target.y, global.xcenter, global.ycenter)
	var _target_ring = get_ring_from_distance(_distance_to_center)

	debug("Target is on ring", _target_ring)

	// Find all enemies on adjacent rings based on level
	var _nearby_enemies = find_enemies_on_rings(_target_ring, ring_range)

	// Mark all affected rings as recently struck
	var _min_ring = max(0, _target_ring - ring_range[0])
	var _max_ring = min(global.bg_number_of_circles - 1, _target_ring + ring_range[1])
	for (var _r = _min_ring; _r <= _max_ring; _r++) {
		recently_struck_rings[_r] = 1
	}

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