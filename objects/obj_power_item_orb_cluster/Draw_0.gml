/// @description Draw the orb cluster
// drawn the same way as obj_orb_score_increase's orbs
draw_set_composite_color(new CompositeColor(get_orb_color(orb_type), 1))
for (var _i = 0; _i < array_length(cluster); _i++) {
	var _orb = cluster[_i]
	draw_circle(x + _orb.x_diff, y + _orb.y_diff, get_orb_draw_radius(_orb.value), false)
}
reset_composite_color()
