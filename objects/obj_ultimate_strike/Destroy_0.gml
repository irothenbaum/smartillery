/// @description Un pause and mark used
toggle_pause(false)
if (!is_extra) {
	get_game_controller().mark_ultimate_used(owner_player_id)
}
