/// @description Start orbitting

// Orbit parameters
// orbit_angle = 0  // Will be set by parent object
// orbit_radius = global.bg_cicle_min_radius // will be set by parent
orbit_speed = 360 / (4 * game_get_speed(gamespeed_fps)) // complete an orbit every 4 seconds

image_scale = 0.06
image_xscale = image_scale;
image_yscale = image_scale;
recoil_amount = 0
max_recoil_amount = 10

function create_beam(_player_who_shot_id) {
	// Calculate the end point of the turret's line
	var _target_x = x + lengthdir_x(global.bg_circle_max_radius, image_angle)
	var _target_y = y + lengthdir_y(global.bg_circle_max_radius, image_angle)
	
	var _on_streak = get_game_controller().has_point_streak(_player_who_shot_id)
	var _color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_TURRET]

	// Create muzzle flash
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_muzzle_flash, {
		target_x: _target_x,
		target_y: _target_y,
		width: global.beam_width_lg,
		color: _color
	})
	
	recoil_amount = max_recoil_amount

	// Find enemies along the line
	var _hit_enemies = []
	var _line_x1 = x
	var _line_y1 = y
	var _line_x2 = _target_x
	var _line_y2 = _target_y

	with (obj_enemy_parent) {
		var _dist = find_point_distance_to_line(_line_x1, _line_y1, _line_x2, _line_y2, x, y)

		// this distance is overly generous because otherwise it may never strike; instead of being half width its 75%
		var _functional_strike_distance = ceil(global.beam_width_lg / 2 + sprite_width * 0.75)
		if (_dist <= _functional_strike_distance) {
			array_push(_hit_enemies, id)
		}
	}

	// Register hits for all enemies along the line
	for (var _i = 0; _i < array_length(_hit_enemies); _i++) {
		handle_enemy_hit(_hit_enemies[_i], _player_who_shot_id, 1)
	}
}