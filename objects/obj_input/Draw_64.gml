var _game_controller = get_game_controller()

if (!is_undefined(shake_start)) {
	draw_set_color(c_red)
} else if (_game_controller.has_point_streak()) {
	draw_set_color(streak_color);
} else {
	draw_set_color(c_white)
}


draw_set_valign(fa_top);
draw_set_font(fnt_title)
var _message = string_length(message) > 0 ? message : (!is_undefined(shake_start) ? last_guess : " ")
var _bounds = draw_text_with_alignment(render_x, y, _message, ALIGN_CENTER)

if (_bounds.width < min_box_width) {
	_bounds.x0 = _bounds.xcenter - min_box_width / 2
	_bounds.x1 = _bounds.xcenter + min_box_width / 2
}

draw_streak_ratio = lerp(draw_streak_ratio, streak_ratio, global.fade_speed)

my_bounds = new FormattedBounds({
	x0: _bounds.x0 - 12,
	y0: _bounds.y0 - 6,
	x1: _bounds.x1 + 12,
	y1: _bounds.y1
})

draw_input_box_with_progress(my_bounds, draw_streak_ratio)
