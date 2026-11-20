// once the waypoints run out we're on our final approach, so fade to the attack color
var _color = enemy_get_attack_color(self, array_length(waypoints) == 0)

shader_set(sh_hue_shift);
shader_set_uniform_f_array(_u_color, _color.color_arr);
draw_sprite_ext(spr_enemy1_body, 0, x, y, image_scale, image_scale, image_angle, _color.color, 1)
shader_reset();
