/// @description Turret power item
// Drawn as the stationary turret's body (no barrel). When hit, the turret spawns right where the item is and takes
// over in place -- its barrel extends out of the body, then its range grows in
event_inherited()

label = "T"
label_color = c_white

_u_color = shader_get_uniform(sh_hue_shift, "u_vColor")
color_arr = color_to_array(c_white)

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("TURRET ITEM HIT by", last_hit_by_player_id)
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_stationary_turret, {owner_player_id: last_hit_by_player_id})
	fade_out_label()
	instance_destroy()
}
