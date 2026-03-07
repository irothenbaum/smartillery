enemy_step(self)
tip_step(self)
if (global.paused) {
	return
}

image_angle += rotate_speed * slow_multiplier

if (array_length(waypoints) > 0) {
	var _target = waypoints[0]
	var _dist = point_direction(x, y, _target.x, _target.y)

	// Add curve offset based on distance to waypoint
	// Use waypoint position as seed for deterministic curve direction
	var _curve_seed = floor(_target.x + _target.y * 1000)
	var _curve_dir = ((_curve_seed mod 2) == 0) ? 1 : -1
	var _distance_to_target = point_distance(x, y, _target.x, _target.y)
	var _curve_strength = min(1, _distance_to_target / 200) * 25 * _curve_dir

	direction -= angle_difference(direction, _dist + _curve_strength) * 0.05;

	// when we're close to a waypoint, we shift it off
	if (_distance_to_target < global.margin_md) {
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
