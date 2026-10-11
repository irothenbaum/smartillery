ring_range = ult_rings_get_ring_range(level)
ultimate_initialize(self, ULTIMATE_RINGS)
recently_struck_enemies = []
recently_struck_rings = array_create(global.bg_number_of_circles, 0)

function find_enemies_on_rings(_target_ring, _ring_range) {
	var _min_ring = max(0, _target_ring - _ring_range[0])
	var _max_ring = _target_ring + _ring_range[1]
	
	var _enemies_on_rings = []
	with (obj_enemy_parent) {
		var _enemy_ring = get_ring_from_distance(point_distance(x, y, global.xcenter, global.ycenter))
		if (_enemy_ring >= _min_ring && _enemy_ring <= _max_ring) {
			array_push(_enemies_on_rings, id)
		}
	}

	return _enemies_on_rings
}

function apply_damage_to_enemies_on_ring(_target, _player_who_shot_id) {
	// wait 1/10th of a second before resetting recently_struck_enemies
	alarm[1] = 0.1 * game_get_speed(gamespeed_fps)
	if (array_contains(recently_struck_enemies, _target) || !instance_exists(_target)) {
		// already struck this one recently, ignore
		return
	}

	var _on_streak = get_game_controller().has_point_streak(_player_who_shot_id)
	var _color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_RINGS]

	instance_create_layer(_target.x, _target.y, LAYER_FG_EFFECTS, obj_ult_collateral_explosion, {radius: 0})

	// Calculate which ring the target is on
	var _distance_to_center = point_distance(_target.x, _target.y, global.xcenter, global.ycenter)
	var _target_ring = get_ring_from_distance(_distance_to_center)

	// Find all enemies on adjacent rings based on level
	var _nearby_enemies = find_enemies_on_rings(_target_ring, ring_range)

	// Mark all affected rings as recently struck
	var _min_ring = max(0, _target_ring - ring_range[0])
	var _max_ring = min(global.bg_number_of_circles - 1, _target_ring + ring_range[1])
	for (var _r = _min_ring; _r <= _max_ring; _r++) {
		recently_struck_rings[_r] = 1
	}

	// add all nearby enemies to our list of recently struck (so we can ignore them),
	// then strike all of them except the initial target
	var _origin_x = _target.x
	var _origin_y = _target.y
	for (var _i = 0; _i < array_length(_nearby_enemies); _i++) {
		var _enemy = _nearby_enemies[_i]
		array_push(recently_struck_enemies, _enemy)

		// an earlier hit in this loop may have destroyed it
		if (_enemy == _target.id || !instance_exists(_enemy)) {
			continue
		}

		instance_create_layer(_origin_x, _origin_y, LAYER_BG_EFFECTS, obj_electric_beam, {
			target: _enemy,
			width: global.beam_width,
			color: _color
		})

		handle_enemy_hit(_enemy, _player_who_shot_id, 1)
	}
}