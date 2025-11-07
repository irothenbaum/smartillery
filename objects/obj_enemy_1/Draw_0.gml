if (array_length(waypoints) > 0) {
	draw_self();
} else {
	shader_set(sh_hue_shift);
	shader_set_uniform_f_array(_u_color, attack_color_arr);
	draw_sprite_ext(spr_enemy1_body, 0, x, y, image_scale, image_scale, image_angle, attack_color, 1)
	shader_reset();
}
enemy_draw_equation(self)