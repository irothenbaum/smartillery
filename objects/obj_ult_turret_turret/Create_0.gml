/// @description Start orbitting

// Orbit parameters
// orbit_angle = 0  // Will be set by parent object
// orbit_radius = global.bg_cicle_min_radius // will be set by parent
// orbit_direction (1 = clockwise, -1 = counter-clockwise), orbit_speed_multiplier and bobble_phase may be set by parent
if (!variable_instance_exists(id, "orbit_direction")) {
	orbit_direction = 1
}
if (!variable_instance_exists(id, "orbit_speed_multiplier")) {
	orbit_speed_multiplier = 1
}
if (!variable_instance_exists(id, "bobble_phase")) {
	bobble_phase = 0
}
// complete an orbit every 4 seconds (at 1x speed)
orbit_speed = orbit_direction * orbit_speed_multiplier * 360 / (4 * game_get_speed(gamespeed_fps))

// wave-like bobble: as the turret travels its orbit it weaves in and out of the ring, tracing a wavy circle with
// bobble_waves_per_orbit crests. The wave also drifts around on its own (bobble_speed) so it rotates like the bonus
// items' orbit, and bobble_phase offsets each turret's wave so they don't move in lockstep
bobble_amplitude = global.bg_circle_ring_width * 0.25 // px
bobble_waves_per_orbit = 3
bobble_speed = 360 / (2 * game_get_speed(gamespeed_fps)) // degrees per frame, the wave drifts a full cycle every 2 seconds

image_scale = 0.06

// spawn animation: start at the center at scale 0, then grow and move out to the orbit together (see Step)
spawn_duration = 0.5 // in seconds
spawn_progress = 0 // [0,1]
image_xscale = 0
image_yscale = 0
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
		handle_enemy_hit(_hit_enemies[_i], _player_who_shot_id, 1, {triggers_leech: true})
	}
}