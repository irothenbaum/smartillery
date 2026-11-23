/// @description Initialize damage burst
// When the player takes damage, this burst expands out from the player and hits every enemy it passes over once,
// for 1 damage. That reacts like a normal hit (knockback, stun, ...), so 1-health enemies die and tougher ones get
// pushed back. It gives no rewards (points, streak, combo) -- its only purpose is to give the player a breather.
elapsed = 0 // this and the durations are in seconds
expand_duration = 0.3
fade_duration = 0.25
color = c_white
stroke = 16

start_radius = global.bg_cicle_min_radius
// the 6th ring out from the player (rings are indexed from the outside in)
end_radius = get_radius_for_ring(global.bg_number_of_circles - global.damage_burst_ring_count)
current_radius = start_radius

// every enemy the wave has already hit, so each one is only hit once as the wave passes
hit_enemies = []

function hit_enemies_in_radius(_radius) {
	// collect first: a hit can destroy enemies (or spawn new ones, e.g. frag shards) mid-iteration
	var _to_hit = []
	var _already_hit = hit_enemies
	with (obj_enemy_parent) {
		if (object_index != obj_training_target
			&& !array_contains(_already_hit, id)
			&& point_distance(x, y, other.x, other.y) <= _radius
		) {
			array_push(_to_hit, id)
		}
	}

	for (var _i = 0; _i < array_length(_to_hit); _i++) {
		array_push(hit_enemies, _to_hit[_i])
		if (instance_exists(_to_hit[_i])) {
			enemy_hit_without_reward(_to_hit[_i], 1)
		}
	}
}
