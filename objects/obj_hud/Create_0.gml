margin = 20
drawn_score = 0

pos_score = {
	x: room_width - 2 * margin,
	y: margin,
	align: ALIGN_RIGHT
}

pos_wave = {
	x: margin,
	y: margin,
	align: ALIGN_LEFT
}

game_controller = get_game_controller()

instance_create_layer(x, y, LAYER_HUD, obj_hud_ultimate_icon, {owner_player_id: get_my_steam_id_safe()})

if (global.is_coop) {
	instance_create_layer(x, y, LAYER_HUD, obj_hud_ultimate_icon, {owner_player_id: get_partner_steam_id_safe()})
}

function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	_obj.bounds = draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
}
