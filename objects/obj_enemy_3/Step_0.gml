if (global.paused) {
	return
}

var _max_speed = max_speed * slow_multiplier

if (speed < _max_speed) {
	speed *= 1.01
} else {
	speed = _max_speed
}