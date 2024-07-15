if (target_location) {
	var _target_direction = point_direction(x,y, target_location.x, target_location.y)
	var _dif = angle_difference(_target_direction, target_direction)
	target_direction += _dif * .015
}

var _wobble_step = (get_play_time() - spawn_time) % wobble_frequency
var _direction_shift =  sin(2 * pi * _wobble_step / wobble_frequency) * wobble_amplitude

debug(_wobble_step, _direction_shift)

direction = target_direction + _direction_shift
