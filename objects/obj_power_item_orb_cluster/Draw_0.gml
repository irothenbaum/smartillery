/// @description Draw the orb cluster
// drawn the same way as obj_orb_score_increase's orbs
// orb items (points and health) are shiny
// scaled to the whole cluster (the orbs hover up to hover_radius from x/y)
shader_set_shine(x, y, 2 * (hover_radius + get_orb_draw_radius(ORB_MAX_VALUE)))
draw_set_composite_color(new CompositeColor(get_orb_color(orb_type), 1))
for (var _i = 0; _i < array_length(cluster); _i++) {
	var _orb = cluster[_i]
	draw_circle_filled(x + _orb.x_diff, y + _orb.y_diff, get_orb_draw_radius(_orb.value))
}
reset_composite_color()
shader_reset()
