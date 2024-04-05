margin = 20

pos_score = {
	x: room_width - margin,
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


function draw_text_with_alignment(_obj, _text) {
	var _y = _obj.y
	var _x = _obj.x
	
	switch (_obj.align) {
		case ALIGN_CENTER:
			_x -= string_width(_text) / 2 
			break
			
		case ALIGN_RIGHT:
			_x -= string_width(_text)
			break
			
		case ALIGN_LEFT:
		default: 
			// do nothing
			break
	}
	
	draw_set_font(fnt_large)
	draw_text(_x, _y, _text);
}