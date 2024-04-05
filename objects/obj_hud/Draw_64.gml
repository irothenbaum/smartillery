draw_set_colour(c_white);

var _game_controller = get_game_controller()
draw_text_with_alignment(pos_wave, "Wave " + string(_game_controller.current_wave));
draw_text_with_alignment(pos_health, string(health));
draw_text_with_alignment(pos_ultimate, _game_controller.has_ultimate() ? "1" : "0");

if (_game_controller.has_point_streak()) {
	draw_set_colour(c_aqua);
}
draw_text_with_alignment(pos_score, string(score));