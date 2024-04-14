spawn_time = get_play_time()
shooting = false
fire_distance = 50
firing_position = undefined
equation = "";
answer = "";
speed = 0;
approach_speed = 1
point_value = 10

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_explode);
}

function register_hit() {
	get_enemy_controller().release_answer(answer);
	explode_and_destroy()
	get_game_controller().handle_enemy_killed(self)
}

function fire_shot() {
	get_player().execute_take_damage(50)
	alarm[0] = 2 * game_get_speed(gamespeed_fps)
}

enemy_initialize(self)