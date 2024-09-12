draw_ultimate = 0
draw_heal = 0
margin = 20

min_box_width = 100

pos_score = {
	x: room_width - 2 * margin,
	y: margin,
	align: ALIGN_RIGHT
}

pos_wave = {
	x: margin,
	y: margin,
	align: ALIGN_LEFT
}

pos_ultimate = {
	x: global.x_center + (margin / 2),
	y: margin,
	align: ALIGN_LEFT
}

pos_heal = {
	x: global.x_center - (margin / 2),
	y: margin,
	align: ALIGN_RIGHT
}


function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
}

function draw_power_up(_message, _position, _ratio) {
	draw_set_valign(fa_top);
	draw_set_font(fnt_large)
	var _bounds = draw_text_with_alignment(_position.x, _position.y, _message, _position.align)

	if (_bounds.width < min_box_width) {
		if (_position.align == ALIGN_RIGHT) {
			_bounds.x1 = _bounds.x1
			_bounds.x0 = _bounds.x1 - min_box_width
		} else if (_position.align == ALIGN_LEFT) {
			_bounds.x0 = _bounds.x0
			_bounds.x1 = _bounds.x0 + min_box_width
		} else {
			_bounds.x0 = _bounds.xcenter - min_box_width / 2
			_bounds.x1 = _bounds.xcenter + min_box_width / 2
		}
	}

	_bounds = _final_format(_bounds)

	draw_input_box_with_progress(_bounds, _ratio, _position.align)
}