if (wave_ready) {
	var _controller = instance_create_layer(x, y, "Instances", obj_enemy_controller);
	with (_controller)
	{
		// TODO: probably shouldn't JUST be a wave count, maybe something more complicated
	    wave_number = other.wave;
	}
	wave_ready = false;
}