/// @description Initialize stationary turret
// Spawned by the turret power item, at the item's position (the item already looks like this turret's body, so
// the turret takes over in place: its feet plant, the barrel extends out of the body, then the range grows in).
// owner_player_id (passed in on creation) is the player who activated it -- they get credit for its hits.
// It fires at most once per fire interval, spreading its shots across fresh enemies first and only coming back
// to finish off enemies it already shot when nothing new is in range (see find_target).
_u_color = shader_get_uniform(sh_hue_shift, "u_vColor")
color_arr = color_to_array(c_white)

body_scale = global.stationary_turret_body_scale // a smaller version of the player's body
turret_scale = 0.12 // matches enemy_2's turret
turret_length = 20 // matches enemy_2's get_turret_muzzle
range = global.stationary_turret_range

body_radius = sprite_get_width(spr_player_body) * body_scale / 2 // the body sprite's disc fills the whole sprite

// feet: four short rectangles poking out from under the body at 90 degree intervals. The set is turned 45 degrees off
// the line to the player, so the turret faces the player squarely between two feet (an X, not a +).
// They start as thin slivers along the body's border and grow outward as the first step of the spawn animation
feet_angle = point_direction(x, y, global.xcenter, global.ycenter) + 45
foot_width = 7 // px, along the body's border
foot_length = 5 // px, how far a fully grown foot sticks out past the border
foot_min_length = 1.5 // px, the thin sliver a foot starts as
foot_inset = 2 // px, how far a foot tucks under the body so there's no gap at the border
feet_grow_duration = 0.15 // in seconds
feet_grow_progress = 0 // [0,1]
feet_extend = 0 // [0,1]

// deploy: once the feet are planted, the barrel extends lengthwise out of the body, then the range grows in.
// The turret doesn't target or fire until the barrel is fully out
barrel_grow_duration = 0.2 // in seconds
barrel_grow_progress = 0 // [0,1]
barrel_extend = 0 // [0,1] multiplier on the barrel's length

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

// every enemy we've fired at -- fresh enemies are preferred over these (see find_target)
shot_enemies = []
can_fire = true

my_bounds = new Bounds(x - body_radius, y - body_radius, x + body_radius, y + body_radius)

// lifetime -- shown by the range fill shrinking toward the turret
lifetime_frames = global.stationary_turret_duration * game_get_speed(gamespeed_fps)
alarm[0] = lifetime_frames
lifetime_full_buffer = feet_grow_duration + barrel_grow_duration + range_grow_duration // in seconds: the fill stays full while deploying, then counts down
range_fill_alpha = 0.08
range_outline_alpha = 0.5

// the white pulse sent out to the range outline on every kill
kill_pulse_duration = 0.4 // in seconds
kill_pulse_stroke = 6 // px at the start -- it thins to 1px as it reaches the outline

/**
 * The in-range enemy closest to the player, preferring ones we haven't shot yet. Enemies we've already shot
 * (but that survived, e.g. enemy_2 with 2 health) are only targeted when no fresh enemy is in range
 * @returns {Id.Instance}
 */
function find_target() {
	var _fresh_target = noone
	var _fresh_distance = infinity
	var _repeat_target = noone
	var _repeat_distance = infinity
	with (obj_enemy_parent) {
		if (point_distance(x, y, other.x, other.y) > other.range) {
			continue
		}
		var _distance_to_player = point_distance(x, y, global.xcenter, global.ycenter)
		if (array_contains(other.shot_enemies, id)) {
			if (_distance_to_player < _repeat_distance) {
				_repeat_target = id
				_repeat_distance = _distance_to_player
			}
		} else if (_distance_to_player < _fresh_distance) {
			_fresh_target = id
			_fresh_distance = _distance_to_player
		}
	}
	return _fresh_target != noone ? _fresh_target : _repeat_target
}

/**
 * Each kill wins back some lifetime and sends a white pulse out to the range outline
 */
function register_kill() {
	// capped at what the range fill shows as full (the lifetime minus the full buffer -- capping at lifetime_frames
	// would leave the fill stuck at full for a moment)
	var _full_frames = lifetime_frames - lifetime_full_buffer * game_get_speed(gamespeed_fps)
	alarm[0] = min(alarm[0] + lifetime_frames * global.stationary_turret_lifetime_refund, max(alarm[0], _full_frames))

	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_expanding_ring, {
		start_radius: body_radius,
		end_radius: range,
		color: c_white,
		duration: kill_pulse_duration,
		stroke: kill_pulse_stroke,
		fade: true,
	})
}

/**
 * @param {Id.Instance} _target
 */
function fire_at(_target) {
	if (!array_contains(shot_enemies, _target)) {
		array_push(shot_enemies, _target)
	}
	recoil_amount = max_recoil_amount

	instance_create_layer(x + lengthdir_x(turret_length, image_angle), y + lengthdir_y(turret_length, image_angle), LAYER_BG_EFFECTS, obj_muzzle_flash, {
		target: _target,
		width: global.beam_width_sm,
		color: c_white,
	})
	handle_enemy_hit(_target, owner_player_id, 1)

	// a killing blow destroys the enemy immediately, so if it's gone, this shot was a kill
	if (!instance_exists(_target)) {
		register_kill()
	}

	can_fire = false
	alarm[1] = global.stationary_turret_fire_interval * game_get_speed(gamespeed_fps)
}
