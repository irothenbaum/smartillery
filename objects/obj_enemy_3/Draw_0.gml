if (!is_undefined(shift_position)) {
	x = (x + shift_position.x) / 2
	y = (y + shift_position.y) / 2
}

// at top speed we fade to the attack color (the Step snaps speed to exactly the max once it gets there)
var _color = enemy_get_attack_color(self, speed > 0 && speed >= max_speed * slow_multiplier)
var _draw_color = _color.color
var _draw_color_arr = _color.color_arr
var _shadows_to_draw = floor(speed)
if (!is_paused && speed == 0 && floor(get_play_time() % 400) < 200) {
	_draw_color = stunned_color
	_draw_color_arr = stunned_color_arr
}

shader_set(sh_hue_shift);
shader_set_uniform_f_array(_u_color, _draw_color_arr);
for (var _i = _shadows_to_draw; _i > 0; _i--) {
	var _distance = 8 * (_i - _shadows_to_draw)
	// we do - instead of + because we want it behind us
	var _this_x = x + lengthdir_x(_distance, direction)
	var _this_y = y + lengthdir_y(_distance, direction)
	var _alpha = _i / (_shadows_to_draw + 1)
	draw_sprite_ext(spr_enemy3_ghost, 0, _this_x, _this_y, image_scale, image_scale , direction, _draw_color, _alpha)
}

draw_sprite_ext(spr_enemy3_body, 0, x, y, image_scale, image_scale, direction, _draw_color, 1)
shader_reset();