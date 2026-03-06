var _text_opacity = min(image_alpha, 0.9)

// first draw the text
var _current_wave = get_current_wave_number()
draw_set_composite_color(new CompositeColor(c_black, _text_opacity))
draw_set_font(fnt_wave_text)
var _bounds = draw_text_with_alignment(x, y, "WAVE " + string(_current_wave), ALIGN_CENTER)

// next draw the black borders
var _top_border_height = image_alpha * (_bounds.y0 - global.margin_lg)
var _bottom_border_default_y0 = (_bounds.y1 + global.margin_lg)
var _bottom_border_y0 = _bottom_border_default_y0 + ((1 - image_alpha) * _bottom_border_default_y0)

draw_rectangle(0, 0, global.room_width, _top_border_height, false)
draw_rectangle(0, _bottom_border_y0, global.room_width, global.room_height, false)
reset_composite_color()

if (global.paused) {
	return
}

if (fade_out) {
	image_alpha = lerp(image_alpha, 0, global.fade_speed)
	if (image_alpha == 0) {
		instance_destroy()
	}
} else if (image_alpha < 1) {
	image_alpha = lerp(image_alpha, 1, global.fade_speed)
}