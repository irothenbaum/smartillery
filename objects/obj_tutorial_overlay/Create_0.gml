/// @description Store references to postitions
hud = instance_find(obj_hud, 0)
player = get_player()
game_controller = get_game_controller()


ultimate_icons = get_array_of_instances(obj_hud_ultimate_icon)
user_inputs = get_array_of_instances(obj_input)

wave_description = {
	x: hud.pos_wave.bounds.xcenter,
	y: hud.pos_wave.bounds.y1 + global.margin_xl,
	align: ALIGN_CENTER
}

score_description = {
	x: hud.pos_score.bounds.xcenter,
	y: hud.pos_score.bounds.y1 + global.margin_xl,
	align: ALIGN_CENTER
}

function draw_ultimate_level_details(_player_id, _ult_bounds) {
	var _circle_radius = _ult_bounds.y1 - _ult_bounds.ycenter
	var _level_center = {
		x: _ult_bounds.xcenter + lengthdir_x(_circle_radius, 315),
		y: _ult_bounds.ycenter + lengthdir_y(_circle_radius, 315),
	}
	
	var _details_title_center = {
		x: _ult_bounds.xcenter + _circle_radius * 2,
		y: _ult_bounds.ycenter,
	}
	
	var _ultimate_level = game_controller.ultimate_level[$ _player_id]
	var _player_ultimate = get_player_ultimate(_player_id)
	
	var _this_level_stats = get_ultimate_stats(_player_ultimate, _ultimate_level)
	var _next_level_stats = get_ultimate_stats(_player_ultimate, _ultimate_level + 1)
	
	draw_line_between(_level_center.x, _level_center.y, _details_title_center.x, _details_title_center.y)
	
	draw_set_font(fnt_large)
	var _new_bounds = draw_text_with_alignment(_details_title_center.x, _details_title_center.y, string_concat(global.ultimate_descriptions[$ _player_ultimate].title, " -- lvl ", _ultimate_level), ALIGN_LEFT)
	draw_set_font(fnt_base)
	_new_bounds = draw_text_with_alignment(_new_bounds.x0, _new_bounds.y1 + global.margin_md, _this_level_stats, ALIGN_LEFT)
	
	draw_line_width(_new_bounds.x0, _new_bounds.y1 + global.margin_md, _new_bounds.x1 + global.margin_xl, _new_bounds.y1 + global.margin_md, 1)
	
	draw_text_with_alignment(_new_bounds.x0, _new_bounds.y1 + global.margin_xl, string_concat("Next Level:\n", _next_level_stats), ALIGN_LEFT)
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
			array_push(_stats, string_concat("+", ult_heal_get_leech_amount(_level), " health per strike"))
			array_push(_stats, string_concat("Duration: ", round((ult_heal_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		case ULTIMATE_STRIKE:
			array_push(_stats, string_concat(ult_strike_get_count(_level), " strikes"))
			break
		
		case ULTIMATE_SLOW:
			array_push(_stats, string_concat("Slow amount: ", round(ult_slow_get_speed_multiplier(_level) * 100), "%"))
			array_push(_stats, string_concat("Duration: ", round((ult_slow_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		case ULTIMATE_COLLATERAL:
			array_push(_stats, string_concat("Chain distance: ", round(ult_collateral_get_radius(_level))))
			array_push(_stats, string_concat("Duration: ", round((ult_collateral_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		// TODO: More types here
	}
	
	return array_reduce(_stats, function(_agr, _s) {
		return string_join(_agr, "\n", _s)
	}, "")
	
}