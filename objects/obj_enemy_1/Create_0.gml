spawn_time = get_play_time()
shooting = false
equation = "";
answer = "";
speed = 0;
image_xscale = 0.25
image_yscale = 0.25
approach_speed = 1.2
point_value = 10
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

var _player = get_player();
var _scale = irandom(1) == 0 ? -1 : 1
target_location_x = _player.x
target_location_y = _player.y
start_position_x = x
start_position_y = y
turning_towards = false
direction = point_direction(x, y, target_location_x, target_location_y) +  30 // * _scale


function explode_and_destroy() {
	instance_destroy();
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_damage);
	instance_create_layer(x, y, LAYER_INSTANCES, obj_fx_enemy_explode);
	get_game_controller().handle_enemy_killed(self)
}

function register_hit() {
	get_enemy_controller().release_answer(answer);
	explode_and_destroy()
}

function collide_with_player() {
	get_player().execute_take_damage(35)
	explode_and_destroy()
}

function collide_with_explosion() {
	register_hit()
}

enemy_initialize(self)