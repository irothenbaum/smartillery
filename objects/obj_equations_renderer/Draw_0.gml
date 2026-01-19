/// @description Draws all enemy equations

var _all_enemies = get_all_enemy_instances()
var _enemies_count = array_length(_all_enemies)

// memoize each enemy's distance to player center
var _enemy_distances = {}
for (var _i = 0; _i < _enemies_count; _i++) {
	var _this_enemy = _all_enemies[_i]
	_enemy_distances[_this_enemy] = point_distance(_this_enemy.x, _this_enemy.y, global.xcenter, global.ycenter)
}

// sort all enemies by distance
// TODO: may need to reverse this array?
array_sort(_all_enemies, method({_distances: _enemy_distances}, function(_e1, _e2) {
	return _distances[_e1] - _distances[_e2]
}))

// draw each equation
for (var _i = 0; _i < _enemies_count; _i++) {
	enemy_draw_equation(_all_enemies[_i])
}