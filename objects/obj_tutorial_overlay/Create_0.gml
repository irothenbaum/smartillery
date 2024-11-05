/// @description Store references to postitions
hud = instance_find(obj_hud, 0)
player = get_player()
input = instance_find(obj_input, 0)
game_controller = get_game_controller()
ultimate_icon = instance_find(obj_hud_ultimate_icon, 0)


wave_description = {
	x: 200,
	y: 160,
	align: ALIGN_CENTER
}

score_description = {
	x: global.room_width - 200,
	y: 160,
	align: ALIGN_CENTER
}

input_description = {
	x: global.room_width / 2 - 200,
	y: 220,
	align: ALIGN_CENTER
}

ultimate_description = {
	x: global.room_width / 2 ,
	y: 160,
	align: ALIGN_LEFT
}




function draw_line_between(_x0, _y0, _x1, _y1) {
	_y0 += 10
	_y1 -= 30
	
	var _thickness = 2
	var _half_y = _y0 + (_y1 - _y0) / 2
	
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
		x: _ult_bounds.xcenter + lengthdir_x(200, 270),
		y: _ult_bounds.ycenter + lengthdir_y(200, 270),
	}
	draw_line_between(_level_center.x, _level_center.y, _details_center.x, _details_center.y)
	
	var _this_level_stats = get_ultimate_stats(game_controller.ultimate_level)
	var _next_level_stats = get_ultimate_stats(game_controller.ultimate_level + 1)
	
	draw_set_font(fnt_base)
	var _new_bounds = draw_text_with_alignment(_details_center.x, _details_center.y, global.ultimate_descriptions[$ global.selected_ultimate].title, ultimate_description.align)
	draw_set_font(fnt_small)
	_new_bounds = draw_text_with_alignment(_details_center.x, _new_bounds.y1 + 20, _this_level_stats, ALIGN_LEFT)
	
	draw_line_width(_new_bounds.x0, _new_bounds.y0, _new_bounds.x1, _new_bounds.y1, 1)
	
	draw_text_with_alignment(_details_center.x, _new_bounds.y1 + 20, string_concat("Next Level:\n", _next_level_stats), ALIGN_LEFT)
}

function get_ultimate_stats(_level) {
	var _stats = []
	var _frames_to_seconds = game_get_speed(gamespeed_fps)
	switch (global.selected_ultimate) {
		case ULTIMATE_HEAL:
			array_push(_stats, string_concat("Heal rate: ", round(ult_heal_get_rate(_level) * _frames_to_seconds * 10) / 10, " /s"))
			array_push(_stats, string_concat("Duration: ", round(ult_heal_get_duration(_level) * _frames_to_seconds * 10) / 10, " seconds"))
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
			array_push(_stats, string_concat("Slow amount: ", ult_slow_get_speed_multiplier(_level) * 100, "%"))
			array_push(_stats, string_concat("Duration: ", round(ult_slow_get_duration(_level) * _frames_to_seconds * 10) / 10, " seconds"))
			array_push(_stats, string_concat("Effect distance: ", ult_slow_get_radius(_level)))
			break
	}
	
	return string_join("\n", _stats[0], _stats[1], _stats[2])
}