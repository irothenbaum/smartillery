if (global.paused && !is_ulting() && !is_selecting_ult && is_undefined(ultimate_level_up_controller)) {
	draw_overlay()
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	draw_text_with_alignment(global.xcenter, global.ycenter, "PAUSED", ALIGN_CENTER)
}

// This isn't working and I'm not sure why...
// draw_rectangle_clipped(new Bounds(0, 0, global.room_width, global.room_height), c_red, spr_test, 1)