/// @description Scan for enemies in our radius
for_each_enemy(function(_enemy, _index, _slow_amount) {
	enemy_apply_slow(_enemy, _slow_amount)
}, slow_multiplier)

ultimate_step(self)