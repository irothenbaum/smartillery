draw_set_colour(c_white);

var _game_controller = get_game_controller()
draw_text_obj(pos_wave, "Wave " + string(_game_controller.current_wave));

if (global.selected_ultimate != ULTIMATE_NONE) {
	// draw ultimate box ----------------------------------------------
	draw_ultimate = lerp(draw_ultimate, _game_controller.ultimate_charge / global.ultimate_requirement, global.fade_speed)
	var _color = c_white
	if (_game_controller.has_ultimate()) {
		_color = global.ultimate_colors[$ global.selected_ultimate];
	}

	draw_set_colour(_color);
	draw_power_up(global.ultimate_code, pos_ultimate, draw_ultimate)
	// ------------------------------------------------------------------
}

draw_set_colour(c_white);
draw_text_obj(pos_score, "Score: " + string(get_game_controller().game_score));