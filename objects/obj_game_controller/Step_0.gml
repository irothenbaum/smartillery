if (wave_ready) {
	wave_ready = false;
	var _controller = instance_create_layer(x, y, "Instances", obj_enemy_controller);
	with (_controller) {
		init_wave(other.current_wave)
	}
}