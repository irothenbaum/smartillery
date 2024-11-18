_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
recoil_amount = 0
max_recoil_amount = 20
hide_self = false;

body_color_arr = color_to_array(global.body_color)
turret_color_arr = color_to_array(global.turret_color)
power_color = color_to_array(global.power_color)

rotate_aim_speed = 720 // in degrees per second
rotate_idle_speed = 90 // in degrees per second
rotate_speed = rotate_idle_speed
rotate_to = 90;
my_health = global.max_health
aiming_at_instance = undefined
image_angle = rotate_to;
direction = 90 // point upwards
x = global.xcenter
y = global.ycenter

image_scale = 0.16
image_xscale = image_scale;
image_yscale = image_scale;

screen_shake = instance_create_layer(x,y, LAYER_INSTANCES, obj_screen_shake)
streak_fire = undefined

function fire_at_instance(_inst) {
	if (!_inst) {
		// do nothing
		return
	}
	alarm[0] = -1
	aiming_at_instance = _inst
	rotate_speed = rotate_aim_speed;
	rotate_to = point_direction(x, y, _inst.x, _inst.y);
}

function execute_hit_target() {
	if (not aiming_at_instance) {
		debug("This shouldn't happen -- execute_hit_target -> not aiming_at_instance")
		return
	}
	
	// Muzzle Flash
	var _muzzle = get_turret_muzzle()
	var _on_streak = get_game_controller().has_point_streak()
	instance_create_layer(_muzzle.x, _muzzle.y, LAYER_INSTANCES, obj_muzzle_flash, {target_x: aiming_at_instance.x, target_y: aiming_at_instance.y, width: _on_streak ? 16 : 12, color: _on_streak ? global.power_color : global.beam_color})
	
	recoil_amount = max_recoil_amount
	aiming_at_instance.register_hit()
	broadcast(EVENT_ENEMY_DAMAGED, aiming_at_instance)
	aiming_at_instance = undefined
	
	// after a few seconds, reset to vertical postion
	alarm[0] = game_get_speed(gamespeed_fps) * 3
}

function execute_take_damage(_damage_amount) {
	my_health -= _damage_amount
	
	// any damage resets the streak
	streak = 0
	
	if (my_health <= 0) {
		aiming_at_instance = undefined
		if (!is_undefined(streak_fire)) {
			destroy_particle(streak_fire.system)
		}
		get_game_controller().end_game()
	}
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_shockwave})
	
   with (screen_shake)
   {
      shake = true;
      shake_time = 0.2 * game_get_speed(gamespeed_fps);
      shake_magnitude = 4;
      shake_fade = 0.5;
   }
}

function get_turret_muzzle(_extra = 0) {
	return {
		x: x + lengthdir_x(global.turret_length + _extra, image_angle),
		y: y + lengthdir_y(global.turret_length + _extra, image_angle)
	}
}

subscribe(EVENT_ON_OFF_STREAK, function(_is_on_streak) {
	if (_is_on_streak) {
		streak_fire = draw_muzzle_smoke(x, y, global.power_color)
	} else {	
		if (is_undefined(streak_fire)) {
			return
		}
		destroy_particle(streak_fire.system)
		streak_fire = undefined
	}
})

subscribe(EVENT_TOGGLE_PAUSE, function(_status) {
	if (!is_undefined(streak_fire)) {
		pause_particle(streak_fire.system, _status)
	}
})