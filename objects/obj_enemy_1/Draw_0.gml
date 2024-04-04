draw_self();
draw_set_valign(fa_middle);
draw_set_colour(c_white);
var _offset_y = sprite_height / 2 + string_height(equation)
var _y = y > room_height / 2 ? y - _offset_y : y + _offset_y
draw_text_transformed(x - sprite_width / 2, _y, equation, 1.5, 1.5, 0);
