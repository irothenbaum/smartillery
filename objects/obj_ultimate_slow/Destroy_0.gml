/// @description Revert slow multiplier
for_each_enemy(function(_enemy) {
	enemy_remove_slow(_enemy)
})

if (!is_extra) {
	get_game_controller().mark_ultimate_used(owner_player_id)
}