/// @description Initialize damage burst
// When the player takes damage, this burst expands out from the player and wipes out every enemy
// it passes over. It gives no rewards -- its only purpose is to give the player a breather.
elapsed = 0 // this and the durations are in seconds
expand_duration = 0.3
fade_duration = 0.25
color = c_white
stroke = 16

start_radius = global.bg_cicle_min_radius
// the 6th ring out from the player (rings are indexed from the outside in)
end_radius = get_radius_for_ring(global.bg_number_of_circles - global.damage_burst_ring_count)
current_radius = start_radius

function destroy_enemies_in_radius(_radius) {
	var _destroyed_any = false
	var _enemies = get_all_enemy_instances()
	for (var _i = 0; _i < array_length(_enemies); _i++) {
		var _e = _enemies[_i]
		if (!instance_exists(_e) || _e.object_index == obj_training_target) {
			continue
		}
		if (point_distance(x, y, _e.x, _e.y) <= _radius) {
			with (_e) {
				// handle_enemy_killed reads this to skip all points / bonuses
				killed_by_damage_burst = true
				last_hit_by_player_id = undefined
				instance_destroy()
			}
			_destroyed_any = true
		}
	}

	// the turret may have been queued to fire at something we just destroyed
	if (_destroyed_any) {
		with (get_player()) {
			aiming_at_instance = array_filter(aiming_at_instance, function(_entry) {
				return instance_exists(_entry.inst)
			})
			rotate_towards_next_target()
		}
	}
}
