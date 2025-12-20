/// @description Draw perk
switch (type) {
	case BONUS_TYPE_ITEM:
		draw_item_perk()
		break;
		
	case BONUS_TYPE_ULT:
		draw_ult_perk()
}

// now we draw the time remaining
draw_set_composite_color(new CompositeColor(c_white, 1))
var _ratio_remaining = alarm[0] / duration
draw_arc(x, y, radius + time_bar_thickness / 2, 360 * _ratio_remaining, 0, time_bar_thickness)

reset_composite_color()