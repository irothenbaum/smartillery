
for (var _i = 0; _i < array_length(orbs); _i++) {
	var _orb = orbs[_i]
	var _radius = 3 + _orb.value
	
	draw_set_composite_color(new CompositeColor(color, 1))
	draw_circle(x + _orb.x_diff, y + _orb.y_diff, _radius, false)
}

reset_composite_color()