if (is_undefined(overlay_amount)) {
	return
}
draw_overlay(overlay_amount * 0.666)

if (showing_results) {
	var _gc = get_game_controller()
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	
	var _bounds = {
		x0: x - 200,
		x1: x + 200
	}
	
	draw_line(_bounds.x0, y - 125, _bounds.x1, y - 125)
	draw_text_with_alignment(_bounds.x1, y - 100, string(_gc.game_score), ALIGN_RIGHT)
}