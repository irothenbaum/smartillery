/// @description Draw tutorial text

draw_set_font(fnt_base)

var _wave_bounds = hud.pos_wave.bounds
draw_line_between(_wave_bounds.xcenter, _wave_bounds.y1, wave_description.x, wave_description.y)
draw_text_with_alignment(wave_description.x, wave_description.y, "Current wave number", wave_description.align)


var _score_bounds = hud.pos_score.bounds
draw_line_between(_score_bounds.xcenter, _score_bounds.y1, score_description.x, score_description.y)
draw_text_with_alignment(score_description.x, score_description.y, "Your score", score_description.align)


var _input_bounds = input.my_bounds
if (!is_undefined(_input_bounds)) {
	draw_line_between(_input_bounds.x0, _input_bounds.ycenter, input_description.x, input_description.y, true)
	
	var _message = "Enter your answers here\nGet 3 in a row and score streak bonus."
	if (game_controller.has_point_streak()) {
		_message = "You're on streak!\nKills will charge your ultimate"
	}
	
	draw_text_with_alignment(input_description.x, input_description.y, _message , input_description.align)
}

var _ult_bounds = ultimate_icon.my_bounds
if (!is_undefined(_ult_bounds)) {
	draw_set_font(fnt_large)
	draw_line_between(_ult_bounds.xcenter, _ult_bounds.y1, ultimate_description.x, ultimate_description.y)
	
	var _message = string_concat("Your ultimate is \"", global.ultimate_descriptions[$ global.selected_ultimate].title, "\"\n", global.ultimate_descriptions[$ global.selected_ultimate].description)
	draw_text_with_alignment(ultimate_description.x, ultimate_description.y, _message , ultimate_description.align)

	var _description_bounds = draw_text_with_alignment(ultimate_description.x, ultimate_description.y, _message , ultimate_description.align)
	if (game_controller.has_ultimate()) {
		draw_text_with_alignment(
			_description_bounds.x0, 
			_description_bounds.y1 + 20, 
			string_concat("Ultimate fully charged!\nEnter launch code \"", global.ultimate_code, "\" to activate"),
			ultimate_description.align
		)
	}
	
	draw_ultimate_level_details(_ult_bounds)
	
}

draw_set_font(fnt_large)

draw_text_with_alignment(global.room_width / 2, global.room_height - 100, "[     Click escape to unpause     ]", ALIGN_CENTER)

draw_set_font(fnt_base)