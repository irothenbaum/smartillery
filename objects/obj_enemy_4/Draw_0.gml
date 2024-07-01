if (!is_undefined(shift_position)) {
	x = (x + shift_position.x) / 2
	y = (y + shift_position.y) / 2
}

var _draw_color = c_white
if (speed == 0) {
	// TODO: spinning stars or whatever, this is stunned
	_draw_color = c_red
}

shader_set(sh_hue_shift);
draw_sprite_ext(spr_enemy3_body, 0, x, y, image_scale, image_scale, direction, _draw_color, 1)
shader_reset();

enemy_draw_equation(self)