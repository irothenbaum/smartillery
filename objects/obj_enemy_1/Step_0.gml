enemy_step(self)
if (global.paused) {
	return
}

image_angle += rotate_speed * slow_multiplier

if (array_length(waypoints) > 0) {
	direction -= angle_difference(direction, point_direction(x, y, waypoints[0].x, waypoints[1].y)) * 0.05;
	
	// when we close to a waypoint, we shit it off
	if (point_distance(x, y, waypoints[0].x, waypoints[0].y) < 20) {
		array_shift(waypoints)
	}
} else {
	direction -= angle_difference(direction, point_direction(x, y, global.xcenter, global.ycenter)) * 0.05;
	// accelerate to speed 5
	speed = lerp(speed, 5, 0.05)
}
