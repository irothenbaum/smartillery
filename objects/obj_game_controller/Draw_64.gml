if (global.paused && !is_ulting() && !is_selecting_ult) {
	draw_overlay()
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	draw_text_with_alignment(global.xcenter, global.ycenter, "PAUSED", ALIGN_CENTER)
}