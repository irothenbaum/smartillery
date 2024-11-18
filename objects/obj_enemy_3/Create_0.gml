enemy_initlaize(self, 30)
_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
max_speed = 4;
shift_position = undefined
starting_speed = 0.1
speed = starting_speed
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
my_health = 2
is_paused = false

normal_color = c_white
stunned_color = c_red
normal_color_arr = color_to_array(normal_color)
stunned_color_arr = color_to_array(stunned_color)

direction = point_direction(x, y, global.xcenter, global.ycenter)

function register_hit(_insta_kill=false) {
	var _game_controller = get_game_controller()
	
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_3_damage});
	_game_controller.release_answer(answer);
	if (my_health > 0 && !_insta_kill) {
		my_health--;
		// pause the approach
		speed = 0
		// stun for 6 seconds
		alarm[0] = 6 * game_get_speed(gamespeed_fps)
		enemy_generate_question(self)
		shift_position = {
			// we do - instead of + so it goes backwards
			x: x - lengthdir_x(100, direction),
			y: y - lengthdir_y(100, direction)
		}
		return
	}
	
	// my_health <= 0 || insta_kill
	_game_controller.handle_enemy_killed(self, _insta_kill)
	instance_destroy();
}

function collide_with_player() {
	get_player().execute_take_damage(40)
	instance_destroy();
}
