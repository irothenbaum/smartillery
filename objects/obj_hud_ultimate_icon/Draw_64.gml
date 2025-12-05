if (instance_exists(input) && !is_undefined(input.my_bounds)) {
	var _selected_ultimate = global.selected_ultimate[$ owner_player_id]
	var _player_has_ultimate = game_controller.has_ultimate(owner_player_id)
	
	// draw ultimate box ----------------------------------------------
	var _ultimate_color = global.ultimate_colors[$ _selected_ultimate];

	var _center_shift_amount = half_sprite_size + (global.margin_md * 2)
	
	// this places the icon to the right of the input
	var _xcenter = input.my_bounds.x1 + _center_shift_amount
	
	// this matches the logic in obj_input to determine what side of the input the icon should be
	if (!global.is_solo && (get_player_number(owner_player_id) % 2) == 0) {
		// this places the icon to the left of the input
		_xcenter = input.my_bounds.x0 - _center_shift_amount
	}

	var _ycenter = input.my_bounds.ycenter
	
	var _circle_radius = half_sprite_size + (global.margin_md / 2)
	
	// draw the ultimate circle progress if we have any charge
	if (game_controller.ultimate_charge[$ owner_player_id] > 0) {
		var _visible_height = ceil((_circle_radius * 2) * game_controller.ultimate_charge[$ owner_player_id] / global.ultimate_requirement)
		
		// Turn on clipping
		gpu_set_scissor(_xcenter - _circle_radius, _ycenter + _circle_radius - _visible_height, _circle_radius * 2, _visible_height);

		// Draw the filled part (solid circle)
		draw_set_composite_color(new CompositeColor(_ultimate_color, _player_has_ultimate ? 1 : 0.5))
		draw_circle_color(_xcenter, _ycenter, _circle_radius, _ultimate_color, _ultimate_color, false)
		
		// Turn off clipping
		gpu_set_scissor(0, 0, display_get_width(), display_get_height());
	}
	
/*
	// draw the empty experience bar
	draw_set_composite_color(color_shadow)
	draw_arc(_xcenter, _ycenter, _circle_radius , 360, 0, 4)
	reset_composite_color()
*/	
	// draw the experiece arc if we have any
	if (game_controller.ultimate_experience[$ owner_player_id] > 0) {
		var _next_amount = get_experience_needed_for_next_level(game_controller.ultimate_level[$ owner_player_id])
		drawn_ultimate_experience = lerp(drawn_ultimate_experience, game_controller.ultimate_experience[$ owner_player_id] / _next_amount, global.fade_speed)
		draw_set_composite_color(new CompositeColor(c_white, 1))
		draw_arc(_xcenter, _ycenter, _circle_radius, 360 * drawn_ultimate_experience, 270, 8)
	} else {
		drawn_ultimate_experience = 0
	}
	
	// draw the sprite on top
	var _ult_sprite = global.ultimate_icons[$ _selected_ultimate]
	draw_sprite_ext(_ult_sprite, 0, _xcenter, _ycenter, icon_scale, icon_scale, 0, c_white, _player_has_ultimate ? 1 : 0.5)
	
	// last we draw the level
	var _level_center = {
		x: _xcenter + lengthdir_x(_circle_radius, 315),
		y: _ycenter + lengthdir_y(_circle_radius, 315),
	}
	draw_set_composite_color(color_shadow_dark)
	draw_circle(_level_center.x, _level_center.y, 10, false)
	reset_composite_color()
	draw_set_font(fnt_small)
	draw_text_with_alignment(_level_center.x, _level_center.y, string(game_controller.ultimate_level[$ owner_player_id]), ALIGN_CENTER)
	draw_set_font(fnt_base)
	// ------------------------------------------------------------------
	
	my_bounds = new Bounds(_xcenter - _circle_radius,_ycenter - _circle_radius, _xcenter + _circle_radius, _ycenter + _circle_radius )
}