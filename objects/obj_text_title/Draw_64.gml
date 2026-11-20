draw_set_font(fnt_title)
draw_set_color(c_white)
draw_set_alpha(is_undefined(fade_elapsed) ? 1 : clamp(1 - (fade_elapsed / fade_duration), 0, 1))
var _bounds = draw_text_with_alignment(x, y, message, align)
draw_set_alpha(1)

if (variable_instance_exists(self, "on_render") && !is_undefined(self.on_render)) {
	script_execute(self.on_render, _bounds)
}

