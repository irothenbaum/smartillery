/// @description Draw the turret's body
// tinted white the same way obj_stationary_turret draws it, so the handoff is seamless
var _scale = global.stationary_turret_body_scale
shader_set(sh_hue_shift)
shader_set_uniform_f_array(_u_color, color_arr)
draw_sprite_ext(spr_player_body, 0, x, y, _scale, _scale, 0, c_white, 1)
shader_reset()
draw_label()
