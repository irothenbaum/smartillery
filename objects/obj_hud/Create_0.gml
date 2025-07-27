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

for_each_player(function(_player_id) {
	instance_create_layer(x, y, LAYER_HUD, obj_hud_ultimate_icon, {owner_player_id: _player_id})
})

function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	_obj.bounds = draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
}
