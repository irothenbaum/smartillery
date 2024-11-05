/// @param {Read} _x
/// @param {Read} _y
/// @param {Read} _x1
/// @param {Read} _y1
/// @param {Read} _progress -- [0,1]
/// @param {Color} _color
function draw_progress_bar(_x, _y, _x1, _y1, _progress, _color, _background_color) {
	draw_set_composite_color(_background_color)
	draw_rectangle(_x, _y, _x1, _y1, false)
	draw_set_composite_color(_color)
	var _x_diff = _x1 - _x
	draw_rectangle(_x, _y, _x + (min(max(0,_progress), 1) * _x_diff), _y1, false)
	reset_composite_color()
	
	return _final_format({
		x0: _x,
		y0: _y,
		x1: _x1,
		y1: _y1,
	})
}

function get_max_bounds(_bounds_array) {
	if (!is_array(_bounds_array) || array_length(_bounds_array) == 0) {
		return undefined
	}
	var _ret_val = {
		x0: _bounds_array[0].x0,
		y0: _bounds_array[0].y0,
		x1: _bounds_array[0].x1,
		y1: _bounds_array[0].y1,
	}
	for (var _i = 1; _i < array_length(_bounds_array); _i++) {
		var _these_bounds = _bounds_array[_i];
		_ret_val.x0 = min(_ret_val.x0, _these_bounds.x0)
		_ret_val.x1 = max(_ret_val.x1, _these_bounds.x1)
		_ret_val.y0 = min(_ret_val.y0, _these_bounds.y0)
		_ret_val.y1 = max(_ret_val.y1, _these_bounds.y1)
	}
	
	return _final_format(_ret_val)
}

function draw_info_modal(_bounds, _step) {
	_step = min(1, max(0, _step))
	var _padding = 20;
	var _with_padding = {
		x0: (_bounds.x0 - _padding),
		y0: (_bounds.y0 - _padding),
		x0: (_bounds.x1 + _padding),
		y0: (_bounds.y1 + _padding),
	}
	
	if (_step < 1) {
		_with_padding = {
			x0: lerp(_bounds.xcenter, _with_padding.x0, min(1, _step * 2)),
			y0: lerp(_bounds.ycenter, _with_padding.y0, max(0, _step * 2 - 1)),
			x0: lerp(_bounds.xcenter, _with_padding.x1, min(1, _step * 2)),
			y0: lerp(_bounds.ycenter, _with_padding.y1, max(0, _step * 2 - 1)),
		}	
	}
	
	draw_set_composite_color(composite_color(c_white, 1))
	draw_rectangle(_with_padding.x0, _with_padding.y0, _with_padding.x1, _with_padding.y1, true)
	draw_set_composite_color(composite_color(c_black, 0.3))
	draw_rectangle(_with_padding.x0, _with_padding.y0, _with_padding.x1, _with_padding.y1, false)
}

function draw_text_with_alignment(_x, _y, _text, _align = ALIGN_LEFT, _line_height = 1.1) {	
	var _lines = string_split(_text, "\n")
	var _final_bounds = {
		x0: _x,
		y0: _y,
		x1: _x,
		y1: _y
	}
		
	var _total_lines = array_length(_lines)
	for (var _i = 0; _i < _total_lines; _i++) {
		var _line_text = _lines[_i]
		var _line_bounds = {
			x0: _x,
			y0: _y,
			x1: _x,
			y1: _y
		}
		
		var _str_width = string_width(_line_text)
		var _str_height = string_height(_line_text)
		
		// we always draw the text center aligned vertically
		_line_bounds.y0 = _y - (_str_height / 2)
			
		switch (_align) {
			case ALIGN_CENTER:
				_line_bounds.x0 = _x - _str_width / 2 
				break
			
			case ALIGN_RIGHT:
				_line_bounds.x0 = _x - _str_width
				break
			
			case ALIGN_LEFT:
			default: 
				// do nothing
				break
		}
	
		_line_bounds.x1 = _line_bounds.x0 + _str_width
		_line_bounds.y1 = _line_bounds.y0 + _str_height
	
		draw_text(_line_bounds.x0, _line_bounds.y0, _line_text);
		_y += _str_height * _line_height
		
		_final_bounds.x0 = min(_final_bounds.x0, _line_bounds.x0)
		_final_bounds.x1 = max(_final_bounds.x1, _line_bounds.x1)
		_final_bounds.y0 = min(_final_bounds.y0, _line_bounds.y0)
		_final_bounds.y1 = max(_final_bounds.y1, _line_bounds.y1)
	}
	
	return _final_format(_final_bounds)
}

function draw_overlay(_alpha  = 0.5) {
	// TODO Might want to use draw_clear_alpha() here but it's not working. I must be doing something wrong
	draw_set_alpha(_alpha)
	draw_set_color(c_black)
	draw_rectangle(0, 0, global.room_width, global.room_height, false)
	reset_composite_color()
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
	draw_arc(_horizontal.x1, _vertical.y0, _radius, 90, 0, _thickness)
	draw_line_width(_x1, _vertical.y0, _x1, _vertical.y1, _thickness)
	draw_arc(_horizontal.x1, _vertical.y1, _radius, 90, 270, _thickness)
	draw_line_width(_horizontal.x0, _y1, _horizontal.x1, _y1, _thickness)
	draw_arc(_horizontal.x0, _vertical.y1, _radius, 90, 180, _thickness)
	draw_line_width(_x0, _vertical.y0, _x0, _vertical.y1, _thickness)
	draw_arc(_horizontal.x0, _vertical.y0, _radius, 90, 90, _thickness)
}

function draw_arc(_x, _y, _radius, _degrees, _start = 0, _thickness = 1) {
	var _steps = ceil((_radius * ((_degrees / 360) * TAU)) / 10)
	var _step_degree = _degrees / _steps
	
	var _last_point = {
		x: _x + lengthdir_x(_radius, _start),
		y: _y + lengthdir_y(_radius, _start)
	}
	
	for (var _i = 1; _i <= _steps; _i++) {
		var _end_angle = _start + (_i * _step_degree)
		var _end_angle_compensated = _end_angle + (0.1 * _step_degree)
		var _end_x = _x + lengthdir_x(_radius, _end_angle)
		var _end_y = _y + lengthdir_y(_radius, _end_angle)
		
		var _end_x_compensated = _x + lengthdir_x(_radius, _end_angle_compensated)
		var _end_y_compensated = _y + lengthdir_y(_radius, _end_angle_compensated)
		
		draw_line_width(_last_point.x, _last_point.y, _end_x_compensated, _end_y_compensated, _thickness)	
		_last_point.x = _end_x
		_last_point.y = _end_y
	}
}

function draw_input_box_with_progress(_bounds, _ratio, _align) {
	_ratio = max(0, min(_ratio, 1))
	var _rectangle_bounds = _final_format(_bounds)

	draw_rounded_rectangle(
		_rectangle_bounds.x0, 
		_rectangle_bounds.y0, 
		_rectangle_bounds.x1, 
		_rectangle_bounds.y1, 
		8,
		3
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
	}

	reset_composite_color()
}

function composite_color(_color, _opacity) {
	return {c: _color, o:_opacity}
}

function draw_set_composite_color(_c) {
	draw_set_alpha(_c.o)
	draw_set_color(_c.c)
}

function reset_composite_color() {
	draw_set_composite_color(RESET_COLOR)
}


// ----------------------------------------------------------------------
// these are background circle related functions
function get_radius_at_i(_i) {
	return global.bg_circle_max_radius - ((_i / global.bg_number_of_circles) * global.bg_circle_magnitude)
}

// this inverse of get_radius_at_i
function get_ring_from_distance(_distance) {
	return  floor(global.bg_number_of_circles * (global.bg_circle_max_radius - _distance) / global.bg_circle_magnitude)
}