with(game_controller) {
	// the smallest combo_count is 2 (double kill)
	if (combo_count >= global.minimum_combo && !is_scene_transitioning && !is_selecting_ult) {
		var _phrase = global.combo_phrases[min(array_length(global.combo_phrases) - 1, combo_count - global.minimum_combo)]
		var _combo_y = global.ycenter - 200
		var _combo_width = global.xcenter // shorthand for half the room width
	
		draw_set_color(global.combo_color)
		draw_set_font(fnt_title)
		draw_text_with_alignment(global.xcenter, _combo_y, string_concat(_phrase, " -- ", combo_count, "X"), ALIGN_CENTER)
	
		draw_progress_bar(global.xcenter - _combo_width / 2, _combo_y + 20, global.xcenter + _combo_width / 2, _combo_y + 26, alarm[2] / combo_max_alarm, global.combo_color, global.bg_color)
		draw_set_color(c_white)
	}
}