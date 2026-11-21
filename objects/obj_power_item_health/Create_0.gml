/// @description Health power item
event_inherited()

color = c_lime
label = "H"

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("HEALTH ITEM HIT by", last_hit_by_player_id)
	// fly a health orb to the player, same as the leech ultimate
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_orb_score_increase, {
		amount: global.health_item_amount,
		type: ORB_TYPE_HEALTH,
		owner_player_id: last_hit_by_player_id,
	})
	instance_destroy()
}
