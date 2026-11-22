// the camera is set in rm_main_menu's creation code, after Create, so follow the player from here
update_position()


if (!is_undefined(shake_elapsed)) {
	shake_elapsed += step_seconds() * 1000
	// stop once the shake is done, or as soon as they start typing again
	if (shake_elapsed >= total_shake_time || string_length(message) > 0) {
		stop_shake()
	}
}

if (global.focused_input == self) {
	if(keyboard_check_pressed(vk_enter)) {
		keyboard_string = "";
		var _guess = message
	
		if (!select_button_by_label()) {
			message = ""
			if (string_length(_guess) > 0) {
				start_shake(_guess)
			}
			// below the input, kept on screen (the input is near the right edge)
			var _hint = "Enter a button to select it"
			draw_set_font(fnt_title)
			var _hint_x = min(x, display_get_gui_width() - (string_width(_hint) / 2) - global.margin_lg)
			// replace any hint still showing from an earlier miss
			if (instance_exists(hint)) {
				instance_destroy(hint)
			}
			// shown while the box shakes, then fades out
			// at the input's own depth, so it draws wherever the input does (e.g. over the pause screen's dimming)
			hint = instance_create_depth(_hint_x, y + hint_offset_y, depth, obj_text_title, {
				message: _hint,
				duration: total_shake_time / 1000,
				fade_duration: hint_fade_duration,
				align: ALIGN_CENTER
			})
		}
	} else {
		message = string_lower(keyboard_string);
	}
}

// the placeholder: once the box is emptied after having text (typed then erased, or submitted), it starts over --
// wait, then type itself out again
if (string_length(message) > 0) {
	had_text = true
} else if (had_text) {
	had_text = false
	restart_placeholder()
}
if (placeholder_chars < string_length(placeholder)) {
	placeholder_timer -= step_seconds()
	if (placeholder_timer <= 0) {
		placeholder_chars++
		placeholder_timer = get_next_placeholder_delay()
	}
}
