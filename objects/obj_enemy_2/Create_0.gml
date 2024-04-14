spawn_time = current_time
shooting = false
fire_distance = 100
firing_position = undefined
equation = "";
speed = 0;
approach_speed = 0.75
point_value = 20
my_health = 2

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_explode);
}

function register_hit(_insta_kill = false) {
	get_enemy_controller().release_answer(answer);
	if (my_health > 0 && !_insta_kill) {
		my_health--;
		enemy_generate_question(self)
		instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_damage);
		alarm[0] = 3 * game_get_speed(gamespeed_fps)
		return
	}
	explode_and_destroy()
	get_game_controller().handle_enemy_killed(self)
}

function fire_shot() {
	debug("FIRE!")
	get_player().execute_take_damage(100)
	alarm[0] = 2 * game_get_speed(gamespeed_fps)
}