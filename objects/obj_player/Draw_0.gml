shader_set(sh_hue_shift);

if (get_game_controller().is_scene_transitioning) { 
	// TODO: Draw exhaust
}

var _turret_x = x + lengthdir_x(-recoil_amount, image_angle)
var _turret_y = y + lengthdir_y(-recoil_amount, image_angle)
shader_set_uniform_f_array(_u_color, turret_color);
draw_sprite_ext(spr_player_turret, 0, _turret_x, _turret_y, 1, 1, image_angle, c_white, 1)

shader_set_uniform_f_array(_u_color, body_color);
draw_sprite_ext(spr_player_body, 0, x, y, 1, 1, direction, c_white, 1)

shader_reset();
