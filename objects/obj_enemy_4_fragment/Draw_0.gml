shader_set(sh_hue_shift);
draw_sprite_ext(spr_enemy4_fragment, 0, x, y, image_scale, image_scale, direction, c_white, 1)
shader_reset();
enemy_draw_equation(self)