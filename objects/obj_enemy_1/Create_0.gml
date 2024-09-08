enemy_initlaize(self, 10)
image_scale = 0.25
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

var _player = get_player();
var _scale = irandom(1) == 0 ? -1 : 1
target_location_x = _player.x
target_location_y = _player.y
start_position_x = x
start_position_y = y
turning_towards = false
direction = point_direction(x, y, target_location_x, target_location_y) +  30 // * _scale
speed = approach_speed

function register_hit(_insta_kill) {
	debug("REGISTER HIT", self)
	get_enemy_controller().release_answer(answer);
	get_game_controller().handle_enemy_killed(self, _insta_kill);
	instance_destroy();
}