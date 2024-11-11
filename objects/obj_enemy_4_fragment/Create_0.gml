enemy_initlaize(self, 10)
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
speed = 2
wobble_frequency = 1500
wobble_amplitude = 30
target_location = undefined
target_direction = direction
alarm[0] = (irandom_range(500,2000) / 1000) * game_get_speed(gamespeed_fps)

function register_hit(_insta_kill=false) {
	var _game_controller = get_game_controller()
	_game_controller.release_answer(answer);
	_game_controller.handle_enemy_killed(self, _insta_kill)
	instance_destroy();
}

