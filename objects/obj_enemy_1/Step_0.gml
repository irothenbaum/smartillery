if (global.paused) {
	return
}

image_angle += rotate_speed * slow_multiplier

// once we start turning we can never stop turning
turning_towards = turning_towards || point_distance(x, y, start_position_x, start_position_y) > global.bg_circle_magnitude * 0.75

if (turning_towards) {
	var _dif = angle_difference(point_direction(x,y, target_location_x, target_location_y), direction)
	direction += _dif * 0.015 * slow_multiplier
	
	speed += speed * 0.003
}
