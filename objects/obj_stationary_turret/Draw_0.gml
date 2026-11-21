/// @description Draw range, body, and turret
// range indicator: the fill is a pie that sweeps down to 0 as the turret's lifetime runs out
if (display_range > 0) {
	// once despawning, the lifetime alarm has finished, so the fill is already gone
	var _remaining = is_despawning ? 0 : get_alarm_remaining_ratio(self, lifetime_frames, lifetime_full_buffer)
	var _fill_degrees = 360 * _remaining

	draw_set_color(c_white)
	draw_set_alpha(0.12)
	draw_pie(x, y, display_range, _fill_degrees, lifetime_start_angle)
	draw_set_alpha(1)

	// the head: where the fill meets the empty part. Hidden while the fill is still full
	if (_remaining > 0 && _remaining < 1) {
		var _head_angle = lifetime_start_angle + _fill_degrees
		draw_line_width(x, y, x + lengthdir_x(display_range, _head_angle), y + lengthdir_y(display_range, _head_angle), lifetime_head_width)
	}

	draw_set_circle_precision(get_circle_precision_from_radius_and_degrees(display_range, 360))
	draw_circle(x, y, display_range, true)
}

// feet, drawn under the body so they poke out from beneath its border. Each is spr_pixel stretched into a bar
// running radially from just inside the border to its tip. They're drawn as a sprite (not draw_line_width) so they
// rasterize the same way as the body sprite -- primitives land a pixel or so off from sprites, which made the feet
// look off-center. spr_pixel's origin is its middle-left, so the bar starts at the inner point, centered on the
// radial line. Everything scales with sprite_scale so they shrink on despawn
var _feet_scale = sprite_scale
var _foot_inner = (body_radius - foot_inset) * _feet_scale
var _foot_outer = (body_radius + lerp(foot_min_length, foot_length, feet_extend)) * _feet_scale
var _foot_xscale = (_foot_outer - _foot_inner) / sprite_get_width(spr_pixel)
var _foot_yscale = foot_width * _feet_scale / sprite_get_height(spr_pixel)
for (var _i = 0; _i < 4; _i++) {
	var _angle = feet_angle + _i * 90
	draw_sprite_ext(spr_pixel, 0, x + lengthdir_x(_foot_inner, _angle), y + lengthdir_y(_foot_inner, _angle), _foot_xscale, _foot_yscale, _angle, c_white, 1)
}

// body + turret, tinted white the same way the player is
shader_set(sh_hue_shift)
shader_set_uniform_f_array(_u_color, color_arr)
var _body_scale = body_scale * sprite_scale
var _turret_scale = turret_scale * sprite_scale
draw_sprite_ext(spr_player_body, 0, x, y, _body_scale, _body_scale, 0, c_white, 1)

var _turret_x = x + lengthdir_x(-recoil_amount, image_angle)
var _turret_y = y + lengthdir_y(-recoil_amount, image_angle)
// the barrel's origin is at its back end, so scaling only its length makes it extend out of the body
draw_sprite_ext(spr_enemy2_turret, 0, _turret_x, _turret_y, _turret_scale * barrel_extend, _turret_scale, image_angle, c_white, 1)
shader_reset()
