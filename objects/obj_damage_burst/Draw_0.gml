/// @description Draw expanding burst
var _alpha = elapsed <= expand_duration ? 1 : 1 - ((elapsed - expand_duration) / fade_duration)
_alpha = clamp(_alpha, 0, 1)

draw_set_color(color)

// faint fill to show the cleared area
draw_set_alpha(_alpha * 0.15)
draw_circle(x, y, current_radius, false)

// leading edge of the wave
draw_set_alpha(_alpha)
draw_arc(x, y, current_radius, 360, 0, stroke * (0.5 + 0.5 * _alpha))
draw_set_alpha(1)
