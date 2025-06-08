if (global.paused && !is_ulting() && !is_selecting_ult && is_undefined(ultimate_level_up_controller)) {
	draw_overlay()
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	draw_text_with_alignment(global.xcenter, global.ycenter, "PAUSED", ALIGN_CENTER)
}

// This isn't working and I'm not sure why...
// draw_rectangle_clipped(new Bounds(0, 0, global.room_width, global.room_height), c_red, spr_test, 1)

// this draws the ult icon flash over the screen when the player launches their ultimate
if (ult_overlay > 0) {
	var _scale = 0.3 + (1 - ult_overlay ) / 2.5
	draw_sprite_ext(global.ultimate_icons[$ global.selected_ultimate], 0, global.xcenter, global.ycenter, _scale, _scale, 0, global.ultimate_colors[$ global.selected_ultimate], ult_overlay)
	// draw_rectangle_clipped(new Bounds(0, 0, global.room_width, global.room_height), global.ultimate_colors[$ global.selected_ultimate], global.ultimate_icons[$ global.selected_ultimate], _scale)
}