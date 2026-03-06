/// @description Insert description here
draw_set_composite_color(new CompositeColor(global.bg_color, 1))
var _bounds = new Bounds(global.room_width * 0.25, 0, global.room_width * 0.75, global.room_height)
draw_rectangle(_bounds.x0,_bounds.y0, _bounds.x1, _bounds.y1, false)

draw_set_composite_color(new CompositeColor(c_white, 1))
draw_line_width(_bounds.x0,_bounds.y0, _bounds.x0, _bounds.y1, 3)
draw_line_width(_bounds.x1,_bounds.y0, _bounds.x1, _bounds.y1, 3)

draw_set_composite_color(new CompositeColor(c_white, 0.15))
draw_line_width(_bounds.x0,_bounds.height * 0.25, _bounds.x1, _bounds.height * 0.25, 2)
draw_line_width(_bounds.x0,_bounds.height * 0.75, _bounds.x1, _bounds.height * 0.75, 2)
draw_line_width(_bounds.x0,_bounds.height * 0.375, _bounds.x1, _bounds.height * 0.375, 1)
draw_line_width(_bounds.x0,_bounds.height * 0.5, _bounds.x1, _bounds.height * 0.5, 1)
draw_line_width(_bounds.x0,_bounds.height * 0.575, _bounds.x1, _bounds.height * 0.575, 1)
reset_composite_color();