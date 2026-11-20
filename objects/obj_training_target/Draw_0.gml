var _radius = get_current_radius()
lerp_radius = lerp(lerp_radius, _radius, global.fade_speed)
var _alpha = is_exploded ? 1 : (1 - (get_health_percent() * 0.8))
lerp_alpha = lerp(lerp_alpha, _alpha, global.fade_speed)
var _target_color = get_target_color()
lerp_target_color = lerp_color(lerp_target_color, _target_color, global.fade_speed)

draw_set_composite_color(new CompositeColor(lerp_target_color, lerp_alpha))

// Draw filled circle then draw slightly smaller circle in background color to create outline effect
draw_circle(x, y, lerp_radius, false)
draw_set_alpha(1)
draw_arc(x, y, lerp_radius, 360, 0, outline_thickness)

// this target's own difficulty, above it (the equation draws below, since targets sit in the top half)
draw_set_font(fnt_base)
draw_set_color(c_white)
draw_set_alpha(is_exploded ? 0.5 : 1)
draw_text_with_alignment(x, y - max_radius - global.margin_md, "Difficulty " + string(difficulty_level), ALIGN_CENTER)
draw_set_alpha(1)

// Only draw equation if not exploded
if (!is_exploded) {
	instance_draw_equation(self)
}

reset_composite_color();