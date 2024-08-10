draw_set_colour(c_white);

var _game_controller = get_game_controller()
draw_text_obj(pos_wave, "Wave " + string(_game_controller.current_wave));

// draw ultimate box ----------------------------------------------
draw_ultimate = lerp(draw_ultimate, _game_controller.ultimate_charge / global.ultimate_requirement, global.fade_speed)
var _color = c_white
if (_game_controller.has_ultimate()) {
	_color = global.ultimate_color;
}

draw_set_colour(_color);
draw_power_up(_game_controller.get_ultimate_text(), pos_ultimate, draw_ultimate)
// ------------------------------------------------------------------

// draw heal box ----------------------------------------------
draw_heal = lerp(draw_heal, _game_controller.heal_charge / global.heal_requirement, global.fade_speed)
_color = c_white
if (_game_controller.has_heal()) {
	_color = global.heal_color;
}
draw_set_colour(_color);
draw_power_up(_game_controller.get_heal_text(), pos_heal, draw_heal)
// ------------------------------------------------------------------

draw_set_colour(c_white);
draw_text_obj(pos_score, "Score: " + string(get_game_controller().game_score));