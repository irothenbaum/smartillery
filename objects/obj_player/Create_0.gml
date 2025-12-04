_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
recoil_amount = 0
max_recoil_amount = 20
hide_self = false;

game_controller = get_game_controller()
body_color_arr = color_to_array(global.body_color)
turret_color_arr = color_to_array(global.turret_color)
my_color = get_my_color()
my_color_arr = color_to_array(my_color)

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

function rotate_towards_next_target() {
	if (array_length(aiming_at_instance) > 0) {
		rotate_speed = rotate_aim_speed;
		var _target = aiming_at_instance[0].inst 
		rotate_to = point_direction(x, y, _target.x, _target.y)
		
		broadcast(EVENT_NEW_TURRET_ANGLE, {
			rotate_to: rotate_to,
			rotate_speed: rotate_speed,
		})
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
	array_push(aiming_at_instance, {
		inst : _inst,
		player_id: _player_id
	})
	rotate_towards_next_target()
}

function execute_hit_target() {
	if (array_length(aiming_at_instance) == 0) {
		debug("This shouldn't happen -- execute_hit_target -> not aiming_at_instance")
		return
	}
	
	var _target_entry = array_shift(aiming_at_instance)
	var _target = _target_entry.inst
	var _player_who_shot_id = _target_entry.player_id
	
	// Muzzle Flash
	var _muzzle = get_turret_muzzle()
	var _on_streak = game_controller.has_point_streak(_player_who_shot_id)
	var _flash_variables = {
		target_x: _target.x, 
		target_y: _target.y, 
		width: _on_streak ? global.beam_width_lg : global.beam_width, 
		color: _on_streak ? get_player_color(_player_who_shot_id) : global.beam_color
	}
	instance_create_layer(_muzzle.x, _muzzle.y, LAYER_INSTANCES, obj_muzzle_flash, _flash_variables)
	
	if (game_controller.is_ult_active(ULTIMATE_COLLATERAL)) {
		// override color, default to ult color if not fired by a player on streak
		_flash_variables.color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_COLLATERAL]
		instance_create_layer(_muzzle.x, _muzzle.y, LAYER_INSTANCES, obj_electric_beam, _flash_variables)
	}
	
	if (game_controller.is_ult_active(ULTIMATE_ASSIST)) {
	}
	
	recoil_amount = max_recoil_amount
	
	_target.last_hit_by_player_id = _player_who_shot_id
	_target.register_hit()
	broadcast(EVENT_ENEMY_HIT, _target, _player_who_shot_id)
	
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
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_shockwave})
	
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

subscribe(self, EVENT_ON_OFF_STREAK, function(_streak_count) {
	if (_streak_count >= global.point_streak_requirement) {
		if (is_undefined(streak_fire)) {
			streak_fire = draw_muzzle_smoke(x, y, my_color)
		}
	} else {
		// not on streak, remove the fire if we have it
		if (is_undefined(streak_fire)) {
			return
		}
		destroy_particle(streak_fire.system)
		streak_fire = undefined
	}
})

subscribe(self, EVENT_TOGGLE_PAUSE, function(_status) {
	if (!is_undefined(streak_fire)) {
		pause_particle(streak_fire.system, _status)
	}
})