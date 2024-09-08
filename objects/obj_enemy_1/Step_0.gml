if (!global.paused) {
	image_angle += rotate_speed
}

// once we start turning we can never stop turning
turning_towards = turning_towards || point_distance(x, y, start_position_x, start_position_y) > room_width * 0.66

if (turning_towards) {
	var _dif = angle_difference(point_direction(x,y, target_location_x, target_location_y), direction)
	direction += _dif * .015
	
	speed = speed * 1.003
}
