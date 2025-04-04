direction = point_direction(x,y, global.xcenter, global.ycenter)
// since orbs can be created during Air Strike, we need to check if we're currently paused or not
paused_speed = 2
is_paused = global.paused
speed = is_paused ? 0 : paused_speed

orbs = []
cloud_radius = 30

var _amount_copy = amount
do {
	var _this_orb = min(5, _amount_copy)
	array_push(orbs, {
		x_diff: 0,
		y_diff: 0,
		x_target: irandom_range(-cloud_radius, cloud_radius),
		y_target: irandom_range(-cloud_radius, cloud_radius),
		value: _this_orb,
	})
	_amount_copy -= _this_orb
} until(_amount_copy <= 0)