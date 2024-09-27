next_combo = game_controller.combo_count
if (next_combo != last_combo) {
	if (next_combo == 0) {
		decrease_opacity = true
	}
	
	if (!decrease_opacity ) {
		last_combo = next_combo
		image_alpha = 1
	}
}
if (decrease_opacity) {
	image_alpha = image_alpha * 0.8;
	
	if (image_alpha < 0.02) {
		last_combo = 0
		decrease_opacity = false
	}
}