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
	draw_set_font(fnt_large)
	draw_text_with_alignment(_bounds.x0, y -210, "unit: ", ALIGN_LEFT) 
	draw_text_with_alignment(_bounds.x1, y -210, string(_gc.unit_score), ALIGN_RIGHT) 
	draw_set_color(global.power_color)
	draw_text_with_alignment(_bounds.x0, y -180, "streak bonus: ", ALIGN_LEFT)
	draw_text_with_alignment(_bounds.x1, y -180, string(_gc.streak_score), ALIGN_RIGHT)
	draw_set_color(global.combo_color)
	draw_text_with_alignment(_bounds.x0, y -150, "combo bonus: ", ALIGN_LEFT)
	draw_text_with_alignment(_bounds.x1, y -150, string(_gc.combo_score), ALIGN_RIGHT)
}