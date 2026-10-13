/// @description Block enemies that reach the ring
if (global.paused) {
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

	if (!instance_exists(other)) {
		break
	}
}
