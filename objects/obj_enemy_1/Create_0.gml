spawn_time = current_time
equation = "";
speed = 0;
time_to_solve = 20
remaining_time_to_solve = time_to_solve
approach_speed = 1
needed_rest = 0
point_value = 10


function register_hit(_answer) {
	instance_destroy();
	instance_create_layer(x, y, "Instances", obj_fx_explosion);
	get_enemy_controller().handle_enemy_killed(self)
}
