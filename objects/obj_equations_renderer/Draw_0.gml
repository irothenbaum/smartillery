/// @description Draws all instances with equations
// would be nicer to determine this set dynamically

var _all_enemies = get_all_enemy_instances()
var _bonus_items = get_array_of_instances(obj_bonus_item_parent)

var _all_drawable = array_concat(_all_enemies, _bonus_items)
var _drawable_count = array_length(_all_drawable)

// memoize each enemy's distance to player center
var _enemy_distances = {}
for (var _i = 0; _i < _drawable_count; _i++) {
	var _this_enemy = _all_drawable[_i]
	_enemy_distances[_this_enemy] = point_distance(_this_enemy.x, _this_enemy.y, global.xcenter, global.ycenter)
}

// sort all enemies by distance (reverse order because we want closest to draw last)
array_sort(_all_drawable, method({_distances: _enemy_distances}, function(_e1, _e2) {
	// sign() keeps the comparator consistent -- array_sort treats the result as an integer, so float differences under 1 would read as "equal"
	return sign(_distances[_e2] - _distances[_e1])
}))

// draw each equation
for (var _i = 0; _i < _drawable_count; _i++) {
	instance_draw_equation(_all_drawable[_i])
}