if (fade_out) {
	image_alpha = image_alpha * 0.9;
}
draw_set_composite_color(composite_color(c_white, image_alpha))
draw_set_font(fnt_title)
var _bounds = draw_text_with_alignment(x, y, "Beginning Wave #" + string(get_current_wave_number()), ALIGN_CENTER)

var _current_wave = get_current_wave_number()
if (global.is_math_mode) {
	var _number_of_operations = array_length(global.operations_order)
	var _wave_over_step = floor(_current_wave / global.wave_difficulty_step)
	var _copy = []
	array_copy(_copy, 0, global.operations_order, 0, _number_of_operations)
	array_resize(_copy, min(_wave_over_step+1, _number_of_operations))
	draw_set_font(fnt_base)
	draw_text_with_alignment(_bounds.x0, _bounds.y1 + 10, "Operations: " + array_reduce(_copy, function(_aggr, _o) {
		return _aggr + " " + _o 
	}, ""), ALIGN_LEFT)
	draw_text_with_alignment(_bounds.x1, _bounds.y1 + 10, "Max: " + string(math_determine_max_from_wave(get_current_wave_number())), ALIGN_RIGHT)
			
	if (_current_wave % global.wave_difficulty_step == 0) {
		var _new_operation_index = min(_number_of_operations-1, _wave_over_step)
		var _new_operation = global.operations_order[_new_operation_index]
		draw_set_font(fnt_large)
		draw_text_with_alignment(global.xcenter, _bounds.y1 + 40, "New operation: " + _new_operation, ALIGN_CENTER)
	}
} else {
	var _max_word_length = get_max_word_length_from_wave(_current_wave)
	draw_set_font(fnt_large)
	draw_text_with_alignment(global.xcenter, _bounds.y1 + 20, "max word length: " + string(_max_word_length), ALIGN_CENTER)
}
reset_composite_color()