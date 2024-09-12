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

function draw_overlay(_alpha  = 0.5) {
	draw_set_alpha(_alpha)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

function draw_rounded_rectangle(_x0, _y0, _x1, _y1, _radius, _thickness = 1) {
	var _horizontal = {
		x0: _x0 + _radius,
		x1: _x1 - _radius,
	}
	var _vertical = {
		y0: _y0 + _radius,
		y1: _y1 - _radius,
	}
	
	draw_line_width(_horizontal.x0, _y0, _horizontal.x1, _y0, _thickness)
	draw_arc(_horizontal.x1, _vertical.y0, _radius, 90, 270, _thickness)
	draw_line_width(_x1, _vertical.y0, _x1, _vertical.y1, _thickness)
	draw_arc(_horizontal.x1, _vertical.y1, _radius, 90, 0, _thickness)
	draw_line_width(_horizontal.x0, _y1, _horizontal.x1, _y1, _thickness)
	draw_arc(_horizontal.x0, _vertical.y1, _radius, 90, 90, _thickness)
	draw_line_width(_x0, _vertical.y0, _x0, _vertical.y1, _thickness)
	draw_arc(_horizontal.x0, _vertical.y0, _radius, 90, 180, _thickness)
}

function draw_arc(_x, _y, _radius, _degrees, _start = 0, _thickness = 1) {
	var _steps = 6 // TODO: make this a factor of _radius
	var _total = _degrees - _start
	var _step_degree = _total / _steps
	
	var _start_point = {
		x: _x + lengthdir_x(_radius, _start),
		y: _y + lengthdir_y(_radius, _start)
	}
	
	var _last_point = {
		x: _start_point.x,
		y: _start_point.y
	}
	
	for (var _i = 1; _i < _steps; _i++) {
		var _end_angle = _start + (_i * _step_degree)
		var _end_x = _x + lengthdir_x(_radius, _end_angle)
		var _end_y = _y + lengthdir_y(_radius, _end_angle)
		
		draw_line_width(_last_point.x, _last_point.y, _end_x, _end_y, _thickness)	
		_last_point.x = _end_x
		_last.point.y = _end_y
	}
	
	draw_line_width(_last_point.x, _last_point.y, _start_point.x, _start_point.y, _thickness)
}

function draw_input_box_with_progress(_bounds, _ratio, _align) {
	_ratio = max(0, min(_ratio, 1))
	var _rectangle_bounds = _final_format(_bounds)

	draw_rounded_rectangle(
		_rectangle_bounds.x0, 
		_rectangle_bounds.y0, 
		_rectangle_bounds.x1, 
		_rectangle_bounds.y1, 
		true
	)

	draw_set_alpha(0.15)
	if (is_undefined(_align) || _align == ALIGN_LEFT) {
		draw_roundrect(
			_rectangle_bounds.x0, 
			_rectangle_bounds.y0, 
			_rectangle_bounds.x0 + _rectangle_bounds.width * _ratio,
			_rectangle_bounds.y1, 
			false
		)
	} else if (_align == ALIGN_RIGHT) {
		draw_roundrect(
			_rectangle_bounds.x1 - _rectangle_bounds.width * _ratio, 
			_rectangle_bounds.y0, 
			_rectangle_bounds.x1,
			_rectangle_bounds.y1, 
			false
		)
	} else {
		// TODO: this is not right, but also not in use so 
		draw_roundrect(
			_rectangle_bounds.x0, 
			_rectangle_bounds.y0, 
			_rectangle_bounds.x0 + _rectangle_bounds.width * _ratio,
			_rectangle_bounds.y1, 
			false
		)
	}

	draw_set_alpha(1)
	draw_set_color(c_white)
}