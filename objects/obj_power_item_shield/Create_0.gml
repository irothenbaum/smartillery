/// @description Shield power item
// Drawn as a miniature of the shield itself. When hit it hands off to obj_shield_pickup, which flies that miniature
// to the player and grows it into the real shield
event_inherited()

// the miniature's outer edge sits on the item's radius
icon_scale = radius / get_shield_geometry().outer_radius

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("SHIELD ITEM HIT by", last_hit_by_player_id)
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_shield_pickup, {start_scale: icon_scale})
	instance_destroy()
}
