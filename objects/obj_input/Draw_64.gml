// change the text & box color if we're shaking, otherwise default is white
if (!is_undefined(shake_start)) {
	draw_set_color(c_red)
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

my_bounds = new Bounds(
	_bounds.x0 - 12,
	_bounds.y0 - 6,
	_bounds.x1 + 12,
	_bounds.y1
)

// we change the box color if we're on streak
if (get_game_controller().has_point_streak(owner_player_id) && is_undefined(shake_start)) {
	draw_set_color(my_color);
}
draw_input_box_with_progress(my_bounds, draw_streak_ratio)

// draw our fire on the GUI layer
if (!is_undefined(streak_fire)) {
	part_system_drawit(streak_fire.system);
}