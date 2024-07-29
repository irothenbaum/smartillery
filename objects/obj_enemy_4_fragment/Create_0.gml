enemy_initlaize(self, 10)
image_scale = 0.25
image_xscale = image_scale
image_yscale = image_scale
speed = 2
wobble_frequency = 1500
wobble_amplitude = 30
target_location = undefined
target_direction = direction
alarm[0] = (irandom_range(500,2000) / 1000) * game_get_speed(gamespeed_fps)


function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_1_destroy});
}

function register_hit(_insta_kill=false) {
	get_enemy_controller().release_answer(answer);
	get_game_controller().handle_enemy_killed(self)
	explode_and_destroy()
}

function collide_with_player() {
	get_player().execute_take_damage(15)
	explode_and_destroy()
}

