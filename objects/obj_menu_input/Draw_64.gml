draw_set_valign(fa_top);
draw_set_font(fnt_title)

var _is_shaking = !is_undefined(shake_elapsed)
var _x = x + get_shake_offset()
// red while shaking (showing the rejected entry), otherwise what's typed, or the placeholder when empty
var _color = _is_shaking ? c_red : c_white
var _show_placeholder = !_is_shaking && string_length(message) == 0
var _message = _is_shaking ? last_guess : (_show_placeholder ? string_copy(placeholder, 1, placeholder_chars) : message)
if (string_length(_message) == 0) {
	_message = " "
}

draw_set_color(_color)
draw_set_alpha(_show_placeholder ? placeholder_alpha : 1)
var _bounds = draw_text_with_alignment(_x, y, _message, ALIGN_CENTER)
draw_set_alpha(1)

if (_bounds.width < min_box_width) {
	_bounds.x0 = _bounds.xcenter - min_box_width /2
	_bounds.x1 = _bounds.xcenter + min_box_width /2
}
draw_roundrect(_bounds.x0 - 20, _bounds.y0 - 12, _bounds.x1 + 20, _bounds.y1 + 12 , true)
draw_set_color(c_white)
