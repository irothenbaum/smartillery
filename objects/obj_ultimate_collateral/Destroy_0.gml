/// @description Mark used
if (!is_extra) {
	get_game_controller().mark_ultimate_used(owner_player_id)
}

// we also want to remove any lingering proximity indicators
with(obj_electric_beam) {
	if (owner_instance == other.id) {
		instance_destroy()
	}
}
