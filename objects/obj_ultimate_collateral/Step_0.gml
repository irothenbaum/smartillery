/// @description Ult step
ultimate_step(self)

var _instances = get_all_enemy_instances()
var _count = array_length(_instances)

for (var _i = 0; _i < _count; _i++) {
	var _e1 = _instances[_i]
	for (var _j = _i + 1; _j < _count; _j++) {
		var _e2 = _instances[_j]	
		if (point_distance(_e1.x, _e1.y, _e2.x, _e2.y) <= range) {
			pair_enemies(_e1, _e2)
		} else {
			unpair_enemies(_e1, _e2)
		}
	}
}

cleanup_paired_enemies()