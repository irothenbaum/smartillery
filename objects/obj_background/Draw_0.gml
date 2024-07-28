var _player_health = get_player().my_health
var _health_hue = _player_health * 0.7
var _ring_enemy_counts = array_create(number_of_circles, 0)
for_each_enemy(filter_by_distance_to_player, _ring_enemy_counts)

var _skipped_rings = number_of_circles - floor(number_of_circles * (_player_health / global.max_health))

for(var _i = 0; _i < number_of_circles; _i++) {
	var _this_lumosity = starting_lumosity
	var _this_saturation = starting_saturation
	var _this_hue = _health_hue
	var _line_alpha = starting_alpha
	var _number_of_enemies_on_ring = _ring_enemy_counts[_i]
	if (_i < _skipped_rings) {
		_this_lumosity = starting_lumosity * 0.4
		_this_saturation = 0
		_line_alpha = _line_alpha / 2
		_health_hue = 0
	} else {
		_this_lumosity = starting_lumosity + 10 * _number_of_enemies_on_ring - ((number_of_circles - _i) * gradient_shadow)
		_this_saturation = starting_saturation + 15 * _number_of_enemies_on_ring
		_line_alpha = starting_alpha
	}
	
	drawn_ring_hue[_i] = lerp(drawn_ring_hue[_i], _this_hue, fade_speed)
	drawn_ring_saturation[_i] = lerp(drawn_ring_saturation[_i], _this_saturation, fade_speed)
	drawn_ring_lumosity[_i] = lerp(drawn_ring_lumosity[_i], _this_lumosity, fade_speed)
	drawn_ring_line_alpha[_i] = lerp(drawn_ring_line_alpha[_i], _line_alpha, fade_speed)
	
	var _color = make_color_hsv(drawn_ring_hue[_i], drawn_ring_saturation[_i], drawn_ring_lumosity[_i]);
	draw_set_circle_precision((number_of_circles - _i) * 2 + 32)
	var _this_radius = get_radius_at_i(_i)
	draw_circle_color(x,y, _this_radius, _color, _color, false)
	draw_set_alpha(drawn_ring_line_alpha[_i])
	draw_set_color(grid_color)
	draw_circle(x,y, _this_radius, true)
	draw_set_alpha(1)
}

// now we lerp the drawn_ring_enemy_counts