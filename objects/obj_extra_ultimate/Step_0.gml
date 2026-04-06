/// @description tip_step
if (global.paused) {
	return
}

my_bounds = get_bounds_for_instance(self)
tip_step(self)

// Update pulse animation
if (pulse_scale >= max_pulse_scale) {
	// Rapidly shrink back to 1x
	pulse_scale = 1
	// Draw shockwave at position
	instance_create_layer(x,y, LAYER_BG_EFFECTS, obj_expanding_ring, {
		start_radius: max_pulse_scale * radius - 6, // 6 is half the stroke
		end_radius: 1.8 * radius,
		color: global.ultimate_colors[$ type],
		duration: 0.3,
		stroke: 12,
	})
} else {
	// Slowly grow
	pulse_scale += pulse_grow_speed * delta_time_seconds()
}