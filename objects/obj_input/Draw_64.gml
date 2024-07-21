var _game_cotroller = get_game_controller()

if (_game_cotroller.has_point_streak()) {
	draw_set_colour(c_orange);
} else {
	draw_set_colour(c_white)
}


draw_set_valign(fa_top);
draw_set_font(fnt_title)
var _message = string_length(message) > 0 ? message : " "
var _bounds = draw_text_with_alignment(x, y, _message, ALIGN_CENTER)

if (_bounds.width < min_box_width) {
	_bounds.x0 = _bounds.xcenter - min_box_width / 2
	_bounds.x1 = _bounds.xcenter + min_box_width / 2
}

var _rectangle_bounds = _final_format({
	x0: _bounds.x0 - 12,
	y0: _bounds.y0 - 6,
	x1: _bounds.x1 + 12,
	y1: _bounds.y1
})

draw_roundrect(
	_rectangle_bounds.x0, 
	_rectangle_bounds.y0, 
	_rectangle_bounds.x1, 
	_rectangle_bounds.y1, 
	true
)


draw_set_alpha(0.15)
draw_roundrect(
	_rectangle_bounds.x0, 
	_rectangle_bounds.y0, 
	_rectangle_bounds.x0 + _rectangle_bounds.width * streak_ratio,
	_rectangle_bounds.y1, 
	false
)

draw_set_alpha(1)
draw_set_color(c_white)