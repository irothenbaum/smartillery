/// @description Draw shield ring
draw_set_color(color)
draw_arc(x, y, radius, 360, 0, thickness)

// health is shown as (health - 1) thin white lines spaced evenly across the ring's thickness
draw_set_color(c_white)
for (var _i = 1; _i < shield_health; _i++) {
	draw_arc(x, y, inner_radius + thickness * _i / shield_health, 360, 0, 2)
}
