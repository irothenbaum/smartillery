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

if (is_despawning) {
	despawn_elapsed += step_seconds()

	// collapse the range (ease in -- the mirror of the spawn's ease out)
	var _range_progress = min(1, despawn_elapsed / range_shrink_duration)
	display_range = despawn_start_range * (1 - power(_range_progress, 2))

	// then, after a short pause, shrink the turret itself
	var _sprite_progress = clamp((despawn_elapsed - range_shrink_duration - sprite_shrink_delay) / sprite_shrink_duration, 0, 1)
	sprite_scale = 1 - power(_sprite_progress, 2)

	// keep idling while we despawn, but don't target or fire anymore
	image_angle = (image_angle + rotate_idle_speed * step_seconds()) mod 360

	if (_sprite_progress >= 1) {
		instance_destroy()
	}
	return
}

// extend the barrel out of the body (ease out so it decelerates into its full length), then hold off on
// everything else until it's out
if (barrel_grow_progress < 1) {
	barrel_grow_progress = min(1, barrel_grow_progress + step_seconds() / barrel_grow_duration)
	barrel_extend = 1 - power(1 - barrel_grow_progress, 3)
	return
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
