enemy_step(self)
if (global.paused) {
	return
}

image_angle += rotate_speed * slow_multiplier

if (array_length(waypoints) > 0) {
	var _target = waypoints[0]
	direction -= angle_difference(direction, point_direction(x, y, _target.x, _target.y)) * 0.05;
	
	// when we close to a waypoint, we shift it off
	if (point_distance(x, y, _target.x, _target.y) < global.margin_md) {
		array_shift(waypoints)
	}
} else {
	direction -= angle_difference(direction, point_direction(x, y, global.xcenter, global.ycenter)) * 0.05;
	// accelerate to speed 5
	speed = lerp(speed, 5, 0.03)
	rotate_speed = lerp(rotate_speed, 12, 0.08)
	
	// as a failsafe, we'll aim directly for the player 3 seconds after making our final turn
	if (!(alarm[0] > 0)) {
		alarm[0] = 3 * game_get_speed(gamespeed_fps)
	}
}
