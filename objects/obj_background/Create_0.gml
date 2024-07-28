x = room_width / 2
y = room_height / 2

number_of_circles = 20
center_circle_radius = 40
background_radius = sqrt(room_width * room_width + room_height * room_height) / 2
circle_magnitude = background_radius - center_circle_radius

starting_saturation = 120
starting_lumosity = 30
starting_alpha = 0.1
fade_speed = 0.1
grid_color = c_white

drawn_ring_line_alpha = array_create(number_of_circles, 0)
drawn_ring_hue = array_create(number_of_circles, 0)
drawn_ring_saturation = array_create(number_of_circles, 0)
drawn_ring_lumosity = array_create(number_of_circles, 0)
gradient_shadow = 0.5

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