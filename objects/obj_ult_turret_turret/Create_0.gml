/// @description Start orbitting

// Orbit parameters
// orbit_angle = 0  // Will be set by parent object
// orbit_radius = global.bg_cicle_min_radius // will be set by parent
orbit_speed = 360 / (4 * game_get_speed(gamespeed_fps)) // complete an orbit every 4 seconds

image_scale = 0.06
image_xscale = image_scale;
image_yscale = image_scale;

// Subscribe to player fire event
subscribe(self, EVENT_PLAYER_FIRED, method(self, function(_target, _player_who_shot_id) {
	// Calculate the end point of the turret's line
	var _target_x = x + lengthdir_x(global.bg_circle_max_radius, image_angle)
	var _target_y = y + lengthdir_y(global.bg_circle_max_radius, image_angle)

	// Create muzzle flash
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_muzzle_flash, {
		target_x: _target_x,
		target_y: _target_y,
		width: global.beam_width_sm,
		color: get_player_color(_player_who_shot_id)
	})

	// Find enemies along the line
	var _hit_enemies = []
	var _line_x1 = x
	var _line_y1 = y
	var _line_x2 = _target_x
	var _line_y2 = _target_y

	for_each_enemy(function(_enemy, _index, _line_x1, _line_y1, _line_x2, _line_y2, _hit_enemies) {
		if (!instance_exists(_enemy)) {
			return
		}
		
		var _dist = find_point_distance_to_line(_line_x1, _line_y1, _line_x2, _line_y2, _enemy.x, _enemy.y)
		
		// this distance is overly generous because otherwise it may never strike; instead of being half width its 75%
		var _functional_strike_distance = ceil(global.beam_width_sm * 0.75 + _enemy.sprite_width / 2)
		debug("DIST:", _dist, _functional_strike_distance)
		if (_dist <= _functional_strike_distance) {
			array_push(_hit_enemies, _enemy)
		}
	}, _line_x1, _line_y1, _line_x2, _line_y2, _hit_enemies)

	// Register hits for all enemies along the line
	array_foreach(_hit_enemies, method({_player_who_shot_id: _player_who_shot_id}, function(_enemy) {
		_enemy.last_hit_by_player_id = _player_who_shot_id
		_enemy.register_hit()
		broadcast(EVENT_ENEMY_HIT, _enemy, _player_who_shot_id)
	}))
}))