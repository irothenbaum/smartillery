/// @description Draw perk
	
// draw the background color
draw_set_composite_color(new CompositeColor(global.ultimate_colors[$ type], 0.6))
draw_circle(x, y, radius, false)
	
var _ult_sprite = global.ultimate_icons[$ type]
draw_sprite_ext(_ult_sprite, 0, x, y, icon_scale, icon_scale, 0, c_white, 1)

reset_composite_color()