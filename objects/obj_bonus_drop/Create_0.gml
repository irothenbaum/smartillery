/// @description Initialize settings

duration = 30 * game_get_speed(gamespeed_fps)
alarm[0] = duration
radius = global.player_body_radius
time_bar_thickness = 4
icon_scale = 0.02 // this is a magic number, a property of the ultimate sprite sizes and the radius

function draw_ult_perk() {
	var _ult_type = sub_type
	
	// draw the background color
	draw_set_composite_color(new CompositeColor(global.ultimate_colors[$ _ult_type], 0.6))
	draw_circle(x, y, radius, false)
	
	var _ult_sprite = global.ultimate_icons[$ _ult_type]
	draw_sprite_ext(_ult_sprite, 0, x, y, icon_scale, icon_scale, 0, c_white, 1)
}

function draw_score_perk() {
	debug("draw_score_perk NOT IMPLEMENTED")
}

