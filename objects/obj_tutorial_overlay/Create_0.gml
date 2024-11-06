/// @description Store references to postitions
hud = instance_find(obj_hud, 0)
player = get_player()
input = instance_find(obj_input, 0)
game_controller = get_game_controller()
ultimate_icon = instance_find(obj_hud_ultimate_icon, 0)


wave_description = {
	x: 100,
	y: 200,
	align: ALIGN_CENTER
}

score_description = {
	x: hud.pos_score.bounds.xcenter,
	y: 200,
	align: ALIGN_CENTER
}

input_description = {
	x: global.room_width / 2 - 300,
	y: 100,
	align: ALIGN_CENTER
}

ultimate_description = {
	x: global.room_width / 2 - 200 ,
	y: 300,
	align: ALIGN_CENTER
}


function draw_line_between(_x0, _y0, _x1, _y1, _horizontal_first = false) {
	var _y_direction = normalize(_y1 - _y0)
	_y1 -= 30 * _y_direction
	
	if (_horizontal_first) {
		var _x_direction = normalize(_x1 - _x0)
		_x0 += 10 * _x_direction
	} else {
		_y0 += 10 * _y_direction
	}
	
	var _thickness = 2
	
	var _half_y = _y0 + _y_direction * (_y1 - _y0) / 2
	if (_horizontal_first) {
		_half_y = _y0
	}
	
	draw_line_width(_x0, _y0, _x0, _half_y, _thickness)	
	
	if (_x0 != _x1) {
		draw_line_width(_x0, _half_y, _x1, _half_y, _thickness)
	}
	draw_line_width(_x1, _half_y, _x1, _y1, _thickness)
}

function draw_ultimate_level_details(_ult_bounds) {
	var _circle_radius = _ult_bounds.y1 - _ult_bounds.ycenter
	var _level_center = {
		x: _ult_bounds.xcenter + lengthdir_x(_circle_radius, 315),
		y: _ult_bounds.ycenter + lengthdir_y(_circle_radius, 315),
	}
	
	var _details_center = {
		x: _ult_bounds.xcenter + lengthdir_x(260, 330),
		y: _ult_bounds.ycenter + lengthdir_y(260, 330),
	}
	draw_line_between(_level_center.x, _level_center.y, _details_center.x, _details_center.y, true)
	
	var _this_level_stats = get_ultimate_stats(game_controller.ultimate_level)
	var _next_level_stats = get_ultimate_stats(game_controller.ultimate_level + 1)
	
	draw_set_font(fnt_large)
	var _new_bounds = draw_text_with_alignment(_details_center.x, _details_center.y, string_concat(global.ultimate_descriptions[$ global.selected_ultimate].title, " -- lvl ", game_controller.ultimate_level), ALIGN_CENTER)
	draw_set_font(fnt_base)
	_new_bounds = draw_text_with_alignment(_new_bounds.x0, _new_bounds.y1 + 20, _this_level_stats, ALIGN_LEFT)
	
	draw_line_width(_new_bounds.x0, _new_bounds.y1 + 20, _new_bounds.x1 + 60, _new_bounds.y1 + 20, 1)
	
	draw_text_with_alignment(_new_bounds.x0, _new_bounds.y1 + 50, string_concat("Next Level:\n", _next_level_stats), ALIGN_LEFT)
}

function get_ultimate_stats(_level) {
	var _stats = []
	var _frames_to_seconds = game_get_speed(gamespeed_fps)
	switch (global.selected_ultimate) {
		case ULTIMATE_HEAL:
			array_push(_stats, string_concat("Heal rate: ", round((ult_heal_get_rate(_level) / _frames_to_seconds) * 10) / 10, " /s"))
			array_push(_stats, string_concat("Duration: ", round((ult_heal_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			var _leech_amount = ult_heal_get_leech_amount(_level)
			if (_leech_amount > 0) {
				array_push(_stats, string_concat("+", _leech_amount, " health per kill"))
			}
			break
			
		case ULTIMATE_STRIKE:
			array_push(_stats, string_concat(ult_strike_get_count(_level), " strikes"))
			array_push(_stats, string_concat("Strike aoe: ", ult_strike_get_radius(_level)))
			break
		
		case ULTIMATE_SLOW:
			array_push(_stats, string_concat("Slow amount: ", round(ult_slow_get_speed_multiplier(_level) * 100), "%"))
			array_push(_stats, string_concat("Duration: ", round((ult_slow_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			array_push(_stats, string_concat("Effect distance: ", ult_slow_get_radius(_level)))
			break
	}
	
	if (array_length(_stats) == 2) {
		return string_join("\n", _stats[0], _stats[1])
	} else {
		return string_join("\n", _stats[0], _stats[1], _stats[2])
	}
}