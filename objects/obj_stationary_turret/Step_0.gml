/// @description Fire at enemies in range
tip_step(self)
if (global.paused) {
	return
}

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.85
} else {
	recoil_amount = 0
}

if (can_fire) {
	var _target = find_target()
	if (_target != noone) {
		fire_at(_target)
	}
}
