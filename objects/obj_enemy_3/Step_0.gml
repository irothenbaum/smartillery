event_inherited()

if (global.paused) {
	return
}

var _max_speed = max_speed * slow_multiplier

if (speed < _max_speed) {
	speed *= 1 + 0.01 * slow_multiplier
} else {
	speed = _max_speed
}