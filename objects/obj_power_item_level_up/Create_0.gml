/// @description Level up power item
event_inherited()

color = c_purple
label = "LU"

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("LEVEL UP ITEM HIT by", last_hit_by_player_id)
	// only the player who hit the item levels up
	var _game_controller = get_game_controller()
	_game_controller.increate_ult_level(last_hit_by_player_id)
	// an active ultimate drives its own charge meter (counting down), so only fill it when not ulting
	if (!_game_controller.is_ulting(last_hit_by_player_id)) {
		_game_controller.ultimate_charge[$ last_hit_by_player_id] = global.ultimate_requirement
	}
	instance_destroy()
}
