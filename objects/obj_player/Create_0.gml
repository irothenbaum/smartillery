  _u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
recoil_amount = 0
max_recoil_amount = 20
hide_self = false;

body_color_arr = color_to_array(global.body_color)
turret_color_arr = color_to_array(global.turret_color)

rotate_aim_speed = 720 // in degrees per second
rotate_idle_speed = 90 // in degrees per second
rotate_speed = rotate_idle_speed
rotate_to = 90;
my_health = global.max_health
aiming_at_instance = undefined
image_angle = rotate_to;
direction = 90 // point upwards
x = room_width / 2
x = room_width / 2
y = room_height / 2

image_scale = 0.4
image_xscale = image_scale;
image_yscale = image_scale;

screen_shake = instance_create_layer(x,y, LAYER_INSTANCES, obj_screen_shake)

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
	aiming_at_instance = undefined
	
	// after a few seconds, reset to vertical postion
	alarm[0] = game_get_speed(gamespeed_fps) * 3
}

function execute_take_damage(_damage_amount) {
	my_health -= _damage_amount
	
	// any damage resets the streak
	streak = 0
	
	if (my_health <= 0) {
		get_game_controller().handle_game_over()
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

function get_turret_muzzle() {
	// this is hardcoded, but somehow a property of the turret sprite size * image_scale
	var _turret_length = 50
	return {
		x: x + lengthdir_x(_turret_length, image_angle),
		y: y + lengthdir_y(_turret_length, image_angle)
	}
}