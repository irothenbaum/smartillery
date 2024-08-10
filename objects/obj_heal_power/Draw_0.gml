var _stroke_width = 4;
draw_set_color(global.heal_color)
for (var _i = 0; _i < _stroke_width; _i++) {
	draw_circle(x, y, global.heal_radius + _i, true)
}

