x = room_width / 2
y = room_height / 2

draw_idle_color = true
idle_hue = color_get_hue(global.bg_color)
heal_hue_tint = color_get_hue(global.heal_color_tint)
heal_hue = color_get_hue(global.heal_color)

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

heal_hues = [heal_hue, heal_hue_tint]
heal_hues_count = array_length(heal_hues)
function get_heal_hue_from_time(_shift) {
	// every 1 second we select the next heal_hue by index as determined by current_time
	return heal_hues[round((current_time + _shift) / 1000) % heal_hues_count]
}



function get_hue_for_ring(_i, _options) {
	var _this_hue = _options.is_healing ? get_heal_hue_from_time(_i * 100) : (draw_idle_color ? idle_hue : _options.health_hue)	

	if(_i < round(drawn_skipped_rings)) {  
		_this_hue = 0
	} else {
		// do nothing
	}
	
	return _this_hue
}

function get_saturation_for_ring(_i, _options) {
	var _this_saturation = starting_saturation
	
	if(_i < round(drawn_skipped_rings)) {  
		_this_saturation = 0
	} else {
		_this_saturation = _options.is_healing ? starting_saturation + 60 : starting_saturation
		_this_saturation += 15 * _options.enemies_on_ring
	}
	
	return _this_saturation
}

function get_lumosity_for_ring(_i, _options) {
	var _this_lumosity = starting_lumosity
	
	if(_i < round(drawn_skipped_rings)) { 
		_this_lumosity = starting_lumosity * 0.4
	} else {
		_this_lumosity = _options.is_healing ? starting_lumosity + 40 : starting_lumosity 
		_this_lumosity += 10 * _options.enemies_on_ring // - ((number_of_circles - _i) * gradient_shadow)
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
		// do nothing
	} else {
		_fade_speed_multiplier = _options.is_healing ? 2 : (draw_idle_color ? 5 : 1)
	}
	
	return global.fade_speed / _fade_speed_multiplier
}