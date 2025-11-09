
// the smallest combo_count is 2 (double kill)
if (last_combo >= global.minimum_combo) {
	var _phrase = global.combo_phrases[min(array_length(global.combo_phrases) - 1, other.last_combo - global.minimum_combo)]
	var _input_bounds = player_input.my_bounds
	var _combo_y = _input_bounds.y1 + global.margin_md
	var _combo_x = _input_bounds.x0
	var _combo_width = _input_bounds.width
	
	var _fill_color = new CompositeColor(color, image_alpha)
	var _bar_color = new CompositeColor(c_black, 0.3 * image_alpha)
	
	draw_set_composite_color(_fill_color)
	draw_set_font(fnt_base)
	var _text_bounds = draw_text_with_alignment(_combo_x + (_combo_width / 2), _combo_y, string_concat(_phrase, " -- ", other.last_combo, "X"), ALIGN_CENTER)
	
	draw_progress_bar(
		_combo_x, 
		_combo_y + _text_bounds.y1 + global.margin_sm,
		_combo_x + _combo_width, 
		_combo_y + _text_bounds.y1 + global.margin_sm + 6, // 6px tall bar
		game_controller.alarm[game_controller.get_combo_alarm_for_player_id(owner_player_id)] / game_controller.combo_max_alarm,
		_fill_color,
		_bar_color
	)
	reset_composite_color()
}
