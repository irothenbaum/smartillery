_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
// all enemies must implement these private variables:
spawn_time = get_play_time()
equation = "";
max_speed = 5;
shift_position = undefined
starting_speed = 0.2
speed = starting_speed
point_value = 10
image_scale = 0.25
image_xscale = image_scale
image_yscale = image_scale
my_health = 2

normal_color = color_to_array(c_white)
stunned_color = color_to_array(c_red)

var _player = get_player();
direction = point_direction(x, y, _player.x, _player.y)

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_3_destroy});
	get_game_controller().handle_enemy_killed(self)
}

function register_hit(_insta_kill=false) {
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_2_damage});
	get_enemy_controller().release_answer(answer);
	if (my_health > 0 && !_insta_kill) {
		my_health--;
		// pause the approach
		speed = 0
		// stun for 3 seconds
		alarm[0] = 3 * game_get_speed(gamespeed_fps)
		enemy_generate_question(self)
		shift_position = {
			// we do - instead of + so it goes backwards
			x: x - lengthdir_x(100, direction),
			y: y - lengthdir_y(100, direction)
		}
		return
	}
	
	// my_health <= 0 || insta_kill
	explode_and_destroy()
}

function collide_with_player() {
	get_player().execute_take_damage(40)
	explode_and_destroy()
}

enemy_generate_question(self)