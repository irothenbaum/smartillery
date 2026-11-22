/// @description Draw shield ring
// shiny: the shine band lights up the ring (and its band lines) as it sweeps past
shader_set_shine(x, y, outer_radius * 2)
draw_set_color(color)
draw_arc(x, y, radius, 360, 0, drawn_thickness)

// health is shown as one band per health point across the ring's thickness, separated by thin white lines.
// New bands grow in at the outer edge and lost ones shrink out, so the lines slide to their new spacing
var _band_keys = []
for (var _i = 0; _i < shield_health; _i++) {
	array_push(_band_keys, _i)
}
health_bands.update(_band_keys)

var _bands = health_bands.get_layout()
draw_set_color(c_white)
for (var _i = 1; _i < array_length(_bands); _i++) {
	draw_arc(x, y, inner_radius + thickness * _bands[_i].start, 360, 0, 2)
}
shader_reset()
