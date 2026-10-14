event_inherited()
if (global.paused) {
	return
}

// Only start turning after traveling far enough from spawn point
if (point_distance(spawn_x, spawn_y, x, y) >= straight_travel_distance) {
	// Gradually turn towards the player using lerp-style interpolation
	direction -= angle_difference(direction, point_direction(x, y, global.xcenter, global.ycenter)) * turn_speed * slow_multiplier
}

// Keep image angle aligned with direction
image_angle = direction

// Accelerate up to max speed
var _max_speed = max_speed * slow_multiplier
if (speed < _max_speed) {
	speed = min(speed + acceleration * slow_multiplier, _max_speed)
}
