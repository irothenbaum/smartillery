margin = 20
drawn_ultimate = 0
drawn_ultimate_experience = 0
sprite_size = 40
half_sprite_size = 20
input = instance_find(obj_input, 0)
game_controller = get_game_controller()
color_shadow = composite_color(c_black, 0.4)
color_shadow_dark = composite_color(c_black, 0.8)

ultimate_icons = {
	ULTIMATE_HEAL: spr_icon_ult_heal_small,
	ULTIMATE_STRIKE: spr_icon_ult_strike_small,
	ULTIMATE_SLOW: spr_icon_ult_slow_small,
}

subscribe(EVENT_UTLTIMATE_LEVEL_UP, method({
	input: input, 
	margin: margin, 
	half_sprite_size: half_sprite_size
}, function() {
	var _xcenter = input.my_bounds.x1 + margin * 2 + half_sprite_size
	var _ycenter = input.my_bounds.ycenter
	draw_particle_shockwave(_xcenter, _ycenter, 0.5)
}))