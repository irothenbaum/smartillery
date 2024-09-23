draw_set_color(c_white);

var _game_controller = get_game_controller()
draw_text_obj(pos_wave, "Wave " + string(_game_controller.current_wave));

if (global.selected_ultimate != ULTIMATE_NONE && instance_exists(input) && !is_undefined(input.my_bounds)) {
	// draw ultimate box ----------------------------------------------
	var _color = c_white
	if (_game_controller.has_ultimate()) {
		_color = global.ultimate_colors[$ global.selected_ultimate];
	}
	
	var _xcenter = input.my_bounds.x1 + margin + half_sprite_size
	var _ycenter = input.my_bounds.ycenter
	
	// draw the empty progress bar
	draw_set_alpha(0.5)
	draw_arc(_xcenter, _ycenter, half_sprite_size + margin / 2, 360, 0, 2)
	draw_set_alpha(1)
	
	var _ult_sprite = ultimate_icons[$ global.selected_ultimate]
	draw_set_color(_color);
	draw_sprite_ext(_ult_sprite, 0, _xcenter, _ycenter, 0.4, 0.4, 0, _color, 1)
	// draw the filled progress bar if we have any charge
	if (_game_controller.ultimate_charge > 0) {
		draw_ultimate = lerp(draw_ultimate, _game_controller.ultimate_charge / global.ultimate_requirement, global.fade_speed)
		draw_arc(_xcenter, _ycenter, half_sprite_size + margin / 2, 360 * draw_ultimate, 270, 4)
	}
	// ------------------------------------------------------------------
}

draw_set_color(c_white);
draw_text_obj(pos_score, "Score: " + string(get_game_controller().game_score));