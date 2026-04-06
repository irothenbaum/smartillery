/// @description Insert description here
if (global.paused) {
	return
}

elapsed += delta_time_seconds()

if (elapsed > duration) {
	instance_destroy()
	return
}