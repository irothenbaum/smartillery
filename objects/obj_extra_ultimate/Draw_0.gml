/// @description Draw perk

// Draw filled circle with ultimate color
draw_set_color(global.ultimate_colors[$ type])
draw_circle(x, y, radius * pulse_scale, false)

// Draw ultimate icon in center
draw_sprite_ext(global.ultimate_icons[$ type], 0, x, y, icon_scale * pulse_scale, icon_scale * pulse_scale, 0, c_white, 1)

