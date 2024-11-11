direction = point_direction(x,y, global.xcenter, global.ycenter)
speed = 2

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