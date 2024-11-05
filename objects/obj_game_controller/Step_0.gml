if (keyboard_check_pressed(vk_escape)) {
	if (!is_ulting() && !is_selecting_ult) {
		toggle_pause()
		
		if (global.paused) {
			tutorial = instance_create_layer(x,y, LAYER_HUD, obj_tutorial_overlay)
		} else {
			instance_destroy(tutorial)
		}
	} else {
		debug("Cannot pause during ult or selection")
	}
}
