/// @description Store references to postitions
hud = instance_find(obj_hud, 0)
player = get_player()
input = instance_find(obj_input, 0)
game_controller = get_game_controller()


ultimate_icons = get_array_of_instances(obj_hud_ultimate_icon)
user_inputs = get_array_of_instances(obj_input)

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

function draw_ultimate_level_details(_player_id, _ult_bounds) {
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
	
	var _this_level_stats = get_ultimate_stats(get_player_ultimate(_player_id), game_controller.ultimate_level[$ _player_id])
	var _next_level_stats = get_ultimate_stats(get_player_ultimate(_player_id), game_controller.ultimate_level[$ _player_id] + 1)
	
	draw_set_font(fnt_large)
	var _new_bounds = draw_text_with_alignment(_details_center.x, _details_center.y, string_concat(global.ultimate_descriptions[$ get_player_ultimate(get_my_steam_id_safe())].title, " -- lvl ", game_controller.ultimate_level), ALIGN_CENTER)
	draw_set_font(fnt_base)
	_new_bounds = draw_text_with_alignment(_new_bounds.x0, _new_bounds.y1 + 20, _this_level_stats, ALIGN_LEFT)
	
	draw_line_width(_new_bounds.x0, _new_bounds.y1 + 20, _new_bounds.x1 + 60, _new_bounds.y1 + 20, 1)
	
	draw_text_with_alignment(_new_bounds.x0, _new_bounds.y1 + 50, string_concat("Next Level:\n", _next_level_stats), ALIGN_LEFT)
}

/**
 * @param {String} _ultimate
 * @param {Real} _level
 */
function get_ultimate_stats(_ultimate, _level) {
	var _stats = []
	var _frames_to_seconds = game_get_speed(gamespeed_fps)
	// TODO: More ultimate types
	switch (_ultimate) {
		case ULTIMATE_HEAL:
			array_push(_stats, string_concat("Duration: ", round((ult_heal_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			array_push(_stats, string_concat("+", ult_heal_get_leech_amount(_level), " health per kill"))
			break
			
		case ULTIMATE_STRIKE:
			array_push(_stats, string_concat(ult_strike_get_count(_level), " strikes"))
			break
		
		case ULTIMATE_SLOW:
			array_push(_stats, string_concat("Slow amount: ", round(ult_slow_get_speed_multiplier(_level) * 100), "%"))
			array_push(_stats, string_concat("Duration: ", round((ult_slow_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			array_push(_stats, string_concat("Effect distance: ", ult_slow_get_radius(_level)))
			break
	}
	
	return array_reduce(_stats, function(_agr, _s) {
		return string_join(_agr, "\n", _s)
	}, "")
	
}