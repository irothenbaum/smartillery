
// the smallest combo_count is 2 (double kill)
if (last_combo >= global.minimum_combo && !game_controller.is_selecting_ult) {
	var _phrase = global.combo_phrases[min(array_length(global.combo_phrases) - 1, other.last_combo - global.minimum_combo)]
	var _combo_y = global.ycenter + 200
	var _combo_width = global.xcenter // shorthand for half the room width
	
	draw_set_composite_color(composite_color(global.combo_color, image_alpha))
	draw_set_font(fnt_title)
	draw_text_with_alignment(global.xcenter, _combo_y, string_concat(_phrase, " -- ", other.last_combo, "X"), ALIGN_CENTER)
	
	draw_progress_bar(
		global.xcenter - _combo_width / 2, 
		_combo_y + 20, 
		global.xcenter + _combo_width / 2, 
		_combo_y + 26,
		game_controller.alarm[2] / game_controller.combo_max_alarm,
		composite_color(global.combo_color, 1 * other.image_alpha),
		composite_color(c_black, 0.3 * other.image_alpha) 
	)
	reset_composite_color()
}
