/// @description Fire at enemies in range
tip_step(self)
if (global.paused) {
	return
}

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.85
} else {
	recoil_amount = 0
}

// grow the range indicator (ease out so it decelerates into its full size)
if (range_grow_progress < 1) {
	range_grow_progress = min(1, range_grow_progress + step_seconds() / range_grow_duration)
	display_range = range * (1 - power(1 - range_grow_progress, 2))
}

var _target = find_target()
if (_target == noone) {
	// idle: spin slowly
	image_angle = (image_angle + rotate_idle_speed * step_seconds()) mod 360
} else {
	// turn toward the target without snapping, and fire once we're facing it
	var _angle_dif = angle_difference(point_direction(x, y, _target.x, _target.y), image_angle)
	var _rotate_step = rotate_aim_speed * step_seconds()
	image_angle += sign(_angle_dif) * min(abs(_angle_dif), _rotate_step)

	if (can_fire && abs(_angle_dif) <= max(aim_tolerance, _rotate_step)) {
		fire_at(_target)
	}
}
