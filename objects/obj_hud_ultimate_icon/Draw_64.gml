if (global.selected_ultimate != ULTIMATE_NONE && instance_exists(input) && !is_undefined(input.my_bounds)) {
	// draw ultimate box ----------------------------------------------
	var _ultimate_color = global.ultimate_colors[$ global.selected_ultimate];
	var _ultimate_tint = global.ultimate_color_tints[$ global.selected_ultimate];
	
	var _xcenter = input.my_bounds.x1 + margin * 2 + half_sprite_size
	var _ycenter = input.my_bounds.ycenter
	
	var _circle_radius = half_sprite_size + margin / 2
	
	// draw the ultimate circle progress if we have any charge
	if (game_controller.ultimate_charge > 0) {
		drawn_ultimate = lerp(drawn_ultimate, game_controller.ultimate_charge / global.ultimate_requirement, global.fade_speed)
		draw_set_composite_color(composite_color(_ultimate_color, game_controller.has_ultimate() ? 1 : 0.3))
		draw_circle_color(_xcenter, _ycenter, _circle_radius * drawn_ultimate, _ultimate_color, _ultimate_color, false)
	}
	
	// draw the empty experience bar
	draw_set_composite_color(color_shadow)
	draw_arc(_xcenter, _ycenter, _circle_radius , 360, 0, 4)
	reset_composite_color()
	
	// draw the experiece arc if we have any
	if (game_controller.ultimate_experience > 0) {
		var _next_amount = get_experience_needed_for_next_level(game_controller.ultimate_level)
		drawn_ultimate_experience = lerp(drawn_ultimate_experience, game_controller.ultimate_experience / _next_amount, global.fade_speed)
		draw_arc(_xcenter, _ycenter, _circle_radius, 360 * drawn_ultimate_experience, 270, 8)
	} else {
		drawn_ultimate_experience = 0
	}
	
	// draw the sprite on top
	var _ult_sprite = ultimate_icons[$ global.selected_ultimate]
	draw_sprite_ext(_ult_sprite, 0, _xcenter, _ycenter, 0.4, 0.4, 0, c_white, 1)
	
	// last we draw the level
	var _level_center = {
		x: _xcenter + lengthdir_x(_circle_radius, 315),
		y: _ycenter + lengthdir_y(_circle_radius, 315),
	}
	draw_set_composite_color(color_shadow_dark)
	draw_circle(_level_center.x, _level_center.y, 10, false)
	reset_composite_color()
	draw_set_font(fnt_small)
	draw_text_with_alignment(_level_center.x, _level_center.y, string(game_controller.ultimate_level), ALIGN_CENTER)
	draw_set_font(fnt_base)
	// ------------------------------------------------------------------
	
	my_bounds = _final_format({
		x0: _xcenter - _circle_radius,
		y0: _ycenter - _circle_radius,
		x1: _xcenter + _circle_radius,
		y1: _ycenter + _circle_radius,
	})
}