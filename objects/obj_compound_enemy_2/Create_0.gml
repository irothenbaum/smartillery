// this 100 matches the Out of Bounds margin in Enemy_controller, but ig it doesn't have to...
var _radius = global.bg_circle_max_radius + 100
var _dir_step = 360 / enemy_count
var _starting_shift = 90 * roll_dice(4)
for (var _i = 0; _i < enemy_count; _i++ ) {
	var _dir = _starting_shift + (_dir_step * _i)
	
	instance_create_layer(
		global.xcenter + lengthdir_x(_radius, _dir), 
		global.ycenter + lengthdir_y(_radius, _dir), 
		LAYER_INSTANCES, 
		obj_enemy_2
	) 
}

subscribe(EVENT_GAME_OVER, function() {
	instance_destroy()
})