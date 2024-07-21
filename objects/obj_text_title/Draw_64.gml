draw_set_font(fnt_title)
draw_set_colour(c_white)
var _bounds = draw_text_with_alignment(x, y, message, align)

if (variable_instance_exists(self, "on_render") && !is_undefined(self.on_render)) {
	script_execute(self.on_render, _bounds)
}

