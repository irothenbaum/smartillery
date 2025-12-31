if (global.paused) {
	return
}

if (fade_out) {
	image_alpha = lerp(image_alpha, 0, global.fade_speed)
	if (image_alpha == 0) {
		instance_destroy()
	}
} else if (image_alpha < 1) {
	image_alpha = lerp(image_alpha, 1, global.fade_speed)
}

var _text_opacity = min(image_alpha, 0.9)

// first draw the text
var _current_wave = get_current_wave_number()
draw_set_composite_color(new CompositeColor(c_black, _text_opacity))
draw_set_font(fnt_wave_text)
var _bounds = draw_text_with_alignment(x, y, "WAVE " + string(_current_wave), ALIGN_CENTER)

// next draw the black borders
var _top_border_height = image_alpha * (_bounds.y0 - global.margin_lg)
var _bottom_border_default_y0 = (_bounds.y1 + global.margin_lg)
var _bottom_border_y0 = _bottom_border_default_y0 + ((1 - image_alpha) * _bottom_border_default_y0)

draw_rectangle(0, 0, global.room_width, _top_border_height, false)
draw_rectangle(0, _bottom_border_y0, global.room_width, global.room_height, false)
reset_composite_color()

/*
Just show the wave number?
if (global.is_math_mode) {
	var _number_of_operations = array_length(global.operations_order)
	var _wave_over_step = floor(_current_wave / global.wave_difficulty_step)
	var _copy = array_copy_all(global.operations_order)
	array_resize(_copy, min(_wave_over_step+1, _number_of_operations))
	draw_set_font(fnt_base)
	draw_text_with_alignment(_bounds.x0, _bounds.y1 + 10, "Operations: " + array_reduce(_copy, function(_aggr, _o) {
		return _aggr + " " + _o 
	}, ""), ALIGN_LEFT)
	draw_text_with_alignment(_bounds.x1, _bounds.y1 + 10, "Max: " + string(math_determine_max_from_wave(_current_wave)), ALIGN_RIGHT)
			
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
*/