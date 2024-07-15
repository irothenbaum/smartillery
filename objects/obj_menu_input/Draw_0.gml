draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_font(fnt_title)
var _message = string_length(message) > 0 ? message : " "
var _bounds = draw_text_with_alignment(x, y, _message, ALIGN_CENTER)

if (_bounds.width < min_box_width) {
	_bounds.x0 = _bounds.xcenter - min_box_width /2
	_bounds.x1 = _bounds.xcenter + min_box_width /2
}
draw_roundrect(_bounds.x0 - 20, _bounds.y0 - 12, _bounds.x1 + 20, _bounds.y1 + 12 , true)

