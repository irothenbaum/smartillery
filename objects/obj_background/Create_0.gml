x = room_width / 2
y = room_height / 2

draw_idle_color = true
idle_hue = color_get_hue(global.bg_color)
black_hue = color_get_hue(#000000)

number_of_circles = 20
center_circle_radius = 40
background_radius = sqrt(room_width * room_width + room_height * room_height) / 2
circle_magnitude = background_radius - center_circle_radius

starting_saturation = 120
starting_lumosity = 40
starting_alpha = 0.1
grid_color = c_white

drawn_ring_line_alpha = array_create(number_of_circles, 0)
drawn_ring_hue = array_create(number_of_circles, 0)
drawn_ring_saturation = array_create(number_of_circles, 0)
drawn_ring_lumosity = array_create(number_of_circles, 0)
gradient_shadow = 0.5
drawn_skipped_rings = 0

function get_radius_at_i(_i) {
	return background_radius - ((_i / number_of_circles) * circle_magnitude)
}

// this inverse of get_radius_at_i
function get_ring_from_distance(_distance) {
	// _distance = background_radius - (_i / number_of_circles * _circle_magnitude)
	//  number_of_circles * (background_radius - _distance) / _circle_magnitude = _i
	return  floor(number_of_circles * (background_radius - _distance) / circle_magnitude)
}

function filter_by_distance_to_player(_instance, _index, _ring_enemy_counts) {
	var _player = get_player();
	var _distance_to_player = point_distance(_instance.x, _instance.y, _player.x, _player.y)
	var _ring_number = get_ring_from_distance(_distance_to_player)
	if (_ring_number >= 0 && _ring_number < array_length(_ring_enemy_counts)) {
		_ring_enemy_counts[_ring_number]++ 
	}
}

var _c1 = global.ultimate_colors[$ ULTIMATE_HEAL]
var _c2 = global.ultimate_color_tints[$ ULTIMATE_HEAL]
var _c12 = color_get_hue(_c1)
var _c22 = color_get_hue(_c2)
heal_hues = [_c12, _c22]
heal_hues_count = array_length(heal_hues)


function get_hue_for_ring(_i, _options) {
	var _this_hue = undefined;
	if(_i < round(drawn_skipped_rings)) {  
		_this_hue = 0
	} else if (_options.is_ulting) {
		switch (global.selected_ultimate) {
			case ULTIMATE_HEAL:
				var _shift = _i * 100
				// every 300ms we select the next heal_hue by index as determined by current_time
				_this_hue = heal_hues[round((current_time + _shift) / 300) % heal_hues_count]
				break
				
			case ULTIMATE_STRIKE:
				_this_hue = _options.enemies_on_ring == 0 ? black_hue : global.ultimate_colors[$ ULTIMATE_STRIKE]
				break
				
			case ULTIMATE_SLOW:
				_this_hue = _options.enemies_on_ring == 0 ? global.ultimate_color_tints[$ ULTIMATE_SLOW] : global.ultimate_colors[$ ULTIMATE_SLOW]
				break
							
			case ULTIMATE_NONE:
				_this_hue = idle_hue
		}
	} else if (draw_idle_color) {
		_this_hue = idle_hue
	} else {
		_this_hue = _options.health_hue
	}
	
	return _this_hue
}

function get_saturation_for_ring(_i, _options) {
	var _this_saturation = starting_saturation
	
	if(_i < round(drawn_skipped_rings)) {  
		_this_saturation = 0
	} else {
		if (_options.is_ulting) {
			switch (global.selected_ultimate) {
				case ULTIMATE_HEAL:
					_this_saturation = starting_saturation + 60
					break
					
				case ULTIMATE_STRIKE:
					_this_saturation = _options.enemies_on_ring == 0 ? 0 : 255
					break
				
				case ULTIMATE_SLOW:
					_this_saturation = 128
					break
				
				case ULTIMATE_NONE:
					_this_saturation = starting_saturation
			}
			_this_saturation = starting_saturation + 60
		} else if (_options.player_health < global.max_health) {
			_this_saturation += 60 * (global.max_health - _options.player_health) / global.max_health
		}
		
		_this_saturation += 15 * _options.enemies_on_ring
	}
	
	return _this_saturation
}

function get_lumosity_for_ring(_i, _options) {
	var _this_lumosity = starting_lumosity
	
	if(_i < round(drawn_skipped_rings)) { 
		_this_lumosity = starting_lumosity * 0.4
	} else {
		if (_options.is_ulting) {
			switch (global.selected_ultimate) {
				case ULTIMATE_HEAL:
					var _shift = _i * 100
					_this_lumosity = round((current_time + _shift) / 300) % heal_hues_count == 1 ? starting_lumosity + 40 : starting_lumosity
					break
					
				case ULTIMATE_STRIKE:
					_this_lumosity = _options.enemies_on_ring == 0 ? 0 : 128
					break
					
				case ULTIMATE_SLOW:
					_this_lumosity = _options.enemies_on_ring == 0 ? 60 : 100
					break
					
				case ULTIMATE_NONE:
					_this_lumosity = starting_lumosity
					break
			}
		} else if (_options.player_health < global.max_health) {
			_this_lumosity += 30 * (global.max_health - _options.player_health) / global.max_health
		}

		_this_lumosity += 10 * _options.enemies_on_ring
	}
	
	return _this_lumosity
}

function get_line_alpha_for_ring(_i, _options) {
	var _line_alpha = starting_alpha
	
	if(_i < round(drawn_skipped_rings)) {  
		_line_alpha = _line_alpha / 2	
	} else {
		_line_alpha = starting_alpha
	}
	
	return _line_alpha
}

function get_fade_speed_for_ring(_i, _options) {
	var _fade_speed_multiplier = 1
	
	if (_i < round(drawn_skipped_rings)) {
		// do nothing fade multiplier should stay at 1
	} else {
		if (_options.is_ulting && global.selected_ultimate == ULTIMATE_HEAL && _i >= drawn_skipped_rings) {
			_fade_speed_multiplier = 1 + 6 * (1 - (_i / number_of_circles))
		} else {
			// keep it at 1
		}
	}
	
	return global.fade_speed / _fade_speed_multiplier
}