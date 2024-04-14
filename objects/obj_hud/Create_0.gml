draw_health = 0
draw_ultimate = 0
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
	x: room_width / 2,
	y: margin,
	align: ALIGN_RIGHT,
	height: 18,
	width: 200,
}

pos_ultimate = {
	x: room_width / 2,
	y: pos_health.y + pos_health.height + margin / 2,
	align: ALIGN_LEFT,
	height: 8,
	width: pos_health.width,
}


function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
}