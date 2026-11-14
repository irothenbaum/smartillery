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

// the range indicator grows from 0 to full size when the turret spawns (purely visual -- targeting uses the full range)
range_grow_duration = 0.5 // in seconds
range_grow_progress = 0 // [0,1]
display_range = 0

// despawn animation (reverse of the spawn): when the lifetime alarm fires, the range collapses to 0,
// then -- after a short pause -- the turret sprite shrinks to 0 and the instance is destroyed
is_despawning = false
despawn_elapsed = 0 // in seconds
despawn_start_range = 0 // display_range when the despawn began (in case it hadn't finished growing)
range_shrink_duration = range_grow_duration // in seconds
sprite_shrink_delay = 0.1 // in seconds, after the range has fully collapsed
sprite_shrink_duration = 0.25 // in seconds
sprite_scale = 1 // multiplier on body_scale / turret_scale

// rotation: spin slowly while idle, turn quickly (same as the player's turret) toward a target
rotate_idle_speed = 360 / 3 // in degrees per second
var _player = get_player()
rotate_aim_speed = instance_exists(_player) ? _player.rotate_aim_speed : 720 // in degrees per second
aim_tolerance = 1 // in degrees -- how close we need to be facing the target before firing

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
