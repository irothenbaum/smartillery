// once target_location is set (Alarm 0) we're homing in on the player -- our final approach -- so fade to the attack color
var _color = enemy_get_attack_color(self, !is_undefined(target_location))

shader_set(sh_hue_shift);
// always set the uniform: it otherwise keeps whatever the last drawer set (e.g. the player's streak color)
shader_set_uniform_f_array(_u_color, _color.color_arr);
draw_sprite_ext(spr_enemy4_fragment, 0, x, y, image_scale, image_scale, direction, _color.color, 1)
shader_reset();
