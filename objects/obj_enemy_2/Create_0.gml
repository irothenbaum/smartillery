spawn_time = current_time
equation = "";
speed = 0;
time_to_solve = 30
remaining_time_to_solve = time_to_solve
approach_speed = 1
needed_rest = 0
point_value = 20

health = 1

function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_explode);
}

function register_hit(_insta_kill = false) {
	if (health > 0 && !_insta_kill) {
		health--;
		enemy_generate_question(self)
		instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_damage);
		// force stop for 1 second
		enemy_stop_approach(self, 1)
		return
	}
	explode_and_destroy()
	get_game_controller().handle_enemy_killed(self)
}

function handle_hit_player() {
	explode_and_destroy()
	get_game_controller().handle_player_damaged(self)
}