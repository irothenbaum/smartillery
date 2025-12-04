
// the smallest combo_count is 2 (double kill)
if (last_combo >= global.minimum_combo) {
	var _phrase = global.combo_phrases[min(array_length(global.combo_phrases) - 1, other.last_combo - global.minimum_combo)]
	var _input_bounds = player_input.my_bounds
	var _combo_y = _input_bounds.y1 + global.margin_lg
	var _combo_x = _input_bounds.x0
	var _combo_width = _input_bounds.width
	
	var _fill_color = new CompositeColor(color, image_alpha)
	var _bar_color = new CompositeColor(c_black, 0.3 * image_alpha)
	
	draw_set_composite_color(_fill_color)
	draw_set_font(fnt_large)
	var _text_bounds = draw_text_with_alignment(_combo_x + (_combo_width / 2), _combo_y, string_concat(_phrase, " -- ", other.last_combo, "X"), ALIGN_CENTER)
	
	var _bar_bounds = new Bounds(
		min(_input_bounds.x0, _text_bounds.x0), 
		_text_bounds.y1 + global.margin_sm,
		max(_input_bounds.x1, _text_bounds.x1), 
		_text_bounds.y1 + global.margin_sm + 12 // 12 px thick bar
	)
	
	draw_progress_bar(
		_bar_bounds.x0,
		_bar_bounds.y0,
		_bar_bounds.x1,
		_bar_bounds.y1,
		game_controller.alarm[game_controller.get_combo_alarm_for_player_id(owner_player_id)] / game_controller.combo_max_alarm,
		_fill_color,
		_bar_color
	)
	reset_composite_color()
}
