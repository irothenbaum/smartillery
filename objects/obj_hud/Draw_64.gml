draw_set_colour(c_white);

var _ult_scale = pos_ultimate.width / global.ultimate_requirement
var _ultimate_charge = get_game_controller().ultimate_charge * _ult_scale
if (_ultimate_charge != draw_ultimate) {
	draw_ultimate += sign(_ultimate_charge - draw_ultimate)
}

var _health_scale = pos_health.width / global.max_health
var _player_health = get_player().my_health * _health_scale
if (_player_health != draw_health) {
	// if we're deducting, we animate do it 6x times fast
	draw_health += _player_health < draw_health ? -6 : 1
}

var _game_controller = get_game_controller()
draw_text_obj(pos_wave, "Wave " + string(_game_controller.current_wave));
var _health_ratio = draw_health / (global.max_health * _health_scale)
draw_progress_bar(
	pos_health.x - pos_health.width / 2,
	pos_health.y, 
	pos_health.x + pos_health.width / 2, 
	pos_health.y + pos_health.height, 
	_health_ratio, 
	_health_ratio < 0.3 ? c_red : (_health_ratio < 0.6 ? c_yellow : c_lime)
)
var _ultimate_ratio = round_ext(draw_ultimate / (global.ultimate_requirement * _ult_scale), 0.1)
draw_progress_bar(
	pos_ultimate.x - pos_ultimate.width / 2, 
	pos_ultimate.y, 
	pos_ultimate.x + pos_ultimate.width / 2, 
	pos_ultimate.y + pos_ultimate.height, 
	_ultimate_ratio, 
	get_game_controller().has_ultimate() ? c_aqua: c_white
)

if (_game_controller.has_point_streak()) {
	draw_set_colour(c_aqua);
}
draw_text_obj(pos_score, "Score: " + string(get_game_controller().game_score));