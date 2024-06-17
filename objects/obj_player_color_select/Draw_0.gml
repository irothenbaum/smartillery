shader_set(sh_hue_shift);

shader_set_uniform_f_array(_u_color, global.body_color);
draw_sprite_ext(spr_player_body, 0, x, y, image_scale, image_scale, 90, c_white, 1)

shader_set_uniform_f_array(_u_color, global.turret_color);
draw_sprite_ext(spr_player_turret, 0, x, y, image_scale, image_scale, 90, c_white, 1)

shader_reset();

draw_set_font(fnt_base)
draw_text_with_alignment(turret_picker.x - 20, turret_picker.bounds.ycenter, "TURRET:", ALIGN_RIGHT)
draw_text_with_alignment(body_picker.x - 20, body_picker.bounds.ycenter, "BODY:", ALIGN_RIGHT)