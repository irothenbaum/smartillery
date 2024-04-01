rotate_aim_speed = 60;
rotate_idle_speed = 6;
rotate_speed = rotate_idle_speed;
rotate_to = 270;
image_angle = rotate_to;

function fire_at_instance(_inst) {
	debug("HIT", _inst);
	if (!_inst) {
		// do nothing
		return
	}
	rotate_speed = rotate_aim_speed;
	rotate_towards_instance(_inst)
	_inst.register_hit()
	alarm_set(0, 3000)
}

function rotate_towards_instance(_inst) {
	rotate_to = point_direction(x, y, _inst.x, _inst.y);
}