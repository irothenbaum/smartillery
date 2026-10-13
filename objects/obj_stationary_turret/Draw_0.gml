/// @description Draw range, body, and turret
// range indicator
draw_set_circle_precision(get_circle_precision_from_radius_and_degrees(range, 360))
draw_set_color(c_white)
draw_set_alpha(0.3)
draw_circle(x, y, range, false)
draw_set_alpha(1)
draw_circle(x, y, range, true)

// body + turret, tinted white the same way the player is
shader_set(sh_hue_shift)
shader_set_uniform_f_array(_u_color, color_arr)
draw_sprite_ext(spr_player_body, 0, x, y, body_scale, body_scale, 0, c_white, 1)

var _turret_x = x + lengthdir_x(-recoil_amount, image_angle)
var _turret_y = y + lengthdir_y(-recoil_amount, image_angle)
draw_sprite_ext(spr_enemy2_turret, 0, _turret_x, _turret_y, turret_scale, turret_scale, image_angle, c_white, 1)
shader_reset()
