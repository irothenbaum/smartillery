/// @description Draw expanding ring
var _progress = elapsed / duration

var _current_radius = lerp(start_radius, end_radius, _progress)
var _current_stroke = lerp(initial_stroke, 1, _progress)
var _alpha = fade ? (1 - _progress) : 1

draw_set_color(color)
draw_set_alpha(_alpha)
draw_arc(x, y, _current_radius, 360, 0, _current_stroke)
draw_set_alpha(1)
