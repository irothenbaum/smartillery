if (global.paused) {
	return
}

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.85
} else {
	recoil_amount = 0
}

if (!is_undefined(shift_position)) {
	x = (x + shift_position.x) / 2
	y = (y + shift_position.y) / 2
}

image_angle = point_direction(x, y, global.x_center, global.y_center)	

var _distance_to_firing = distance_to_point(firing_position.x, firing_position.y)

// once we start shooting we won't stop
if(shooting || _distance_to_firing < 10) {	
	if (!shooting) {
		speed = 0
		shooting = true
		alarm[0] = 2 * game_get_speed(gamespeed_fps)
	}
	
	var _diff = angle_difference(image_angle + 90, direction);
	direction += _diff * 0.025;
} else {
	direction = point_direction(x, y, firing_position.x, firing_position.y)
}