

for (var _i = 0; _i < array_length(orbs); _i++) {
	var _orb = orbs[_i]
	var _radius = 2 + _orb.value
	
	draw_set_composite_color(composite_color(color, 0.4))
	draw_circle(x + _orb.x_diff, y + _orb.y_diff, _radius, false)
	draw_set_composite_color(composite_color(color, 1))
	draw_circle(x + _orb.x_diff, y + _orb.y_diff, _radius, true)

}

reset_composite_color()