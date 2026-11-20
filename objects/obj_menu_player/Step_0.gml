shot_timer = max(0, shot_timer - step_seconds())

if (menu_item != noone && !instance_exists(menu_item)) {
	menu_item = noone
}

// a typed menu item takes over the turret until it's been shot and triggered
if (menu_item != noone) {
	if (menu_item_hit) {
		menu_trigger_timer -= step_seconds()
		if (menu_trigger_timer <= 0) {
			trigger_menu_item()
		}
	} else {
		var _hit = get_menu_item_world_position()
		rotate_speed = rotate_aim_speed
		rotate_to = point_direction(x, y, _hit.x, _hit.y)
	}
} else if (!instance_exists(target)) {
	// threats jump the queue; otherwise wait for the timer
	target = find_target(true)
	if (target == noone && shot_timer <= 0) {
		target = find_target(false)
	}
}

// (a menu item was already aimed at above)
if (menu_item == noone) {
	if (target != noone) {
		rotate_speed = rotate_aim_speed
		rotate_to = point_direction(x, y, target.x, target.y)
	} else {
		idle_timer += step_seconds()
		if (idle_timer >= idle_delay) {
			rotate_speed = rotate_idle_speed
			rotate_to = direction
		}
	}
}

// same turning as obj_player
var _angle_dif = angle_difference(rotate_to, image_angle)
var _abs_angle_dif = abs(_angle_dif)
var _rotate_step = rotate_speed / game_get_speed(gamespeed_fps)
image_angle += sign(_angle_dif) * min(_abs_angle_dif, _rotate_step)

if (_abs_angle_dif < 1) {
	if (menu_item != noone) {
		if (!menu_item_hit) {
			fire_at_menu_item()
		}
	} else if (target != noone) {
		fire_at_target()
	}
}

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.85
} else {
	recoil_amount = 0
}
