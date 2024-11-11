enemy_step(self)
if (global.paused) {
	return
}

if (target_location) {
	var _target_direction = point_direction(x,y, target_location.x, target_location.y)
	var _dif = angle_difference(_target_direction, target_direction)
	target_direction += _dif * .015 * slow_multiplier
}

// TODO: not sure if wobble_frequency needs slow_multiplier applied as well...
var _wobble_step = (get_play_time() - spawn_time) % wobble_frequency
var _direction_shift =  sin(TAU * _wobble_step / wobble_frequency) * wobble_amplitude

direction = target_direction + (_direction_shift * slow_multiplier)
