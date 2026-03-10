/// @description Animate progress
animation_progress = (get_play_time() - spawn_time) / rotation_duration_ms

// animation always finishes, but it's possible it needs to hang around longer (if the fire-at queue is long)
if (animation_progress >= 1 && (!instance_exists(target) || target_was_hit)) {
	instance_destroy();
}

// follow the instance if it's moving and still exists
if (instance_exists(target)) {
	x = target.x
	y = target.y
}
