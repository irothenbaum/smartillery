/// @description DEBUG DRAWING
// You can write your code in this editor
if (global.debug) {
	var _f = new CompositeColor(c_white, 1)
	var _b = new CompositeColor(c_white, 0.2)
	var _bar_bounds = new Bounds(global.room_width - 40, 200, global.room_width - 20, global.room_height - 200) 
	draw_progress_bar(_bar_bounds.x0, _bar_bounds.y0, _bar_bounds.x1, _bar_bounds.y1, current_value / max_value, _f, _b, true)
	var _last_selected_value_y_pos = _bar_bounds.y1 - _bar_bounds.height * (_last_selected_value / max_value)
	draw_set_composite_color(new CompositeColor(c_green, 1))
	draw_rectangle(_bar_bounds.x0, _last_selected_value_y_pos, _bar_bounds.x1, _last_selected_value_y_pos + 6, false)
	draw_set_composite_color(_f)
	draw_text_with_alignment(global.room_width - 80, 200, max_value, ALIGN_RIGHT)
	draw_text_with_alignment(global.room_width - 80, global.room_height - 220, current_value, ALIGN_RIGHT)
	draw_text_with_alignment(global.room_width - 80, global.room_height - 160, _last_selected_value, ALIGN_RIGHT)
}