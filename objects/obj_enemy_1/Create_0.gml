enemy_initlaize(self, 10)
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

turning_towards = false

waypoints = [get_tangent_point(x,y, global.xcenter, global.ycenter, global.room_height * 0.2)]

direction = point_direction(x, y, global.xcenter, global.ycenter) + (20 * (irandom(1) == 1 ? 1 : -1))
speed = approach_speed

function set_waypoints(_w) {
	waypoints = []
	array_copy(waypoints, 0, _w, 0, array_length(_w))
	
	debug("HAS WWAYPOINTS", waypoints)
}

function register_hit(_insta_kill) {
	var _game_controller = get_game_controller()
	_game_controller.release_answer(answer);
	_game_controller.handle_enemy_killed(self, _insta_kill)
	instance_destroy()
}
