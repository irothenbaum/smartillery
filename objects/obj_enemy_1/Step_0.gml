enemy_step(self)
if (global.paused) {
	return
}

image_angle += rotate_speed * slow_multiplier

// once we start turning we can never stop turning
turning_towards = turning_towards || point_distance(x, y, start_position_x, start_position_y) > global.bg_circle_magnitude * 0.70

if (turning_towards) {
	direction -= angle_difference(direction, point_direction(x, y, target_location_x, target_location_y)) * 0.05;
	speed = lerp(speed, 5, 0.05)
}
