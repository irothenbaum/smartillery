if (is_undefined(overlay_amount)) {
	return
}
draw_overlay(overlay_amount * 0.666)

if (showing_results) {
	var _gc = get_game_controller()
	draw_set_color(c_white)
	draw_set_font(fnt_title)
	draw_text_with_alignment(x, y, string(_gc.game_score), ALIGN_CENTER)
	draw_set_font(fnt_large)
	draw_text_with_alignment(x, y -150, "unit: " + string(_gc.unit_score), ALIGN_CENTER) 
	draw_set_color(c_orange)
	draw_text_with_alignment(x, y -200, "streak bonus: " + string(_gc.streak_score) ,ALIGN_CENTER)
}