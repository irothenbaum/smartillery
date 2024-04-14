draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_font(fnt_large)
debug(x, y)
var _string_width = string_width(message) / 2
var _string_height = string_height(message) / 2
var _bounds = draw_text_with_alignment(x, y + sprite_height / 2, message, ALIGN_CENTER)
draw_rectangle(x - _string_width, y - _string_height, x + _string_width, y + _string_height * 2, true)
