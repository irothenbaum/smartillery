/// @description Draw perk

// draw the background color
var _color = c_white
var _label = ""
switch (type) {
	case BONUS_ITEM_HEALTH:
		_color = c_lime
		_label = "+"
		break
	case BONUS_ITEM_POINTS:
		_color = c_yellow
		_label = "$"
		break
	case BONUS_ITEM_LEVEL_UP:
		_color = c_purple
		_label = "LV"
		break
	case BONUS_ITEM_SHIELD:
		_color = c_aqua
		_label = "SH"
		break
	case BONUS_ITEM_TURRET:
		_color = global.ultimate_colors[$ ULTIMATE_TURRET]
		break
}

draw_set_color(_color)
draw_circle(x, y, radius, false)

if (type == BONUS_ITEM_TURRET) {
	draw_sprite_ext(spr_ult_turret, 0, x, y, icon_scale, icon_scale, 0, c_white, 1)
} else {
	draw_set_font(fnt_small)
	draw_set_color(c_white)
	draw_text_with_alignment(x, y, _label, ALIGN_CENTER)
}

reset_composite_color()