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

/*
var _wave_bounds = hud.pos_wave.bounds
draw_line_between(_wave_bounds.xcenter, _wave_bounds.y1, wave_description.x, wave_description.y)
draw_text_with_alignment(wave_description.x, wave_description.y, "Current wave number", wave_description.align)


var _score_bounds = hud.pos_score.bounds
draw_line_between(_score_bounds.xcenter, _score_bounds.y1, score_description.x, score_description.y)
draw_text_with_alignment(score_description.x, score_description.y, "Your score", score_description.align)


array_foreach(user_inputs, method({game_controller: game_controller}, function(_input, _index) {
	var _input_bounds = _input.my_bounds
	if (!is_undefined(_input_bounds)) {
		var _input_description = {
			x: _input_bounds.xcenter,
			y: global.ycenter + ((_input_bounds.ycenter - global.ycenter) / 4), // shift towards the middle vertically
			align: ALIGN_CENTER
		}
		draw_line_between(_input_bounds.x0, _input_bounds.ycenter, _input_description.x, _input_description.y, true)
	
		var _message = "Enter your answers here\nGet 3 in a row and score streak bonus."
		if (game_controller.has_point_streak(_input.owner_player_id)) {
			_message = "You're on streak!\nKills will charge your ultimate"
		}
	
		draw_text_with_alignment(_input_description.x, _input_description.y, _message , _input_description.align)
	}
}))

array_foreach(ultimate_icons, method({game_controller: game_controller, draw_ultimate_level_details: draw_ultimate_level_details}, function(_icon, _index) {
	var _ult_bounds = _icon.my_bounds
	if (!is_undefined(_ult_bounds)) {
		var _ultimate_description = {
			x: _ult_bounds.xcenter,
			y: global.ycenter + ((_ult_bounds.ycenter - global.ycenter) / 1.8), // shift towards the middle vertically
			align: (_ult_bounds.xcenter > global.xcenter) ? ALIGN_LEFT : ALIGN_RIGHT
		}
	
		draw_line_between(_ult_bounds.xcenter, _ult_bounds.y1, _ultimate_description.x, _ultimate_description.y)
	
		var _ultimate = get_player_ultimate(_icon.owner_player_id)
	
		var _message = string_concat("Your ult is \"",global.ultimate_descriptions[$ _ultimate].title, "\"\n", global.ultimate_descriptions[$ _ultimate].description)
		draw_text_with_alignment(_ultimate_description.x, _ultimate_description.y, _message , _ultimate_description.align)

		var _description_bounds = draw_text_with_alignment(_ultimate_description.x, _ultimate_description.y, _message , _ultimate_description.align)
		if (game_controller.has_ultimate(_icon.owner_player_id)) {
			draw_text_with_alignment(
				_description_bounds.xcenter, 
				_description_bounds.y1 + 60, 
				string_concat("Ultimate fully charged!\nEnter launch code \"", global.ultimate_code, "\" to activate"),
				_ultimate_description.align
			)
		}
	
		draw_ultimate_level_details(_icon.owner_player_id, _ult_bounds)
	}
}))

draw_set_font(fnt_large)

draw_text_with_alignment(global.room_width / 2, global.room_height - 100, "[     Click escape to unpause     ]", ALIGN_CENTER)

*/
draw_set_font(fnt_base)