spawn_time = get_play_time()
shooting = false
fire_distance = 100
firing_position = undefined
equation = "";
speed = 0;
image_xscale = 0.5
image_yscale = 0.5
approach_speed = 0.75
point_value = 20
my_health = 1
recoil_amount = 0
max_recoil_amount = 10

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_explode);
	get_game_controller().handle_enemy_killed(self)
}

function register_hit(_insta_kill = false) {
	get_enemy_controller().release_answer(answer);
	if (my_health > 0 && !_insta_kill) {
		my_health--;
		enemy_generate_question(self)
		instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_damage);
		alarm[1] = 3 * game_get_speed(gamespeed_fps)
		alarm[0] = -1;
		return
	}
	// my_health <= 0 || insta_kill
	explode_and_destroy()
}

function fire_shot() {
	debug("FIRE!")
	recoil_amount = max_recoil_amount
	get_player().execute_take_damage(20)
	alarm[0] = 2 * game_get_speed(gamespeed_fps)
}

enemy_initialize(self)