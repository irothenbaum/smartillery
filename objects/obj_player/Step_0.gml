// image_angle += sin(degtorad(rotate_to - image_angle)) * rotate_speed;
var _angle_dif = angle_difference(rotate_to, image_angle)
var _abs_angle_dif = abs(_angle_dif)
var _rotate_step = rotate_speed / game_get_speed(gamespeed_fps)
debug(_angle_dif, _abs_angle_dif, _rotate_step)
image_angle += sign(_angle_dif) * (_abs_angle_dif < _rotate_step ? _abs_angle_dif : _rotate_step)

// start the fire animation if we're within 5 degrees of our target
if (aiming_at_instance && _abs_angle_dif < 5) {
	execute_hit()
}