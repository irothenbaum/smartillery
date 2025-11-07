/// @description Draw tutorial text

draw_set_font(fnt_base)

var _wave_bounds = hud.pos_wave.bounds
draw_line_between(_wave_bounds.xcenter, _wave_bounds.y1, wave_description.x, wave_description.y)
draw_text_with_alignment(wave_description.x, wave_description.y, "Current wave number", wave_description.align)


var _score_bounds = hud.pos_score.bounds
draw_line_between(_score_bounds.xcenter, _score_bounds.y1, score_description.x, score_description.y)
draw_text_with_alignment(score_description.x, score_description.y, "Your score", score_description.align)


array_foreach(user_inputs, method({game_controller: game_controller}, function(_input, _index) {
	var _input_bounds = _input.my_bounds
	if (!is_undefined(_input_bounds)) {
		var _input_description = {
			x: _input_bounds.xcenter,
			y: global.ycenter + ((_input_bounds.ycenter - global.ycenter) / 4), // shift towards the middle vertically
			align: ALIGN_CENTER
		}
		draw_line_between(_input_bounds.x0, _input_bounds.ycenter, _input_description.x, _input_description.y, true)
	
		var _message = "Enter your answers here\nGet 3 in a row and score streak bonus."
		if (game_controller.has_point_streak(_input.owner_player_id)) {
			_message = "You're on streak!\nKills will charge your ultimate"
		}
	
		draw_text_with_alignment(_input_description.x, _input_description.y, _message , _input_description.align)
	}
}))

array_foreach(ultimate_icons, method({game_controller: game_controller, draw_ultimate_level_details: draw_ultimate_level_details}, function(_icon, _index) {
	var _ult_bounds = _icon.my_bounds
	if (!is_undefined(_ult_bounds)) {
		var _ultimate_description = {
			x: _ult_bounds.xcenter + ((_ult_bounds.xcenter - global.xcenter) / 2), // shift further from center horizontally
			y: global.ycenter + ((_ult_bounds.ycenter - global.ycenter) / 2), // shift towards the middle vertically
			align: (_ult_bounds.xcenter > global.xcenter) ? ALIGN_LEFT : ALIGN_RIGHT
		}
	
		draw_set_font(fnt_large)
		draw_line_between(_ult_bounds.xcenter, _ult_bounds.y1, _ultimate_description.x, _ultimate_description.y)
	
		var _ultimate = get_player_ultimate(_icon.owner_player_id)
	
		var _message = string_concat("Your ult is \"",global.ultimate_descriptions[$ _ultimate].title, "\"\n", global.ultimate_descriptions[$ _ultimate].description)
		draw_text_with_alignment(_ultimate_description.x, _ultimate_description.y, _message , _ultimate_description.align)

		var _description_bounds = draw_text_with_alignment(_ultimate_description.x, _ultimate_description.y, _message , _ultimate_description.align)
		if (game_controller.has_ultimate(_icon.owner_player_id)) {
			draw_text_with_alignment(
				_description_bounds.xcenter, 
				_description_bounds.y1 + 60, 
				string_concat("Ultimate fully charged!\nEnter launch code \"", global.ultimate_code, "\" to activate"),
				_ultimate_description.align
			)
		}
	
		draw_ultimate_level_details(_icon.owner_player_id, _ult_bounds)
	}
}))

draw_set_font(fnt_large)

draw_text_with_alignment(global.room_width / 2, global.room_height - 100, "[     Click escape to unpause     ]", ALIGN_CENTER)

draw_set_font(fnt_base)