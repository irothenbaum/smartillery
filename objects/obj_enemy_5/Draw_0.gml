// Calculate how close we are to firing (0 = just reset, 1 = about to fire)
var _fire_progress = 1 - (alarm[0] / missile_delay)
_fire_progress = clamp(_fire_progress, 0, 1)

if (_fire_progress > 0) {
	// Blend towards purple as we approach firing
	var _blend_color = merge_color(c_white, attack_color, _fire_progress)
	var _blend_color_arr = color_to_array(_blend_color)

	shader_set(sh_hue_shift)
	shader_set_uniform_f_array(_u_color, _blend_color_arr)
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, _blend_color, image_alpha)
	shader_reset()
} else {
	draw_self()
}
