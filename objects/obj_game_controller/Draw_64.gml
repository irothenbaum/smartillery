if (global.paused && !is_ulting()) {
	draw_set_alpha(0.8)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	draw_text_with_alignment(room_width / 2, room_height / 2, "PAUSED", ALIGN_CENTER)
}