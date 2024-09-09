var _draw_steps = min(1, (get_play_time() - spawn_time) / draw_duration_ms) * total_steps

for (var _i = 0; _i < _draw_steps; _i++) {
	var _draw_direction = direction + (_i / total_steps) * 360
	var _draw_direction_next = direction + ((_i + 1) / total_steps) * 360
	
	var _amplitude1 = amplitude * sin((_i / resolution) * TAU)
	var _amplitude2 = amplitude * sin(((_i+1) / resolution) * 2 *  pi)
	
	var _x1 = x + lengthdir_x(circle_radius + _amplitude1, _draw_direction)
	var _x2 = x + lengthdir_x(circle_radius + _amplitude2, _draw_direction + step_rotation)
	var _y1 = y + lengthdir_y(circle_radius + _amplitude1, _draw_direction)
	var _y2 = y + lengthdir_y(circle_radius + _amplitude2, _draw_direction + step_rotation)
	draw_set_alpha(image_alpha)
	draw_set_color(color)
	draw_line_width(_x1, _y1, _x2, _y2, thickness)
	draw_set_color(c_white)
	draw_set_alpha(1)
	
	/*
	-- Draws a straight sin wave
	var _wave_x1 = _i * wave_step_length
	var _wave_x2 = (_i + 1) * wave_step_length
	var _x1 = x + _wave_x1
	var _x2 = x + _wave_x2
	var _y1 = y + amplitude * sin((_i / resolution) * TAU)
	var _y2 = y + amplitude * sin(((_i+1) / resolution) * 2 *  pi)
	draw_set_color(color)
	draw_line(_x1, _y1, _x2, _y2)
	draw_set_color(c_white)
	*/
}