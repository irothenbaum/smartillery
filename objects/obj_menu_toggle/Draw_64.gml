draw_set_color(c_white);
draw_set_font(fnt_title)
draw_set_alpha(image_alpha)
var _message = label + ": " + get_value()
bounds = draw_menu_box(x, y, _message, align, min_box_width, is_selected())
draw_set_alpha(1)
