// might be fun to make this configurable
game_seed = 132435345;
random_set_seed(game_seed);

current_wave = 0;
global.score = 0;

function mark_wave_completed() {
	if (get_enemy_controller()) {	
		instance_destroy(get_enemy_controller())
	}
	current_wave++;
	var _controller = instance_create_layer(x, y, "Instances", obj_enemy_controller);
	with (_controller) {
		init_wave(other.current_wave)
	}
}


mark_wave_completed();