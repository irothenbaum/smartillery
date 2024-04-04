rotate_aim_speed = 360 // in degrees per second
rotate_idle_speed = 90 // in degrees per frame
rotate_speed = rotate_idle_speed;
rotate_to = 90;
aiming_at_instance = undefined
image_angle = rotate_to;
x = room_width / 2
y = room_height / 2

function fire_at_instance(_inst) {
	if (!_inst) {
		// do nothing
		return
	}
	alarm[0] = -1
	aiming_at_instance = _inst
	rotate_speed = rotate_aim_speed;
	rotate_to = point_direction(x, y, _inst.x, _inst.y);
}

function execute_hit_target() {
	if (not aiming_at_instance) {
		debug("This shouldn't happen -- execute_hit_target -> not aiming_at_instance")
		return
	}
	
	aiming_at_instance.register_hit()
	aiming_at_instance = undefined
	
	// after a few seconds, reset to vertical postion
	alarm[0] = game_get_speed(gamespeed_fps) * (MESSAGE_SHOW_DURATION * 0.7)
}

function execute_take_damage() {
	
}