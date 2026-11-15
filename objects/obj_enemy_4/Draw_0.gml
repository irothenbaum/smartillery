shader_set(sh_hue_shift);
// the shader's color uniform keeps whatever the last drawer set (e.g. the player's streak color), so always set ours
shader_set_uniform_f_array(_u_color, color_to_array(c_white));
draw_sprite_ext(spr_enemy4_body, 0, x, y, image_scale, image_scale, direction, c_white, 1)
shader_reset();