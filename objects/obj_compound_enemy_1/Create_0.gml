var _waypoint_1 = get_tangent_point(x, y, global.xcenter, global.ycenter, global.room_height * 0.5)
var _waypoint_2 = get_tangent_point(_waypoint_1.x, _waypoint_1.y, global.xcenter, global.ycenter, global.room_height * 0.5)

waypoints = [
	_waypoint_1,
	_waypoint_2
]

alarm[0] = 1

function spawn_enemy() {
	var _e = instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_1)
	with(_e) {
		set_waypoints(other.waypoints)
	}
	enemy_count--;
}

subscribe(EVENT_GAME_OVER, function() {
	instance_destroy()
})