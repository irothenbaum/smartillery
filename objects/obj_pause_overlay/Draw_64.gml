/// @description Draw tutorial text

draw_set_font(fnt_base)

draw_overlay()

if (tip_copy) {
	// Determine box position based on tip_copy.position
	var _pos_x = tip_copy.position.x
	var _pos_y = tip_copy.position.y

	// Check if position is in center 20% of screen (10% on each side of center)
	var _x_center_margin = global.room_width * 0.1
	var _y_center_margin = global.room_height * 0.1
	var _in_center_x = (_pos_x > global.xcenter - _x_center_margin) && (_pos_x < global.xcenter + _x_center_margin)
	var _in_center_y = (_pos_y > global.ycenter - _y_center_margin) && (_pos_y < global.ycenter + _y_center_margin)

	var _box_x = global.xcenter
	var _box_y = global.ycenter

	if (_in_center_x && _in_center_y) {
		// Position is in center 20% horizontally, place box in top or bottom 50%
		if (_pos_y < global.ycenter) {
			// Position is above center, place box in bottom 50%
			_box_y = global.ycenter + (global.ycenter / 2)
		} else {
			// Position is below center, place box in top 50%
			_box_y = global.ycenter / 2
		}
	}

	draw_set_alpha(0)
	// Draw title and description to get bounds
	draw_set_font(fnt_large)
	var _title_bounds = draw_text_with_alignment(_box_x, _box_y, tip_copy.title, ALIGN_CENTER)
	draw_set_font(fnt_base)
	var _desc_bounds = draw_text_with_alignment(_box_x, _title_bounds.y1 + global.margin_md, tip_copy.description, ALIGN_CENTER)

	// Calculate box bounds with padding
	var _content_bounds = get_max_bounds([_title_bounds, _desc_bounds])
	var _box_bounds = apply_padding_to_bounds(_content_bounds, global.margin_lg, global.margin_lg)
	
	var _opacity = clamp(alarm[0] / fade_duration, 0, 1)

	// Draw box background (90% opaque)
	draw_set_alpha(_opacity * 0.9)
	draw_set_color(c_black)
	draw_rectangle(_box_bounds.x0, _box_bounds.y0, _box_bounds.x1, _box_bounds.y1, false)

	// Draw white border
	draw_set_alpha(_opacity)
	draw_set_color(c_white)
	draw_rectangle(_box_bounds.x0, _box_bounds.y0, _box_bounds.x1, _box_bounds.y1, true)

	// Redraw title and description on top of box
	draw_set_font(fnt_large)
	draw_text_with_alignment(_box_x, _box_y, tip_copy.title, ALIGN_CENTER)
	draw_set_font(fnt_base)
	draw_text_with_alignment(_box_x, _title_bounds.y1 + global.margin_md, tip_copy.description, ALIGN_CENTER)
	
	var _draw_to_spot = find_point_on_bounds_at_angle(_box_bounds, point_direction(_box_bounds.xcenter, _box_bounds.ycenter, _pos_x, _pos_y))

	// Draw line from position to box
	draw_line_width(_pos_x, _pos_y, _draw_to_spot.x, _draw_to_spot.y, 2)
}

draw_set_font(fnt_base)