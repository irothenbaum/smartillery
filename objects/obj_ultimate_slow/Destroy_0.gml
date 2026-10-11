/// @description Revert slow multiplier
with (obj_enemy_parent) {
	enemy_remove_slow(id)
}

if (!is_extra) {
	get_game_controller().mark_ultimate_used(owner_player_id)
}