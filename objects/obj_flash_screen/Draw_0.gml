/// @description draw_flash
draw_set_composite_color(composite_color(c_white, 0.5 * alarm[0] / duration))
draw_rectangle(0, 0, global.room_width, global.room_height, false)
reset_composite_color()