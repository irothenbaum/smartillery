draw_set_colour(c_white);

var _ult_scale = pos_ultimate.width / global.ultimate_requirement
var _ultimate_charge = get_game_controller().ultimate_charge * _ult_scale
if (_ultimate_charge != draw_ultimate) {
	draw_ultimate += sign(_ultimate_charge - draw_ultimate)
}

var _game_controller = get_game_controller()
draw_text_obj(pos_wave, "Wave " + string(_game_controller.current_wave));

var _ultimate_ratio = draw_ultimate / (global.ultimate_requirement * _ult_scale)
draw_progress_bar(
	pos_ultimate.x - pos_ultimate.width / 2, 
	pos_ultimate.y, 
	pos_ultimate.x + pos_ultimate.width / 2, 
	pos_ultimate.y + pos_ultimate.height, 
	_ultimate_ratio, 
	get_game_controller().has_ultimate() ? c_aqua: c_white
)

draw_set_colour(c_white);
draw_text_obj(pos_score, "Score: " + string(get_game_controller().game_score));