// all enemies must implement these private variables:
spawn_time = get_play_time()
equation = "";
speed = 1
point_value = 10
image_scale = 0.25
image_xscale = image_scale
image_yscale = image_scale

var _player = get_player();
direction = point_direction(x, y, _player.x, _player.y)

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_3_destroy});
	get_game_controller().handle_enemy_killed(self)
}

function register_hit(_insta_kill=false) {
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_2_damage});
	
	if (_insta_kill) {
		point_value = 2 * point_value
	} else {
		// we spawn the 3 fragments
		instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_4_fragment, {direction: direction + 90});
		instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_4_fragment, {direction: direction - 90});
		instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_4_fragment, {direction: direction + 180});
	}
	
	get_enemy_controller().release_answer(answer);
	explode_and_destroy()
}

function collide_with_player() {
	get_player().execute_take_damage(50)
	explode_and_destroy()
}

enemy_generate_question(self)