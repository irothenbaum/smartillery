draw_set_font(fnt_title)
var _y = y - string_height(message) / 2
var _x = x
if (align == ALIGN_CENTER) {
	_x = x - string_width(message) / 2	
}
draw_set_colour(c_white);
draw_text(_x , _y, message);