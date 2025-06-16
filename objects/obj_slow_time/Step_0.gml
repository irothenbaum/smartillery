/// @description Scan for enemies in our radius
for_each_enemy(function(_enemy, _index, _distance, _slow_amount) {
	if (point_distance(global.xcenter, global.ycenter, _enemy.x, _enemy.y) <= _distance) {
		enemy_apply_slow(_enemy, _slow_amount)
	} else {
		enemy_remove_slow(_enemy)
	}
}, range, slow_multiplier)

var _gc = get_game_controller()
_gc.ultimate_charge = max(0, global.ultimate_requirement * alarm[0] / starting_duration)

ultimate_step(self)