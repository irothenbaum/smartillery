/// @description Block enemies that reach the ring
if (global.paused) {
	return
}

if (collapsing) {
	collapse_elapsed += step_seconds()
	// ease in so it snaps shut quickly at the end
	var _progress = min(1, collapse_elapsed / collapse_duration)
	drawn_thickness = lerp(thickness, collapse_min_thickness, _progress * _progress)

	if (collapse_elapsed >= collapse_duration + collapse_hold_duration) {
		instance_destroy()
	}
	return
}

with (obj_enemy_parent) {
	if (object_index == obj_training_target) {
		continue
	}

	// overlapping the ring band -- enemies already inside it (between the ring and the player) never cross it
	var _distance = point_distance(x, y, other.x, other.y)
	if (abs(_distance - other.radius) > other.thickness / 2 + abs(sprite_width) / 2) {
		continue
	}

	enemy_destroy_without_reward(id)
	other.absorb_hit()

	if (other.collapsing) {
		break
	}
}
