/// @description Insert description here
animation_progress = (get_play_time() - spawn_time) / rotation_duration_ms

if (animation_progress >= 1 && (!instance_exists(target) || target_was_hit)) {
	instance_destroy();
}

if (instance_exists(target)) {
	x = target.x
	y = target.y
}

