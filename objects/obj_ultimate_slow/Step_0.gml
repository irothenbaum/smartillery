/// @description Scan for enemies in our radius
// copied to a local because enemies have their own slow_multiplier variable
var _slow_amount = slow_multiplier
with (obj_enemy_parent) {
	enemy_apply_slow(id, _slow_amount)
}

ultimate_step(self)