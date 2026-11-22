draw_set_color(c_white);
draw_set_font(fnt_title)
draw_set_alpha(image_alpha)
var _message = string_length(label) > 0 ? label : " "
bounds = draw_menu_box(x, y, _message, align, min_box_width, false, strobing && strobe_inverted)
draw_set_alpha(1)
