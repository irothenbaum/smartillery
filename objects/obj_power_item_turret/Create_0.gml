/// @description Turret power item
event_inherited()

color = c_white // placeholder until proper sprite assets are made
label = "T"

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("TURRET ITEM HIT by", last_hit_by_player_id)
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_stationary_turret, {owner_player_id: last_hit_by_player_id})
	instance_destroy()
}
