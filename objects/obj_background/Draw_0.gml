var _player_health = get_player().my_health
var _ring_enemy_counts = array_create(global.bg_number_of_circles, 0)
for_each_enemy(filter_by_distance_to_player, _ring_enemy_counts)
var _skipped_rings = global.bg_number_of_circles - ceil(global.bg_number_of_circles * (_player_health / global.max_health))

drawn_skipped_rings = lerp(drawn_skipped_rings, _skipped_rings, global.fade_speed)

var _options = {
	is_ulting: get_game_controller().is_ulting(),
	player_health: _player_health,
	// from 210 for full health to 255 for 0 health
	health_hue: 255 - (_player_health / global.max_health) * 45,
	skipped_rings: _skipped_rings,
	rounded_skipped_rings: round(drawn_skipped_rings)
}

for(var _i = 0; _i < global.bg_number_of_circles; _i++) {	
	_options.enemies_on_ring = _ring_enemy_counts[_i]
	
	var _fade_speed = get_fade_speed_for_ring(_i,_options)
	
	drawn_ring_hue[_i] = lerp(drawn_ring_hue[_i], get_hue_for_ring(_i, _options), _fade_speed)
	drawn_ring_saturation[_i] = lerp(drawn_ring_saturation[_i], get_saturation_for_ring(_i, _options), _fade_speed)
	drawn_ring_lumosity[_i] = lerp(drawn_ring_lumosity[_i], get_lumosity_for_ring(_i, _options), _fade_speed)
	drawn_ring_line_alpha[_i] = lerp(drawn_ring_line_alpha[_i], get_line_alpha_for_ring(_i, _options), global.fade_speed)
	
	var _color = make_color_hsv(drawn_ring_hue[_i], drawn_ring_saturation[_i], drawn_ring_lumosity[_i]);
	draw_set_circle_precision((global.bg_number_of_circles - _i) * 2 + 32)
	var _this_radius = get_radius_at_i(_i)
	draw_circle_color(x, y, _this_radius, _color, _color, false)
	draw_set_composite_color(composite_color(grid_color, drawn_ring_line_alpha[_i]))
	draw_circle(x,y, _this_radius, true)
	reset_composite_color()
}
