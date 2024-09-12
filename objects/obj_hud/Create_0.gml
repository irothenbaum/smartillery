draw_ultimate = 0
margin = 20

min_box_width = 100

ultimate_icons = {
	ULTIMATE_HEAL: spr_icon_ult_heal_small,
	ULTIMATE_STRIKE: spr_icon_ult_strike_small,
	ULTIMATE_SLOW: spr_icon_ult_slow_small,
}
sprite_size = 40
half_sprite_size = 20

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

pos_ultimate = {
	xcenter: global.xcenter,
	ycenter: 0 + margin + half_sprite_size
}

function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
}