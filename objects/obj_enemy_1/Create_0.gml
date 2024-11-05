enemy_initlaize(self, 10)
image_scale = 0.25
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

target_location_x = global.xcenter
target_location_y = global.ycenter
start_position_x = x
start_position_y = y
turning_towards = false
direction = point_direction(x, y, target_location_x, target_location_y) + (20 * (irandom(1) == 1 ? 1 : -1))
speed = approach_speed

function register_hit(_insta_kill) {
	var _game_controller = get_game_controller()
	_game_controller.release_answer(answer);
	_game_controller.handle_enemy_killed(self, _insta_kill)
	instance_destroy()
}