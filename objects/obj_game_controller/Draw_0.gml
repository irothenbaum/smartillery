if (global.paused && !is_ulting() && !is_selecting_ult) {
	draw_overlay()
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	draw_text_with_alignment(global.xcenter, global.ycenter, "PAUSED", ALIGN_CENTER)
}

if (ult_overlay > 0) {
	draw_rectangle_clipped(0, 0, global.room_height, global.room_height, global.ultimate_colors[$ global.selected_ultimate], global.ultimate_icons[$ global.selected_ultimate], 1 + 1 - (_ult_overlay / 1))
}