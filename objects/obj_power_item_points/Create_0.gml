/// @description Points power item
event_inherited()

color = c_yellow
label = "P"

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("POINTS ITEM HIT by", last_hit_by_player_id)
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_orb_score_increase, {
		amount: 10 * get_current_wave_number(),
		type: ORB_TYPE_SCORE,
		owner_player_id: last_hit_by_player_id,
	})
	instance_destroy()
}
