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
	with (obj_enemy_parent) {
		if (object_index != obj_training_target && point_distance(x, y, other.x, other.y) <= _radius) {
			enemy_destroy_without_reward(id)
		}
	}
}
