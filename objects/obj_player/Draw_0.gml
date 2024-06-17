shader_set(sh_hue_shift);

if (get_game_controller().is_scene_transitioning) { 
	// TODO: Draw exhaust
}

// draw the body
var _body_x = x + lengthdir_x(-recoil_amount / 3, image_angle)
var _body_y = y + lengthdir_y(-recoil_amount / 3, image_angle)
shader_set_uniform_f_array(_u_color, global.body_color);
draw_sprite_ext(spr_player_body, 0, _body_x, _body_y, image_scale, image_scale, direction, c_white, 1)

// draw the turret
var _turret_x = x + lengthdir_x(-recoil_amount, image_angle)
var _turret_y = y + lengthdir_y(-recoil_amount, image_angle)
var _turret_scale = 1 - (recoil_amount / (max_recoil_amount * 2))
shader_set_uniform_f_array(_u_color, global.turret_color);
draw_sprite_ext(spr_player_turret, 0, _turret_x, _turret_y, _turret_scale * image_scale, image_scale, image_angle, c_white, 1)

shader_reset();

