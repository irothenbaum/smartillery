/// @description Radial dim behind the menu buttons
// Draw GUI Begin, so it's always under the buttons (which draw in Draw GUI) and unaffected by the zoomed camera
var _gui_w = display_get_gui_width()
var _gui_h = display_get_gui_height()
var _cx = _gui_w * dim_center_x_ratio
var _cy = _gui_h * dim_center_y_ratio
var _radius = _gui_w * dim_radius_ratio

draw_primitive_begin(pr_trianglefan)
draw_vertex_colour(_cx, _cy, c_black, dim_max_alpha)
for (var _i = 0; _i <= dim_segments; _i++) {
	var _angle = _i * 360 / dim_segments
	draw_vertex_colour(_cx + lengthdir_x(_radius, _angle), _cy + lengthdir_y(_radius, _angle), c_black, 0)
}
draw_primitive_end()
