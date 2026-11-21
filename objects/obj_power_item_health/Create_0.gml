/// @description Health power item
// A cluster of healing orbs (see obj_power_item_orb_cluster) -- the same orbs the leech ultimate sends to the player
event_inherited()

orb_type = ORB_TYPE_HEALTH
orb_layer = LAYER_BG_EFFECTS

function get_orb_amount() {
	return global.health_item_amount
}

sync_cluster()
