// Calculate how close we are to firing (0 = just reset, 1 = about to fire)
// alarm[0] returns -1 when not running, so treat that as 0 progress
var _alarm_remaining = max(0, alarm[0])
var _actual_delay = missile_delay * slow_multiplier
var _fire_progress = 1 - (_alarm_remaining / _actual_delay)
_fire_progress = clamp(_fire_progress, 0, 1)

// Calculate how many octagon sections to fill (0-8)
var _sections_filled = floor(_fire_progress * 8)

if (_sections_filled > 0) {
	// Get sprite UV bounds on texture page
	var _uvs = sprite_get_uvs(sprite_index, image_index)

	// Draw sprite with octagon sections filled purple
	shader_set(sh_octagon_fill)
	shader_set_uniform_f_array(_u_color, attack_color_arr)
	shader_set_uniform_f(_u_sections, _sections_filled)
	// Convert image_angle to radians and offset by half a section so first section is centered on facing direction
	shader_set_uniform_f(_u_rotation, degtorad(image_angle) + (pi / 16))
	// Pass UV bounds: left, top, right, bottom
	shader_set_uniform_f(_u_uvs, _uvs[0], _uvs[1], _uvs[2], _uvs[3])
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha)
	shader_reset()
} else {
	draw_self()
}
