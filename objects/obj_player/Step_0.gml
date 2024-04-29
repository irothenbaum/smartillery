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
	