/// @description Draw perk

// draw the background color
var _color = c_white
switch (type) {
	case BONUS_ITEM_HEALTH:
		_color = c_lime
		break
	case BONUS_ITEM_POINTS:
		_color = c_yellow
		break
	case BONUS_ITEM_LEVEL_UP:
		_color = c_purple
		break
	case BONUS_ITEM_SHIELD:
		_color = c_aqua
		break
	case BONUS_ITEM_TURRET:
		// placeholder until proper sprite assets are made
		_color = c_white
		break
}

draw_set_color(_color)
draw_circle(x, y, radius, false)

draw_set_font(fnt_small)
draw_set_color(_color == c_white ? c_black : c_white)
draw_text_with_alignment(x, y, label, ALIGN_CENTER)

reset_composite_color()