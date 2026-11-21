/// @description Fade and track
if (global.paused) {
	return
}

if (follow != noone && instance_exists(follow)) {
	x = follow.x
	y = follow.y
}

elapsed += step_seconds()
alpha = 1 - min(1, elapsed / duration)
if (alpha <= 0) {
	instance_destroy()
}
