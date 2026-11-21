/**
 * @param {Id.Instance} _e
 */
function initialize_instance_has_equation(_e) {
	draw_equation_position = undefined
	equation = "";
	last_hit_by_player_id = undefined
	
	enemy_generate_question(_e)
}

/**
 * @param {Id.Instance} _e
 */
function enemy_initialize(_e) {
	with (_e) {
		spawn_time = get_play_time()
		point_value = ds_map_find_value(global.points_map, object_index)
		slow_multiplier = 1
		slow_sparks = undefined
		// set by enemy_destroy_without_reward (damage burst, shield), so the kill yields no rewards
		killed_without_reward = false
		// test room only: frozen enemies are held in place by the game controller.
		// may be passed in on creation (instance_create_layer params are applied before Create), so don't overwrite it
		if (!variable_instance_exists(self, "frozen")) {
			frozen = false
		}
	}
	// must go after the initializations due to edge conditions
	initialize_instance_has_equation(_e)
}

/**
 * @param {Id.Instance} _e
 */
function enemy_handle_destroy(_e) {
	get_game_controller().handle_enemy_killed(_e)
	with (_e) {
		if (!is_undefined(slow_sparks)) {
			destroy_particle(slow_sparks)
		}
	}

	// something other than the player's own shot may have killed an enemy the player was queued to fire at
	// (damage burst, shield, stationary turret, ults), so drop it from the queue before the turret aims at it
	var _player = get_player()
	if (instance_exists(_player)) {
		with (_player) {
			var _queue_length = array_length(aiming_at_instance)
			aiming_at_instance = array_filter(aiming_at_instance, method({_e: _e}, function(_entry) {
				return _entry.inst != _e.id
			}))
			if (array_length(aiming_at_instance) != _queue_length) {
				rotate_towards_next_target()
			}
		}
	}
}

/**
 * Destroys an enemy without granting points, streak, combo, or any other benefit
 * @param {Id.Instance} _e
 */
function enemy_destroy_without_reward(_e) {
	with (_e) {
		// handle_enemy_killed reads this to skip all rewards
		killed_without_reward = true
		last_hit_by_player_id = undefined
		instance_destroy()
	}
}

// -------------------------------------------------------------------------------------------
// ATTACK COLOR
// Enemies fade to global.enemy_attack_color once they commit to attacking (enemy 1's final approach, enemy 2 in
// firing position, enemy 3 at top speed, enemy 4 fragments homing in), and back if they stop (e.g. stunned).
// Call enemy_attack_color_init in Create, then enemy_get_attack_color once per Draw.
// -------------------------------------------------------------------------------------------

/**
 * @param {Id.Instance} _e
 * @param {Constant.Color} _normal_color -- the color drawn when not attacking
 */
function enemy_attack_color_init(_e, _normal_color = c_white) {
	with (_e) {
		_u_color = shader_get_uniform(sh_hue_shift, "u_vColor")
		normal_color = _normal_color
		attack_blend = 0 // 0 = normal_color, 1 = global.enemy_attack_color
	}
}

/**
 * Moves the enemy's color toward (or away from) the attack color by global.fade_speed, and returns the current color
 * @param {Id.Instance} _e
 * @param {Bool} _is_attacking
 * @returns {Struct} {color: Constant.Color, color_arr: Array<Real>} -- color_arr is for sh_hue_shift's u_vColor
 */
function enemy_get_attack_color(_e, _is_attacking) {
	with (_e) {
		if (!global.paused) {
			attack_blend = lerp(attack_blend, _is_attacking ? 1 : 0, global.fade_speed)
			// snap the tail of the fade so it settles exactly
			if (abs(attack_blend - (_is_attacking ? 1 : 0)) < 0.01) {
				attack_blend = _is_attacking ? 1 : 0
			}
		}
		var _color = merge_color(normal_color, global.enemy_attack_color, attack_blend)
		return {color: _color, color_arr: color_to_array(_color)}
	}
}

/**
 * @param {Id.Instance} _e
 */
function enemy_step(_e) {
	with(_e) {
		my_bounds = get_bounds_for_instance(self)
	}
}

/**
 * @param {Id.Instance} _e
 */
function instance_draw_equation(_e) {
	with (_e) {
		var _string = global.paused ? " " : equation
		var _positions = get_draw_equation_position(_string, x, y)
		var _actual_position = _positions[0]
		var _target_position = _positions[1]
				
		draw_equation_position = is_undefined(draw_equation_position) ? _target_position : {
			x: lerp(draw_equation_position.x, _actual_position.x, global.fade_speed * 2),
			y: lerp(draw_equation_position.y, _actual_position.y, global.fade_speed * 2)
		}
		// trial run
		var _text_bounds = draw_text_with_alignment(draw_equation_position.x, draw_equation_position.y, _string, ALIGN_CENTER, undefined, true);
		var _box_bounds = apply_padding_to_bounds(_text_bounds, 2, 12)
		draw_set_composite_color(new CompositeColor(c_black, 0.6))
		draw_rectangle(_box_bounds.x0, _box_bounds.y0, _box_bounds.x1, _box_bounds.y1, false)
		reset_composite_color()
		// draw again so it's on top
		draw_text_with_alignment(draw_equation_position.x, draw_equation_position.y, _string, ALIGN_CENTER);
	}
}

/**
 * @param {String} _string
 * @param {Real} _x
 * @param {Real} _y
 * Returns a tuple. The first value is always within room bounds, the second is where it would like to render under or over the target
 */
function get_draw_equation_position(_string, _x, _y, _offset_override) {
	draw_set_font(fnt_large);
	draw_set_color(c_white);
	var _string_height = string_height(_string)
	var _string_width = string_width(_string)
	// we use player_body_radius a proxy that basically indicates half an emey sprite size
	var _offset_y = is_undefined(_offset_override) ? (_y > global.ycenter ? -1 : 1) * (global.player_body_radius + _string_height) : _offset_override
		
	// this logic is going to draw the equation within the game bounds even if the enemy us out of screen
	var _string_directional_bounds = new Bounds(
		global.directional_hint_bounds.x0 + _string_width / 2,
		global.directional_hint_bounds.y0 + _string_height / 2,
		global.directional_hint_bounds.x1 - _string_width / 2,
		global.directional_hint_bounds.y1 - _string_height / 2
	)
		
	var _target_position = {
		x: _x,
		y: _y + _offset_y
	}
	var _actual_position = _target_position
		
	// we're out of bounds of any of our coordinates as off screen
	var _is_out_of_bounds = 
		_target_position.x < _string_directional_bounds.x0 || 
		_target_position.y < _string_directional_bounds.y0 ||
		_target_position.x > _string_directional_bounds.x1 || 
		_target_position.y > _string_directional_bounds.y1
			
	if (_is_out_of_bounds) {
		var _direction_from_center = point_direction(global.xcenter, global.ycenter, _target_position.x, _target_position.y)
		_actual_position = find_point_on_bounds_at_angle(_string_directional_bounds, _direction_from_center)
	}
		
	// TODO: may need to revist this with more player Inputs on HUD
	// make sure we never draw the equation ontop of the HUD elements
	_actual_position.y = max(70, _actual_position.y) // this 70 is basically the HUD height
		
	// we check again here because we need _actual_position in its final state.
	if (_is_out_of_bounds) {
		var _direction_from_equation_to_enemy = point_direction(_actual_position.x, _actual_position.y, x, y) 
		draw_sprite_ext(
			spr_chevron, 
			0, 
			_actual_position.x + lengthdir_x(40, _direction_from_equation_to_enemy), 
			_actual_position.y + lengthdir_y(40, _direction_from_equation_to_enemy),
			0.07, 
			0.07, 
			_direction_from_equation_to_enemy, 
			c_white, 
			1
		)
	}
		
	return [_actual_position, _target_position]
}

function enemy_generate_question(_e) {
	// an instance can set its own difficulty_wave (e.g. obj_training_target, which levels up on its own);
	// everything else uses the game's current wave
	var _wave = variable_instance_exists(_e, "difficulty_wave") ? _e.difficulty_wave : get_current_wave_number()
	var _functional_wave = ceil(_wave / ds_map_find_value(global.targetable_difficulty_multiplier, _e.object_index))
	
	with (_e) {
		equation = ""
		answer = ""

		var _attempts = 10;
		var _failed_attempts = 0;
		var _max_multiplier = 1;
		do {
			try {
				_attempts--;
				var _values = global.is_math_mode ? generate_equation_and_answer(_functional_wave, _max_multiplier) : generate_text_and_answer(_functional_wave)
				get_game_controller().reserve_answer(_values.answer, self)
				equation = _values.equation
				answer = _values.answer
			} catch (_err) {
				debug(_err)
				if (_err != "Answer in use") {
					debug("ENCOUNTERED ERROR:", _err)
					throw _err
				}
				_failed_attempts++;
				// every 3 collisions, double the max answer to widen the pool of possible answers
				if (_failed_attempts % 3 == 0) {
					_max_multiplier *= 2;
				}
			}
		} until (equation != "" || _attempts <= 0)
	
		if (equation == "") {
			debug("Could not create equation");
			instance_destroy();
			return
		}
	}
}

function find_enemies_near_point(_x, _y, _radius) {
	var _nearby_enemies = []
	with (obj_enemy_parent) {
		if (point_distance(x, y, _x, _y) < _radius) {
			array_push(_nearby_enemies, id)
		}
	}
	return _nearby_enemies
}

function find_enemies_near_answer(_answer, _range_min, _range_max) {
	var _enemies = []
	var _gc = get_game_controller()
	
	var _number
	try {
		_number = real(_answer)
	} catch (e) {
		return []
	}
	
	var _low_guess =_number - _range_min
	var _high_guess = _number + _range_max
	
	for (var _i = _low_guess; _i <= _high_guess; _i++ ){ 
		if (_i == _number) {
			// it was already handled by game controller
			continue
		}
		
		// this is a little specific to the workings of the game_controller
		if (_gc.is_answer_reserved(_i) ) {
			var _instance = _gc.active_answers[$ _i];
			if (instance_is_enemy(_instance)) {
				array_push(_enemies, _instance)
			} else {
				debug("Targetable instance not an enemy")
			}
		} else {
			debug("Answer not reserved", _i)
		}
	}
	
	return _enemies
}

function enemy_remove_slow(_enemy) {
	enemy_apply_slow(_enemy, 1)
}

function enemy_apply_slow(_enemy, _multiplier) {
	with(_enemy) {
		if (slow_multiplier != _multiplier) {
			// undo our last multiplier
			speed = speed / slow_multiplier
			// apply the new one
			slow_multiplier = _multiplier
			speed = speed * slow_multiplier
			
			if (_multiplier == 1) {
				if (!is_undefined(slow_sparks)) {
					destroy_particle(slow_sparks)
				}
				slow_sparks = undefined
			} else {
				slow_sparks = draw_particle_sparkle(x, y, global.ultimate_colors[$ ULTIMATE_SLOW], sprite_width / 2)
			}
		}
		
		if (!is_undefined(slow_sparks)) {
			part_system_position(slow_sparks, x, y)
		}
	}
}

/**
 * @returns {{x: Real, y: Real}}
 */
function get_enemy_spawn_position() {
	var _rotation = irandom(360)
	var _pos_x = global.xcenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	var _pos_y = global.ycenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	
	// the no spawn zone is the middle 33%, so if pos_x is in that range, we shift it
	var _no_spawn_marker = global.room_width * 0.33
	if (_pos_x > _no_spawn_marker && _pos_x < _no_spawn_marker * 2) {
		var _distance_to_center = _pos_x - global.xcenter
		// if _distance_to_center is negative, then pos_x is to the right of center, in the middle 33%.
		// this basically shifts our x position back into either the first or 3rd swction respctive to its position in the second
		_pos_x = _distance_to_center < 0 ? 2 * (_no_spawn_marker + abs(_distance_to_center)) : _no_spawn_marker - (_distance_to_center * 2)
	}
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	
	_pos_y = _quad == 1 ? -global.oob_margin : (_quad == 3 ? global.room_height + global.oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -global.oob_margin : (_quad == 2 ? global.room_width + global.oob_margin : _pos_x);
	
	return {
		x: _pos_x,
		y: _pos_y,
	}
}

/**
 * @param {Real} _wave
 * @returns {{type: Id.Instance, params: Struct}}
 */
function get_enemy_to_spawn(_wave) {
	var _enemy_order = [
		obj_enemy_1,
		obj_enemy_2,
		obj_compound_enemy_1,
		obj_enemy_3,
		obj_compound_enemy_2,
		obj_enemy_4,
		// obj_enemy_5, not working right
	]
	
	var _max_enemy = floor(_wave / global.wave_difficulty_step)
	
	var _next_enemy_type = undefined
	var _next_enemy_params = {}
	do {
		if (_max_enemy == 0 || flip_coin(max(2, (_max_enemy) * 10 - _wave))) {
			_next_enemy_type = _enemy_order[_max_enemy]
		} else {
			_max_enemy--
		}
	} until (!is_undefined(_next_enemy_type))
	
	
	// JUST FOR TESTING:
	// _next_enemy_type = obj_enemy_5
	// -----
	
	switch(_next_enemy_type) {
		case obj_compound_enemy_1:
			_next_enemy_params.enemy_count = 4 + floor(_wave / global.wave_difficulty_step)
			_next_enemy_params.waypoint_count = floor(_next_enemy_params.enemy_count / 3)
			break
		
		case obj_compound_enemy_2:
			_next_enemy_params.enemy_count = 3 + floor(_wave / global.wave_difficulty_step)
			break
	}

	return {
		type: _next_enemy_type,
		params: _next_enemy_params
	}
}

// -------------------------------------------------------------------------------------------
// BONUS ITEM ORBIT
// Bonus items (obj_bonus_item_parent: power items, extra ultimates) orbit the player on one ring, spaced evenly. The game controller is the
// central authority: update_orbit_formation() assigns every orbiter its slot once per step, and each orbiter
// eases toward its slot in orbiter_step(). New items glide in from where they spawned instead of snapping,
// and the formation re-spaces smoothly whenever an item is added or removed.
// -------------------------------------------------------------------------------------------

#macro ORBIT_EASE 0.04 // per-frame lerp toward the orbit ring and toward an orbiter's slot

/**
 * The middle of the orbit ring
 * @returns {Real}
 */
function get_orbit_radius() {
	// rings are indexed from the outside in
	var _ring_index = global.bg_number_of_circles - global.bonus_item_orbit_ring_from_center
	return (get_radius_for_ring(_ring_index) + get_radius_for_ring(_ring_index + 1)) / 2
}

/**
 * Starts the orbiter at its spawn position (polar, around the center) so it eases into orbit from there
 * @param {Id.Instance} _inst
 */
function orbiter_initialize(_inst) {
	with (_inst) {
		orbit_angle = point_direction(global.xcenter, global.ycenter, x, y)
		orbit_radius = point_distance(global.xcenter, global.ycenter, x, y)
		orbit_target_angle = orbit_angle
		// each item wiggles at its own rate and offset so the formation stays disorganized
		wiggle_period = random_range(global.bonus_item_wiggle_period_min, global.bonus_item_wiggle_period_max)
		wiggle_phase = random(360)
	}
}

/**
 * Assigns every orbiter an evenly spaced slot. Orbiters keep their current order around the circle, and the
 * formation's rotation is the one closest to where they already are -- so nobody crosses paths or jumps
 */
function update_orbit_formation() {
	var _orbiters = get_array_of_instances(obj_bonus_item_parent)
	var _count = array_length(_orbiters)
	if (_count == 0) {
		return
	}

	// sign() matters: array_sort treats the comparator's result as an integer, so a raw float difference under 1
	// (two items < 1 degree apart) reads as "equal" inconsistently, which can crash the runner's native sort
	array_sort(_orbiters, function(_a, _b) {
		return sign(_a.orbit_angle - _b.orbit_angle)
	})

	// the formation's phase is the circular mean of each orbiter's offset from its slot
	var _spacing = 360 / _count
	var _sum_x = 0
	var _sum_y = 0
	for (var _i = 0; _i < _count; _i++) {
		var _offset = _orbiters[_i].orbit_angle - _i * _spacing
		_sum_x += dcos(_offset)
		_sum_y += dsin(_offset)
	}
	var _phase = darctan2(_sum_y, _sum_x)

	for (var _i = 0; _i < _count; _i++) {
		_orbiters[_i].orbit_target_angle = _phase + _i * _spacing
	}
}

/**
 * Rotates the orbiter and eases it toward its slot on the orbit ring
 * @param {Id.Instance} _inst
 */
function orbiter_step(_inst) {
	with (_inst) {
		var _rotate_step = 360 / global.bonus_item_orbit_period * step_seconds()
		// the slot rotates too, so easing toward it doesn't lag behind the orbit
		orbit_target_angle += _rotate_step
		orbit_angle += _rotate_step + angle_difference(orbit_target_angle, orbit_angle) * ORBIT_EASE
		orbit_angle = ((orbit_angle mod 360) + 360) mod 360
		orbit_radius = lerp(orbit_radius, get_orbit_radius(), ORBIT_EASE)

		// wave-like wiggle: a radial in-and-out offset at this item's own period and phase, so items ripple
		// independently rather than tracing a shared shape. It's applied only to the final position so the eased
		// orbit_radius stays clean.
		var _ring_width = global.bg_circle_magnitude / global.bg_number_of_circles
		wiggle_phase = (wiggle_phase + 360 / wiggle_period * step_seconds()) mod 360
		var _draw_radius = orbit_radius + dsin(wiggle_phase) * _ring_width * global.bonus_item_wiggle_amplitude

		x = global.xcenter + lengthdir_x(_draw_radius, orbit_angle)
		y = global.ycenter + lengthdir_y(_draw_radius, orbit_angle)
	}
}

// -------------------------------------------------------------------------------------------
// ENEMY 1 MOVEMENT
// Shared by obj_enemy_1 and the main menu's obj_menu_enemy_1. Reads/writes: waypoints, direction, speed,
// image_angle, rotate_speed, slow_multiplier, alarm[0] (the "give up and aim at the player" failsafe)
// -------------------------------------------------------------------------------------------

/**
 * @param {Id.Instance} _e
 */
function enemy_1_movement_step(_e) {
	with (_e) {
		image_angle += rotate_speed * slow_multiplier

		if (array_length(waypoints) > 0) {
			var _target = waypoints[0]
			var _dist = point_direction(x, y, _target.x, _target.y)

			// Add curve offset based on distance to waypoint
			// Use waypoint position as seed for deterministic curve direction
			var _curve_seed = floor(_target.x + _target.y * 1000)
			var _curve_dir = ((_curve_seed mod 2) == 0) ? 1 : -1
			var _distance_to_target = point_distance(x, y, _target.x, _target.y)
			var _curve_strength = min(1, _distance_to_target / 200) * 25 * _curve_dir

			direction -= angle_difference(direction, _dist + _curve_strength) * 0.05;

			// when we're close to a waypoint, we shift it off
			if (_distance_to_target < global.margin_md) {
				array_shift(waypoints)
			}
		} else {
			direction -= angle_difference(direction, point_direction(x, y, global.xcenter, global.ycenter)) * 0.05;
			// accelerate to speed 5
			speed = lerp(speed, 5 * slow_multiplier, 0.03)
			rotate_speed = lerp(rotate_speed, 12, 0.08)

			// as a failsafe, we'll aim directly for the player 3 seconds after making our final turn
			if (!(alarm[0] > 0)) {
				alarm[0] = 3 * game_get_speed(gamespeed_fps) / slow_multiplier
			}
		}
	}
}

/**
 * Main menu only: a spawn point just outside the left or bottom edge of the zoomed menu camera (see
 * set_menu_viewport_dimensions), so menu enemies cross the visible area on their way to the player
 * @returns {{x: Real, y: Real}}
 */
function get_menu_enemy_spawn_position() {
	var _cam = view_camera[0]
	var _view_x0 = camera_get_view_x(_cam)
	var _view_y0 = camera_get_view_y(_cam)
	var _view_x1 = _view_x0 + camera_get_view_width(_cam)
	var _view_y1 = _view_y0 + camera_get_view_height(_cam)

	if (flip_coin()) {
		// left edge
		return {
			x: _view_x0 - global.oob_margin,
			y: random_range(_view_y0, _view_y1),
		}
	}
	// bottom edge
	return {
		x: random_range(_view_x0, _view_x1),
		y: _view_y1 + global.oob_margin,
	}
}

// -------------------------------------------------------------------------------------------
// POWER ITEMS
// Each power item type is its own child of obj_power_item. obj_power_item itself is never spawned directly --
// pick_power_item_object() chooses which child to spawn, weighted by what the player needs most right now.
// -------------------------------------------------------------------------------------------

/**
 * @returns {Asset.GMObject}
 */
function pick_power_item_object() {
	var _player = get_player()
	var _missing_health = global.max_health - _player.my_health
	var _shield = instance_find(obj_shield, 0)
	// shields still flying in from a pickup count too, so a burst of shield items doesn't keep rolling shields
	var _shield_health = (_shield == noone ? 0 : _shield.shield_health) + instance_number(obj_shield_pickup)

	var _options = [
		{obj: obj_power_item_shield, weight: 1 / power(2, _shield_health)},
		{obj: obj_power_item_level_up, weight: 1},
		{obj: obj_power_item_health, weight: (_missing_health > 0) ? power(2, floor(_missing_health / 20)) : 1},
		{obj: obj_power_item_points, weight: 1},
		{obj: obj_power_item_turret, weight: 1},
	]

	var _total_weight = 0
	for (var _i = 0; _i < array_length(_options); _i++) {
		_total_weight += _options[_i].weight
	}

	var _roll = random(_total_weight)
	var _cumulative = 0
	for (var _i = 0; _i < array_length(_options); _i++) {
		_cumulative += _options[_i].weight
		if (_roll < _cumulative) {
			return _options[_i].obj
		}
	}
	return _options[0].obj
}

/**
 * The shield fills one background ring exactly (rings are indexed from the outside in). Shared by obj_shield and
 * everything that draws a scaled-down copy of it (the shield power item and its fly-in pickup)
 * @returns {Struct}
 */
function get_shield_geometry() {
	var _ring_index = global.bg_number_of_circles - global.shield_ring_from_center
	var _outer_radius = get_radius_for_ring(_ring_index)
	var _inner_radius = get_radius_for_ring(_ring_index + 1)
	return {
		outer_radius: _outer_radius,
		inner_radius: _inner_radius,
		radius: (_outer_radius + _inner_radius) / 2,
		thickness: _outer_radius - _inner_radius,
	}
}

/**
 * Draws the shield ring at _scale of its real size, centered on (_x, _y)
 * @param {Real} _x
 * @param {Real} _y
 * @param {Real} _scale
 */
function draw_shield_ring(_x, _y, _scale) {
	var _geometry = get_shield_geometry()
	draw_set_color(global.shield_color)
	draw_arc(_x, _y, _geometry.radius * _scale, 360, 0, _geometry.thickness * _scale)
}

// -------------------------------------------------------------------------------------------
// POINT / HEALTH ORBS
// Shared by obj_orb_score_increase (the orbs that fly to the player) and obj_power_item_orb_cluster (the power
// items drawn as a cluster of those same orbs), so the item shows exactly the orbs it will pay out
// -------------------------------------------------------------------------------------------

#macro ORB_MAX_VALUE 15 // an amount is split into orbs worth at most this much each
#macro ORB_CLOUD_RADIUS 30 // px, how far flying orbs spread from their cloud's center

/**
 * Splits an amount into orb values, largest first (e.g. 25 -> [7, 7, 7, 4])
 * @param {Real} _amount
 * @returns {Array<Real>}
 */
function split_orb_amount(_amount) {
	var _values = []
	do {
		var _value = min(ORB_MAX_VALUE, _amount)
		array_push(_values, _value)
		_amount -= _value
	} until (_amount <= 0)
	return _values
}

/**
 * @param {Real} _value
 * @returns {Real}
 */
function get_orb_draw_radius(_value) {
	return 4 + (_value / 3)
}

/**
 * @param {String} _type -- ORB_TYPE_*
 * @param {Real} _owner_player_id -- only used by player-colored types (ult, combo)
 * @returns {Constant.Color}
 */
function get_orb_color(_type, _owner_player_id = undefined) {
	switch (_type) {
		case ORB_TYPE_HEALTH:
			return global.ultimate_color_tints[$ ULTIMATE_HEAL]
		case ORB_TYPE_ULT:
		case ORB_TYPE_COMBO:
			return get_player_color(_owner_player_id)
		default:
			return c_white
	}
}
