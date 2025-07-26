x = global.xcenter
y = global.ycenter	

idle_hue = color_get_hue(global.bg_color)
idle_saturation = color_get_saturation(global.bg_color)
idle_lumosity = color_get_value(global.bg_color)

grid_color = c_white

drawn_ring_line_alpha = array_create(global.bg_number_of_circles, 0)
drawn_ring_hue = array_create(global.bg_number_of_circles, idle_hue)
drawn_ring_saturation = array_create(global.bg_number_of_circles, 0)
drawn_ring_lumosity = array_create(global.bg_number_of_circles, 0)
gradient_shadow = 0.5
drawn_skipped_rings = global.bg_number_of_circles
game_controller = get_game_controller()
booting_up = true
boot_up_time = 1 * game_get_speed(gamespeed_fps)
alarm[0] = boot_up_time


function filter_by_distance_to_player(_instance, _index, _ring_enemy_counts) {
	var _distance_to_player = point_distance(_instance.x, _instance.y, global.xcenter, global.ycenter)
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

strike_hue = color_get_hue(global.ultimate_colors[$ ULTIMATE_STRIKE])

slow_hue = color_get_hue(global.ultimate_colors[$ ULTIMATE_SLOW])
slow_tint_hue = color_get_hue(global.ultimate_color_tints[$ ULTIMATE_SLOW])

function get_hue_for_ring(_i, _options) {
	var _this_hue = _options.health_hue;
	
	if (_options.is_ulting_strike) {
		_this_hue = _options.enemies_on_ring == 0 ? 0 : strike_hue
	} else if (_i < _options.rounded_skipped_rings) {
		_this_hue = 0
	}
	
	return _this_hue
}

function get_saturation_for_ring(_i, _options) {
	var _this_saturation = idle_saturation
	
	if (_options.is_ulting_strike) {
		_this_saturation = _options.enemies_on_ring == 0 ? 0 : 255
	} else if (_i < _options.rounded_skipped_rings) {
		_this_saturation = 0
	} else if (_options.player_health < global.max_health) {
		_this_saturation = idle_saturation + ((255 - idle_saturation) * ease_in_quad((global.max_health - _options.player_health) / global.max_health))
	}
		
	_this_saturation += 15 * _options.enemies_on_ring
	
	return _this_saturation
}

function get_lumosity_for_ring(_i, _options) {
	var _this_lumosity = idle_lumosity
	
	if (_options.is_ulting_strike) {
		_this_lumosity = _options.enemies_on_ring == 0 ? 0 : 128
	} else if (_i < _options.rounded_skipped_rings) {
		_this_lumosity = idle_lumosity * 0.4
	} else if (_options.player_health < global.max_health) {
		_this_lumosity = idle_lumosity + ((180 - idle_lumosity) * ease_in_quad((global.max_health - _options.player_health) / global.max_health))
	}

	_this_lumosity += 10 * _options.enemies_on_ring
	
	return _this_lumosity
}

function get_line_alpha_for_ring(_i, _options) {
	var _line_alpha = 0.1
	
	if(_i < _options.rounded_skipped_rings) {  
		_line_alpha = _line_alpha / 2	
	} else if (_options.rounded_skipped_rings > 0 && _i == _options.rounded_skipped_rings) {
		// make the edge of our missing health bar extra bright
		_line_alpha = 0.5
	}
	
	return _line_alpha
}

function get_fade_speed_for_ring(_i, _options) {
	var _fade_speed_multiplier = 1
	
	// TODO: could have logic in here if needed
	
	return global.fade_speed / _fade_speed_multiplier
}