if (global.paused) {
	return
}

speed = min(10, speed * 1.1)

for (var _i=0; _i < array_length(orbs); _i++) {
	var _orb = orbs[_i]
	
	if (abs(_orb.x_diff - _orb.x_target) + abs(_orb.y_diff - _orb.y_target) < 2) {
		_orb.x_target = irandom_range(-cloud_radius, cloud_radius)
	}
	
	_orb.x_diff = lerp(_orb.x_diff, _orb.x_target, 0.05)
	_orb.y_diff = lerp(_orb.y_diff, _orb.y_target, 0.05)
}