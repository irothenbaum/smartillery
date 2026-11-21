/// @description Draw placeholder perk
draw_set_color(color)
draw_circle(x, y, radius, false)

draw_set_font(fnt_small)
draw_set_color(get_contrast_color(color))
draw_text_with_alignment(x, y, label, ALIGN_CENTER)

reset_composite_color()
