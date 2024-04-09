margin = 20

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

pos_health = {
	x: room_width / 2 - margin,
	y: margin,
	align: ALIGN_RIGHT
}

pos_ultimate = {
	x: room_width / 2 + margin,
	y: margin,
	align: ALIGN_LEFT
}


function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
}