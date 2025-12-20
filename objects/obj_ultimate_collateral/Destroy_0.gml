/// @description Mark used
get_game_controller().mark_ultimate_used(owner_player_id)

// we also want to remove any lingering proximity indicators
var _e_beams = get_array_of_instances(obj_electric_beam)
var _proximity_markers = array_foreach(_e_beams, function(_beam) {
	if (_beam.width == proximity_beam_width) {
		instance_destroy(_beam)
	}
})
