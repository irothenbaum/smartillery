if (global.paused) {
	return
}

y = lerp(y, target_y, 0.25)

if (decrease_opacity) {
	image_alpha = image_alpha * 0.8;
	
	if (image_alpha < 0.02) {
		instance_destroy()
	}
}