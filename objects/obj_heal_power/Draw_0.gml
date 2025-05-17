var _stroke_width = 4;
draw_set_color(heal_color)
for (var _i = 0; _i < _stroke_width; _i++) {
	draw_circle(x, y, heal_radius + _i, true)
}

