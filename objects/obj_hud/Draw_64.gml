draw_set_colour(c_white);

var _game_controller = get_game_controller()
draw_text_obj(pos_wave, "Wave " + string(_game_controller.current_wave));
draw_text_obj(pos_health, "Health: " + string(health));
draw_text_obj(pos_ultimate, "Ult: " + (_game_controller.has_ultimate() ? "Yes" : "No"));

if (_game_controller.has_point_streak()) {
	draw_set_colour(c_aqua);
}
draw_text_obj(pos_score, "Score: " + string(score));