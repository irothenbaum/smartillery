/// @description Destroy turrets
if (!is_extra) {
	get_game_controller().mark_ultimate_used(owner_player_id)
}

// only destroy the turrets this ultimate spawned, not other players' active turrets
for (var _i = 0; _i < array_length(my_turrets); _i++) {
	if (instance_exists(my_turrets[_i])) {
		instance_destroy(my_turrets[_i])
	}
}