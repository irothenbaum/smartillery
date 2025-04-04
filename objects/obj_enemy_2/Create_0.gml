enemy_initlaize(self, 20)
_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
shooting = false
// fire at the center of third circle -- this should be less than ult_slow_get_radius(1)
fire_distance = get_radius_at_i(global.bg_number_of_circles - 3) - global.bg_circle_ring_width / 2
firing_position = undefined
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1
my_health = 1
recoil_amount = 0
max_recoil_amount = 10
shift_position = undefined
speed = approach_speed;

normal_color = c_white
stunned_color = c_red
normal_color_arr = color_to_array(normal_color)
stunned_color_arr = color_to_array(stunned_color)


// here we establish where we'll be heading and firing from
var _shifted_degrees = irandom_range(5, 30)
if (irandom(1) == 1) {
	// possibly shift counter clockwise
	_shifted_degrees = _shifted_degrees * -1
}
var _player_halo_direction = point_direction(global.xcenter, global.ycenter, x, y) + _shifted_degrees
firing_position = {
	x: global.xcenter + lengthdir_x(fire_distance, _player_halo_direction),
	y: global.ycenter + lengthdir_y(fire_distance, _player_halo_direction)
}


function register_hit(_insta_kill = false) {
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_2_damage});
	var _game_controller = get_game_controller()
	_game_controller.release_answer(answer);
	if (my_health > 0 && !_insta_kill) {
		my_health--;
		// pause the approach
		speed = 0
		equation = ""
		// restart approach in 3 seconds
		alarm[1] = 3 * game_get_speed(gamespeed_fps)
		alarm[0] = -1;
		var _dir_to_player = point_direction(global.xcenter, global.ycenter, x,y)
		shift_position = {
			x: x + lengthdir_x(20, _dir_to_player),
			y: y + lengthdir_y(20, _dir_to_player)
		}
		return
	}
	// my_health <= 0 || insta_kill
	_game_controller.handle_enemy_killed(self, _insta_kill)
	instance_destroy();
}

function fire_shot() {
	var _player = get_player()
	recoil_amount = max_recoil_amount
	_player.execute_take_damage(20)
	alarm[0] = 2 * game_get_speed(gamespeed_fps)
	
	// Muzzle Flash
	var _muzzle = get_turret_muzzle()
	instance_create_layer(_muzzle.x, _muzzle.y, LAYER_INSTANCES, obj_muzzle_flash, {target_x: global.xcenter, target_y: global.ycenter, width: 4, color: c_red})
}

function get_turret_muzzle() {
	// this is hardcoded, but somehow a property of the turret sprite size * image_scale
	var _turret_length = 20
	return {
		x: x + lengthdir_x(_turret_length, image_angle),
		y: y + lengthdir_y(_turret_length, image_angle)
	}
}