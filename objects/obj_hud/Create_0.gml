draw_ultimate = 0
draw_ultimate_experience = 0
margin = 20
drawn_score = 0

min_box_width = 100

ultimate_icons = {
	ULTIMATE_HEAL: spr_icon_ult_heal_small,
	ULTIMATE_STRIKE: spr_icon_ult_strike_small,
	ULTIMATE_SLOW: spr_icon_ult_slow_small,
}
sprite_size = 40
half_sprite_size = 20

pos_score = {
	x: room_width - 2 * margin,
	y: margin,
	align: ALIGN_RIGHT
}

pos_wave = {
	x: margin,
	y: margin,
	align: ALIGN_LEFT
}

input = instance_find(obj_input, 0)
game_controller = get_game_controller()

function draw_text_obj(_obj, _text) {
	draw_set_font(fnt_large)
	draw_text_with_alignment(_obj.x, _obj.y, _text, _obj.align)
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