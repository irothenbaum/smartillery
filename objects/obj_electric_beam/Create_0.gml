// width, target_x, target_y, and color are passed values

direction = point_direction(x,y, target_x, target_y)
length = point_distance(x,y, target_x, target_y)
number_of_zags = ceil(length / 100) + 1
max_zig_shift = width * 2
arc_count = width
image_alpha = 1
half_width = width / 2

lines = []

// TODO: this could be generalized
function render_zig_zag_line(_x0, _y0, _x1, _y1, _steps, _max_width) {
	var _length = point_distance(_x0, _y0, _x1, _y1)
	var _point_direction = point_direction(_x0, _y0, _x1, _y1)
	var _ideal_step_length = _length / _steps
	
	// last indicates a point on the line
	var _last_x = _x0
	var _last_y = _y0
	
	// last drawn is a point shifted off the line to create a zig zag
	var _last_drawn_x = _x0
	var _last_drawn_y = _y0
	
	for (var _i = 1; _i < _steps; _i++) {
		var _is_last_segment = _i == _steps - 1
		if (_is_last_segment) {
			_last_x = target_x
			_last_y = target_y
		} else {
			var _this_step_length = irandom_range(_ideal_step_length * 0.6, _ideal_step_length * 1.6)
			// determine and set our next on-line point
			_last_x = _last_x + lengthdir_x(_this_step_length, _point_direction)
			_last_y = _last_y + lengthdir_y(_this_step_length, _point_direction)
		}
		
		// now shift a little off the point along perpendicular to the line
		var _random_shift = _is_last_segment ? irandom(width) - half_width : irandom(2 * _max_width) - _max_width
		var _next_drawn_x = _last_x + lengthdir_x(_random_shift, _point_direction + 90)
		var _next_drawn_y = _last_y + lengthdir_y(_random_shift, _point_direction + 90)
		
		array_push(lines, {x0: _last_drawn_x, y0: _last_drawn_y, x1: _next_drawn_x, y1: _next_drawn_y})
		
		// shift our reference frame
		_last_drawn_x = _next_drawn_x
		_last_drawn_y = _next_drawn_y
	}
}

function draw_all_lines() {
	array_foreach(lines, function(_line) {
		draw_line(_line.x0, _line.y0, _line.x1, _line.y1)
	})
}


// prerender all our lines
for (var _i = 0; _i < arc_count; _i++) {
	var _this_shift = irandom(width) - half_width
	var _that_shift = irandom(width) - half_width
	var _x0 = x + lengthdir_x(_this_shift, direction - 90)
	var _y0 = y + lengthdir_y(_this_shift, direction - 90)
	var _x1 = target_x + lengthdir_x(_that_shift, direction - 90)
	var _y1 = target_y + lengthdir_y(_that_shift, direction - 90)
	
	render_zig_zag_line(_x0, _y0, _x1, _y1, number_of_zags, max_zig_shift)	
}