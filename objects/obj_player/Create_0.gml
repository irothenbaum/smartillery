_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
recoil_amount = 0
max_recoil_amount = 20
hide_self = false;

game_controller = get_game_controller()
body_color_arr = color_to_array(global.body_color)
turret_color_arr = color_to_array(global.turret_color)

rotate_aim_speed = 720 // in degrees per second
rotate_idle_speed = 90 // in degrees per second
rotate_speed = rotate_idle_speed
rotate_to = 90;
my_health = global.max_health
aiming_at_instance = []
image_angle = rotate_to;
direction = 90 // point upwards - the default and starting position
x = global.xcenter
y = global.ycenter

image_scale = 0.16
image_xscale = image_scale;
image_yscale = image_scale;

hull_flashes = []
screen_shake = instance_create_layer(x,y, LAYER_INSTANCES, obj_screen_shake)
streak_fire = undefined

// multi-player taps (see execute_hit_target): back-to-back shots at the same target
tap_delay = 0.08 // in seconds between shots in a tap
tap_cooldown = 0 // in frames until the next tap shot can fire
tap_target = noone // the target of the tap sequence in progress, so its text only shows on the first shot

function rotate_towards_next_target() {
	if (array_length(aiming_at_instance) > 0) {
		rotate_speed = rotate_aim_speed;
		var _target = aiming_at_instance[0].inst 
		rotate_to = point_direction(x, y, _target.x, _target.y)
	} else {
		// after a few seconds, reset to vertical postion
		alarm[0] = game_get_speed(gamespeed_fps) * 3
	}
}

/**
 * @param {Id.Instance} _inst
 * @param {String} _player_id -- who took the shot
 */
function fire_at_instance(_inst, _player_id) {
	if (!_inst) {
		// do nothing
		return
	}
	alarm[0] = -1
	// a follow-up shot at a target that's already queued (a multi-player tap) goes right after the others, so they fire back-to-back
	var _insert_at = array_length(aiming_at_instance)
	for (var _i = array_length(aiming_at_instance) - 1; _i >= 0; _i--) {
		if (aiming_at_instance[_i].inst == _inst) {
			_insert_at = _i + 1
			break
		}
	}
	array_insert(aiming_at_instance, _insert_at, {
		inst : _inst,
		player_id: _player_id
	})
	rotate_towards_next_target()
}

/**
 * @param {Id.Instance} _inst
 * @returns {Real} how many shots are queued at _inst
 */
function count_queued_shots(_inst) {
	var _count = 0
	for (var _i = 0; _i < array_length(aiming_at_instance); _i++) {
		if (aiming_at_instance[_i].inst == _inst) {
			_count++
		}
	}
	return _count
}

/**
 * @param {Id.Instance} _inst
 * @param {Real} _player_id
 * @returns {Bool} whether _player_id already has a shot queued at _inst
 */
function has_queued_shot_from(_inst, _player_id) {
	for (var _i = 0; _i < array_length(aiming_at_instance); _i++) {
		if (aiming_at_instance[_i].inst == _inst && aiming_at_instance[_i].player_id == _player_id) {
			return true
		}
	}
	return false
}

/**
 * Floats "Double Tap" / "Triple Tap" / ... up from the target
 * @param {Id.Instance} _target
 * @param {Real} _shot_count
 */
function show_tap_text(_target, _shot_count) {
	var _names = ["", "", "Double", "Triple", "Quadruple"]
	var _name = _shot_count < array_length(_names) ? _names[_shot_count] : string_concat(_shot_count, "x")
	instance_create_layer(_target.x, _target.y - global.margin_md, LAYER_FG_EFFECTS, obj_text_score_increase, {
		message: string_concat(_name, " Tap"),
		amount: _shot_count,
		color: c_white,
		font: fnt_large,
	})
}

function execute_hit_target() {
	if (array_length(aiming_at_instance) == 0) {
		debug("This shouldn't happen -- execute_hit_target -> not aiming_at_instance")
		return
	}
	
	var _target_entry = array_shift(aiming_at_instance)
	var _target = _target_entry.inst
	var _player_who_shot_id = _target_entry.player_id

	// multi-player tap: more shots queued at this same target fire back-to-back, with a short pause so each one reads
	var _follow_up_shots = count_queued_shots(_target)
	if (_follow_up_shots > 0) {
		// first shot of the sequence -- the count is final now, since no one can answer after the first shot lands
		if (tap_target != _target) {
			show_tap_text(_target, _follow_up_shots + 1)
		}
		tap_target = _target
		tap_cooldown = tap_delay * game_get_speed(gamespeed_fps)
	} else {
		tap_target = noone
	}

	// Muzzle Flash
	var _muzzle = get_turret_muzzle()
	var _on_streak = game_controller.has_point_streak(_player_who_shot_id)
	var _flash_variables = {
		target: _target,
		width: _on_streak ? global.beam_width_lg : global.beam_width, 
		color: _on_streak ? get_player_color(_player_who_shot_id) : global.beam_color
	}
	instance_create_layer(_muzzle.x, _muzzle.y, LAYER_BG_EFFECTS, obj_muzzle_flash, _flash_variables)

	// shooting one of your own items (power items, extra ultimates) is just picking it up: no ultimate reacts to it
	// (no collateral, leech, rings or turret shots)
	var _is_bonus_item = instance_is_bonus_item(_target)

	if (!_is_bonus_item && game_controller.is_ult_active(ULTIMATE_COLLATERAL)) {
		// override color, default to ult color if not fired by a player on streak
		_flash_variables.color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_COLLATERAL]
		instance_create_layer(_muzzle.x, _muzzle.y, LAYER_BG_EFFECTS, obj_electric_beam, _flash_variables)
	}
	
	recoil_amount = max_recoil_amount
	
	if (_is_bonus_item) {
		handle_enemy_hit(_target, _player_who_shot_id, 1, {from_player_shot: false, triggers_leech: false})
	} else {
		handle_enemy_hit(_target, _player_who_shot_id, 1, {from_player_shot: true})

		// if we have any turrets, we trigger them to shoot also
		with (obj_ult_turret_turret) {
			create_beam(_player_who_shot_id)
		}
	}
	
	rotate_towards_next_target()
}

function execute_take_damage(_damage_amount) {
	my_health -= _damage_amount
	
	// any damage resets the streak
	streak = 0
	
	if (my_health <= 0) {
		aiming_at_instance = []
		game_controller.end_game()
	}
	
	game_controller.reset_streak()
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: draw_particle_shockwave})
	
	// clear out nearby enemies to give the player a moment to recover
	if (!game_controller.is_game_over) {
		instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_damage_burst)
	}
	
   with (screen_shake)
   {
      shake = true;
      shake_time = 0.2 * game_get_speed(gamespeed_fps);
      shake_magnitude = 4;
      shake_fade = 0.5;
   }
}

function increase_health(_amount) {
	// TODO: Could show a cool animaton or something?
	my_health = min(global.max_health, my_health + _amount)
}

function get_turret_muzzle(_extra = 0) {
	return {
		x: x + lengthdir_x(global.turret_length + _extra, image_angle),
		y: y + lengthdir_y(global.turret_length + _extra, image_angle)
	}
}

function flash_hull(_color) {
	array_push(hull_flashes, {
		step: 0,
		color: _color,
	})
}

show_debug_message("BOOT 6: player create end"); var _boot_f = file_text_open_append("boot_log.txt"); file_text_write_string(_boot_f, "BOOT 6: player create end"); file_text_writeln(_boot_f); file_text_close(_boot_f) // BOOT-DEBUG
