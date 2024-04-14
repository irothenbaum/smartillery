/// @param {Read} _x
/// @param {Read} _y
/// @param {Read} _x1
/// @param {Read} _y1
/// @param {Read} _progress -- [0,1]
/// @param {Color} _color
function draw_progress_bar(_x, _y, _x1, _y1, _progress, _color = c_lime) {
	draw_set_color(c_grey)
	draw_rectangle(_x, _y, _x1, _y1, false)
	draw_set_color(_color)
	var _x_diff = _x1 - _x
	draw_rectangle(_x, _y, _x + (min(max(0,_progress), 1) * _x_diff), _y1, false)
	
	return {
		x0: _x,
		y0: _y,
		x1: _x1,
		y1: _y1
	}
}

function draw_text_with_alignment(_x, _y, _text, _align = ALIGN_LEFT) {	
	var _bound = {
		x0: _x,
		y0: _y,
		x1: _x,
		y1: _y
	}
	
	var _str_width = string_width(_text)
	var _str_height = string_height(_text)
	
	// we always vertically center the text
	_bound.y0 = _y - _str_height / 2
			
	switch (_align) {
		case ALIGN_CENTER:
			_bound.x0 = _x - string_width(_text) / 2 
			break
			
		case ALIGN_RIGHT:
			_bound.x0 = _x - string_width(_text)
			break
			
		case ALIGN_LEFT:
		default: 
			// do nothing
			break
	}
	
	_bound.x1 = _bound.x0 + _str_width
	_bound.y1 = _bound.y1 + _str_height
	
	draw_text(_bound.x0, _bound.y0, _text);
	
	return _bound 
}