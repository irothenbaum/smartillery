if (global.paused) {
	return
}

if (speed < max_speed) {
	speed *= 1.01
} else {
	speed = max_speed
}