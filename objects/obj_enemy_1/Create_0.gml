spawn_time = get_play_time()
shooting = false
fire_distance = 50
firing_position = undefined
equation = "";
answer = "";
speed = 0;
image_xscale = 0.5
image_yscale = 0.5
approach_speed = 1
point_value = 10
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_explode);
	get_game_controller().handle_enemy_killed(self)
}

function register_hit() {
	get_enemy_controller().release_answer(answer);
	explode_and_destroy()
}

function fire_shot() {
	get_player().execute_take_damage(35)
	explode_and_destroy()
}

enemy_initialize(self)