/// @description Initialize stationary turret
// Spawned by the turret power item, at the item's position. owner_player_id (passed in on creation)
// is the player who activated it -- they get credit for its hits.
// It shoots each enemy that enters its range exactly once, at most once per fire interval.
_u_color = shader_get_uniform(sh_hue_shift, "u_vColor")
color_arr = color_to_array(c_white)

body_scale = 0.1 // a smaller version of the player's body
turret_scale = 0.12 // matches enemy_2's turret
turret_length = 20 // matches enemy_2's get_turret_muzzle
range = global.stationary_turret_range

recoil_amount = 0
max_recoil_amount = 8

// start facing away from the player
image_angle = point_direction(global.xcenter, global.ycenter, x, y)

// every enemy we've fired at -- each enemy only ever gets shot once
shot_enemies = []
can_fire = true

var _body_radius = sprite_get_width(spr_player_body) * body_scale / 2
my_bounds = new Bounds(x - _body_radius, y - _body_radius, x + _body_radius, y + _body_radius)

// lifetime
alarm[0] = global.stationary_turret_duration * game_get_speed(gamespeed_fps)

/**
 * The enemy closest to the player that's in range and hasn't been shot yet
 * @returns {Id.Instance}
 */
function find_target() {
	var _target = noone
	var _target_distance = infinity
	with (obj_enemy_parent) {
		if (point_distance(x, y, other.x, other.y) > other.range || array_contains(other.shot_enemies, id)) {
			continue
		}
		var _distance_to_player = point_distance(x, y, global.xcenter, global.ycenter)
		if (_distance_to_player < _target_distance) {
			_target = id
			_target_distance = _distance_to_player
		}
	}
	return _target
}

/**
 * @param {Id.Instance} _target
 */
function fire_at(_target) {
	array_push(shot_enemies, _target)
	image_angle = point_direction(x, y, _target.x, _target.y)
	recoil_amount = max_recoil_amount

	instance_create_layer(x + lengthdir_x(turret_length, image_angle), y + lengthdir_y(turret_length, image_angle), LAYER_BG_EFFECTS, obj_muzzle_flash, {
		target: _target,
		width: global.beam_width_sm,
		color: c_white,
	})
	handle_enemy_hit(_target, owner_player_id, 1)

	can_fire = false
	alarm[1] = global.stationary_turret_fire_interval * game_get_speed(gamespeed_fps)
}
