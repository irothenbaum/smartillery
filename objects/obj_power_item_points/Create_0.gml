/// @description Points power item
// A cluster of score orbs (see obj_power_item_orb_cluster)
event_inherited()

orb_type = ORB_TYPE_SCORE
orb_layer = LAYER_FG_EFFECTS

function get_orb_amount() {
	return 10 * get_current_wave_number()
}

sync_cluster()
