enemy_initlaize(self, global.points_enemy_4_fragment)
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
speed = 2
wobble_frequency = 1500
wobble_amplitude = 30
target_location = undefined
target_direction = direction
target_delay = (irandom_range(500,2000) / 1000) * game_get_speed(gamespeed_fps)
alarm[0] = target_delay

function register_hit(_insta_kill=false) {
	instance_destroy();
}

broadcast(EVENT_ENEMY_SPAWNED, self)