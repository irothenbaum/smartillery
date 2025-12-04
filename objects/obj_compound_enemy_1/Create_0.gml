waypoints = [
	get_tangent_point(x, y, global.xcenter, global.ycenter, global.room_height * 0.4),
]

debug("Waypoint count is ", waypoint_count)

do {
	var _last_waypoint = waypoints[array_length(waypoints) - 1]
	array_push(waypoints, get_tangent_point(_last_waypoint.x, _last_waypoint.y, global.xcenter, global.ycenter, global.room_height * 0.4))
	waypoint_count--
} until(waypoint_count == 0) 

alarm[0] = 1

function spawn_enemy() {
	var _e = instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_1, {
		waypoints: array_copy_all(waypoints)
	})
	enemy_count--;
}

subscribe(self, EVENT_GAME_OVER, function() {
	instance_destroy()
})