draw_set_color(c_white);

draw_text_obj(pos_wave, "Wave " + string(game_controller.current_wave));

if (global.selected_ultimate != ULTIMATE_NONE && instance_exists(input) && !is_undefined(input.my_bounds)) {
	// draw ultimate box ----------------------------------------------
	var _ultimate_color = global.ultimate_colors[$ global.selected_ultimate];
	var _ultimate_tint = global.ultimate_color_tints[$ global.selected_ultimate];
	
	var _xcenter = input.my_bounds.x1 + margin * 2 + half_sprite_size
	var _ycenter = input.my_bounds.ycenter
	
	var _circle_radius = half_sprite_size + margin / 2
	
	// draw the ultimate circle progress if we have any charge
	if (game_controller.ultimate_charge > 0) {
		draw_ultimate = lerp(draw_ultimate, game_controller.ultimate_charge / global.ultimate_requirement, global.fade_speed)
		draw_set_composite_color(composite_color(_ultimate_color, game_controller.has_ultimate() ? 1 : 0.3))
		draw_circle_color(_xcenter, _ycenter, _circle_radius * draw_ultimate, _ultimate_color, _ultimate_color, false)
	}
	
	// draw the empty experience bar
	draw_set_composite_color(composite_color(c_white, 1))
	draw_arc(_xcenter, _ycenter, _circle_radius , 360, 0, 4)
	
	// draw the experiece arc if we have any
	if (game_controller.ultimate_experience > 0) {
		var _next_amount = get_experience_needed_for_next_level(game_controller.ultimate_level)
		draw_ultimate_experience = lerp(draw_ultimate_experience, game_controller.ultimate_experience / _next_amount, global.fade_speed)
		draw_arc(_xcenter, _ycenter, _circle_radius, 360 * draw_ultimate_experience, 270, 8)
	}
	
	// last we draw the sprite on top
	var _ult_sprite = ultimate_icons[$ global.selected_ultimate]
	draw_sprite_ext(_ult_sprite, 0, _xcenter, _ycenter, 0.4, 0.4, 0, c_white, 1)
	// ------------------------------------------------------------------
}

reset_composite_color()

draw_text_obj(pos_score, "Score: " + string(lerp(drawn_score, game_controller.game_score, 0.25)));