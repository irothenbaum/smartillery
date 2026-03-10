/// @description Draw perk

// Update pulse animation
if (pulse_scale >= 1.1) {
	// Rapidly shrink back to 1x
	pulse_scale = 1
	// Draw shockwave at position
	draw_particle_shockwave(x, y, 0.6, pt_shape_circle, global.ultimate_colors[$ type])
} else {
	// Slowly grow
	pulse_scale += pulse_grow_speed
}

var _scaled_radius = radius * pulse_scale
var _ult_color = global.ultimate_color_tints[$ type]

// Draw filled circle with ultimate color
draw_set_color(_ult_color)
draw_circle(x, y, _scaled_radius, false)

// Draw 3 pixel thick white outline
draw_set_color(c_white)
for (var _i = 0; _i < 3; _i++) {
	draw_circle(x, y, _scaled_radius - _i, true)
}

// Draw ultimate icon in center
var _ult_sprite = global.ultimate_icons[$ type]
draw_sprite_ext(_ult_sprite, 0, x, y, icon_scale * pulse_scale, icon_scale * pulse_scale, 0, c_white, 1)