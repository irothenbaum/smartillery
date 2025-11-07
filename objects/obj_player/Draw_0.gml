if (hide_self) {
	return
}

var _body_x = x + lengthdir_x(-recoil_amount / 3, image_angle)
var _body_y = y + lengthdir_y(-recoil_amount / 3, image_angle)

// Draw flashes first
var _flash_count = array_length(hull_flashes)
if (_flash_count > 0) {
	for(var _i = 0; _i < _flash_count; _i++) {
		var _this_flash = hull_flashes[_i]
		var _step_scale = body_diameter / 2 + (20 * _this_flash.step)
		
		draw_set_composite_color(new CompositeColor(_this_flash.color, 1 - _this_flash.step))
		draw_circle(_body_x, _body_y, _step_scale, false)
			
		_this_flash.step = lerp(_this_flash.step, 1, global.fade_speed)
	}
	
	hull_flashes = array_filter(hull_flashes, function(_s) {
		return _s.step < 0.98
	})
}

// then draw the body and turret
shader_set(sh_hue_shift);

var _game_controller = get_game_controller()

// draw the body
shader_set_uniform_f_array(_u_color, body_color_arr);
draw_sprite_ext(spr_player_body, 0, _body_x, _body_y, image_scale, image_scale, direction, c_white, 1)

if (!_game_controller.is_game_over) {
	// draw the turret
	var _turret_x = x + lengthdir_x(-recoil_amount, image_angle)
	var _turret_y = y + lengthdir_y(-recoil_amount, image_angle)
	var _turret_scale = 1 - (recoil_amount / (max_recoil_amount * 2))
	shader_set_uniform_f_array(_u_color, _game_controller.has_point_streak() ? my_color_arr : turret_color_arr);
	draw_sprite_ext(spr_player_turret, 0, _turret_x, _turret_y, _turret_scale * image_scale, image_scale, image_angle, c_white, 1)
}

shader_reset();