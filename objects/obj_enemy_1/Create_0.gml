enemy_initlaize(self, global.points_enemy_1)
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

turning_towards = false

// if waypoints wasn't set for us, we initialize
if (is_undefined(waypoints)) {	
	waypoints = [get_tangent_point(x,y, global.xcenter, global.ycenter, global.room_height * 0.2)]
}

direction = point_direction(x, y, global.xcenter, global.ycenter) + (20 * (irandom(1) == 1 ? 1 : -1))
speed = approach_speed

function register_hit() {
	instance_destroy()
}
broadcast(EVENT_ENEMY_SPAWNED, self)