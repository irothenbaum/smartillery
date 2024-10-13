draw_set_colour(c_white);
draw_set_font(fnt_title)
draw_set_alpha(image_alpha)
var _message = string_length(label) > 0 ? label : " "
var _bounds = draw_text_with_alignment(x, y, _message, ALIGN_CENTER)

if (_bounds.width < min_box_width) {
	_bounds.x0 = _bounds.xcenter - min_box_width /2
	_bounds.x1 = _bounds.xcenter + min_box_width /2
}
var _border_bounds = _final_format({
	x0: _bounds.x0 - 12,
	y0: _bounds.y0 - 8,
	x1: _bounds.x1 + 12,
	y1: _bounds.y1 + 6 
})
draw_roundrect_ext(_border_bounds.x0, _border_bounds.y0, _border_bounds.x1, _border_bounds.y1, _border_bounds.height / 2, _border_bounds.height / 2, true)

bounds = _border_bounds
draw_set_alpha(1)