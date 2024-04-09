// Draw modal box
draw_set_colour(c_silver);
draw_rectangle(x - width_half, y - height_half, x + width_half, y + height_half, false);
draw_set_colour(c_grey);
draw_rectangle(x - width_half, y - height_half, x + width_half, y + height_half, true);

// draw progress bar
draw_progress_bar(x_content_start, y_content_start, x_content_end, y_content_start + 10, 1 - (alarm[0] / time_to_solve))

// draw the launch codes title
draw_set_colour(c_black);
draw_set_font(fnt_title)
draw_text_with_alignment(x , y - height_half / 2, "Enter launch codes", ALIGN_CENTER)

// draw the current code sequence
var _current_sequence = codes[solved_codes]
if (!is_undefined(_current_sequence)) {
	draw_set_font(fnt_large)
	// first with the label
	draw_text_with_alignment(x , y - height_half / 2 + 40, _current_sequence.label, ALIGN_CENTER)
	
	var _i = 0;
	var _code_count = array_length(_current_sequence.codes)
	var _box_width = (x_content_end - x_content_start) / _code_count

	draw_set_font(fnt_title)
	for(; _i < _code_count; _i++) {
		if (_i < current_step) {
			draw_set_colour(c_green);
		} else if (_i == current_step) {
			draw_set_colour(c_black);
		} else {
			draw_set_colour(c_grey);
		}
		// then we draw each code
		draw_text_with_alignment(x_content_start  + ((_i + 0.5)  * _box_width), y, _current_sequence.codes[_i], ALIGN_CENTER)
	}
}