if (global.paused) {
	return
}

var _angle_dif = angle_difference(rotate_to, image_angle)
var _abs_angle_dif = abs(_angle_dif)
var _rotate_step = rotate_speed / game_get_speed(gamespeed_fps)

image_angle += sign(_angle_dif) * (_abs_angle_dif < _rotate_step ? _abs_angle_dif : _rotate_step)

// start the fire animation if we're within 5 degrees of our target
if (aiming_at_instance && _abs_angle_dif < 1) {
	execute_hit_target()
}

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.85
} else {
	recoil_amount = 0
}

if (!is_undefined(streak_fire)) {
	var _muzzle_position = get_turret_muzzle(10 - recoil_amount)
	part_type_direction(streak_fire.type, image_angle, image_angle, 0, 40);
	part_system_position(streak_fire.system, _muzzle_position.x, _muzzle_position.y)
}
