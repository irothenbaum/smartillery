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
	// always fully recharge. If their ultimate is running, the charge waits: it can't be launched until the current
	// one ends (has_ultimate checks is_ulting), and it doesn't extend the current one's duration
	_game_controller.ultimate_charge[$ last_hit_by_player_id] = global.ultimate_requirement
	instance_destroy()
}
