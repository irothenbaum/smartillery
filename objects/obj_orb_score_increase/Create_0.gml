debug("[LEECH] orb created:", id, "type:", type, "amount:", amount, "owner:", owner_player_id, "at", x, y)
direction = point_direction(x,y, global.xcenter, global.ycenter)
// since orbs can be created during Air Strike, we need to check if we're currently paused or not
paused_speed = 2
is_paused = global.paused
speed = is_paused ? 0 : paused_speed

orbs = []
cloud_radius = ORB_CLOUD_RADIUS

color = get_orb_color(type, owner_player_id)

var _values = split_orb_amount(amount)
for (var _i = 0; _i < array_length(_values); _i++) {
	array_push(orbs, {
		x_diff: 0,
		y_diff: 0,
		x_target: irandom_range(-cloud_radius, cloud_radius),
		y_target: irandom_range(-cloud_radius, cloud_radius),
		value: _values[_i],
	})
}

// optional start_offsets ([{x, y}], passed in on creation): where the first orbs start relative to x/y, so something
// that was already drawing orbs (e.g. the points power item's cluster) hands them off without a jump
if (variable_instance_exists(id, "start_offsets")) {
	for (var _i = 0; _i < min(array_length(start_offsets), array_length(orbs)); _i++) {
		orbs[_i].x_diff = start_offsets[_i].x
		orbs[_i].y_diff = start_offsets[_i].y
	}
}