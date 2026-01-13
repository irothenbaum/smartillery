var _player_health = get_player().my_health
var _ring_enemy_counts = array_create(global.bg_number_of_circles, 0)
for_each_enemy(filter_by_distance_to_player, _ring_enemy_counts)
var _skipped_rings = global.bg_number_of_circles - ceil(global.bg_number_of_circles * (booting_up ? (1 - (alarm[0] / boot_up_time)) : (_player_health / global.max_health)))

drawn_skipped_rings = lerp(drawn_skipped_rings, _skipped_rings, global.fade_speed)

var _rings_ult = instance_find(obj_ultimate_rings, 0)
var _options = {
	is_ulting_strike: game_controller.is_ult_active(ULTIMATE_STRIKE),
	is_ulting_rings: game_controller.is_ult_active(ULTIMATE_RINGS),
	rings_ult_instance: _rings_ult,
	player_health: _player_health,
	// from 210 for full health to 255 for 0 health
	health_hue: 255 - (_player_health / global.max_health) * 45,
	skipped_rings: _skipped_rings,
	rounded_skipped_rings: round(drawn_skipped_rings)
}

for(var _i = 0; _i < global.bg_number_of_circles; _i++) {	
	_options.enemies_on_ring = _ring_enemy_counts[_i]
	
	var _fade_speed = get_fade_speed_for_ring(_i,_options)
	var _ring_color = get_ring_color(_i, _options)
	
	drawn_ring_color[_i] = lerp_color(drawn_ring_color[_i], _ring_color, 0.2)
	
	/*
	drawn_ring_hue[_i] = lerp(drawn_ring_hue[_i], get_hue_for_ring(_i, _options), _fade_speed)
	drawn_ring_saturation[_i] = lerp(drawn_ring_saturation[_i], get_saturation_for_ring(_i, _options), _fade_speed)
	drawn_ring_lumosity[_i] = lerp(drawn_ring_lumosity[_i], get_lumosity_for_ring(_i, _options), _fade_speed)
	var _color = make_color_hsv(drawn_ring_hue[_i], drawn_ring_saturation[_i], drawn_ring_lumosity[_i]);
	*/
	
	draw_set_composite_color(drawn_ring_color[_i])
	draw_set_circle_precision(circle_precision[_i])
	draw_circle(x, y, ring_radius[_i], false)
	
	drawn_ring_line_alpha[_i] = lerp(drawn_ring_line_alpha[_i], get_line_alpha_for_ring(_i, _options), global.fade_speed)
	draw_set_composite_color(new CompositeColor(grid_color, drawn_ring_line_alpha[_i]))
	draw_circle(x,y, ring_radius[_i], true)
	reset_composite_color()
}