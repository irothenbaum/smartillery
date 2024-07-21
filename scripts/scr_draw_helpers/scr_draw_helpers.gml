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
	
	return _final_format({
		x0: _x,
		
		
		y0: _y,
		x1: _x1,
		y1: _y1,
	})
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
	
	// we always draw the 
	_bound.y0 = _y - (_str_height / 2)
			
	switch (_align) {
		case ALIGN_CENTER:
			_bound.x0 = _x - _str_width / 2 
			break
			
		case ALIGN_RIGHT:
			_bound.x0 = _x - _str_width
			break
			
		case ALIGN_LEFT:
		default: 
			// do nothing
			break
	}
	
	_bound.x1 = _bound.x0 + _str_width
	_bound.y1 = _bound.y0 + _str_height
	
	draw_text(_bound.x0, _bound.y0, _text);
	
	return _final_format(_bound)
}

function _final_format(_b) {
	_b.width = _b.x1 - _b.x0
	_b.height = _b.y1 - _b.y0
	_b.xcenter = _b.x0 + _b.width / 2
	_b.ycenter = _b.y0 + _b.height / 2
	
	return _b
}

function draw_overlay(_alpha  = 0.5) {
	draw_set_alpha(_alpha)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
}