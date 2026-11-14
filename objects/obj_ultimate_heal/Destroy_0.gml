debug("[LEECH] heal ult destroyed:", id, "is_extra:", is_extra)
if (!is_extra) {
	get_game_controller().mark_ultimate_used(owner_player_id)
}