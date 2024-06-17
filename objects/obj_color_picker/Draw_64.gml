for (var _i = 0; _i < array_length(colors); _i++) {
	draw_set_color(colors[_i])
	var _x = x + (_i * (box_size + margin))
	var _y = y
	var _x1 = _x + box_size
	var _y1 = _y + box_size
	
	if (_i == selected_color) {
		_x -= stroke_width
		_x1 += stroke_width
		_y -= stroke_width
		_y1 += stroke_width
	}
	
	draw_rectangle(_x, _y, _x1, _y1, false)
}