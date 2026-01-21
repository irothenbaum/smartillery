var _radius = global.bg_circle_max_radius + global.oob_margin
var _starting_direction = point_direction(global.xcenter, global.ycenter, x, y)
var _flying_v_angle = 90
var _shift_angle = _flying_v_angle / 2
var _flying_v_distance = global.player_body_radius * 5
for (var _i = 0; _i < enemy_count; _i++ ) {
	var _dir = _starting_direction + (_shift_angle * (_i % 2 == 0 ? 1 : -1))
	var _distance = ceil(_i / 2) * _flying_v_distance 
	
	instance_create_layer(
		x + lengthdir_x(_distance, _dir), 
		y + lengthdir_y(_distance, _dir), 
		LAYER_INSTANCES, 
		obj_enemy_3
	) 
}

subscribe(self, EVENT_GAME_OVER, function() {
	instance_destroy()
})