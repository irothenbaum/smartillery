// score orbs are shiny (health / ult / combo orbs aren't)
var _shiny = type == ORB_TYPE_SCORE
if (_shiny) {
	// scaled to the whole cloud (the orbs spread up to cloud_radius from x/y)
	shader_set_shine(x, y, 2 * (cloud_radius + get_orb_draw_radius(ORB_MAX_VALUE)))
}
draw_set_composite_color(new CompositeColor(color, 1))
for (var _i = 0; _i < array_length(orbs); _i++) {
	var _orb = orbs[_i]
	var _radius = get_orb_draw_radius(_orb.value)
	
	draw_circle_filled(x + _orb.x_diff, y + _orb.y_diff, _radius)
}

reset_composite_color()
if (_shiny) {
	shader_reset()
}