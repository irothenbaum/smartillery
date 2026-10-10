/// @description Expand and destroy enemies
if (global.paused) {
	return
}

elapsed += delta_time_seconds()

if (elapsed < expand_duration) {
	// ease out so the wave bursts out quickly then settles at the edge
	var _progress = 1 - power(1 - (elapsed / expand_duration), 2)
	current_radius = lerp(start_radius, end_radius, _progress)
} else {
	current_radius = end_radius
}

destroy_enemies_in_radius(current_radius)

if (elapsed > expand_duration + fade_duration) {
	instance_destroy()
}
