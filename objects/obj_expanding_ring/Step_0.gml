/// @description Insert description here
if (global.paused) {
	return
}

elapsed += step_seconds()

if (elapsed > duration) {
	instance_destroy()
	return
}