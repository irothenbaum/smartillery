/// @description Draw selection interface
draw_overlay()

draw_set_color(c_white)
draw_set_font(fnt_title)
draw_text_with_alignment(x, y - icon_space, "Select your Ultimate", ALIGN_CENTER)

var _keys = variable_struct_get_names(global.ultimate_icons)
var _is_hovering = false
for (var _i = 0; _i < array_length(_keys); _i++) {
    var _k = _keys[_i];
	var _spr = global.ultimate_icons[$ _k];
	var _new_scale = _k == staged_selection ? hovered_scale : default_scale
	var _draw_scale = lerp(drawn_icon_scales[$ _k], _new_scale, global.fade_speed)
	drawn_icon_scales[$ _k] = _draw_scale
	
	var _overlay_color_opacity = _k == staged_selection ? 1 : 0
	var _draw_opacity = lerp(drawn_icon_opacity[$ _k], _overlay_color_opacity, global.fade_speed)
	drawn_icon_opacity[$ _k] = _draw_opacity
	
	var _bounds = {
		x0: x + ((_i - 1) * icon_space) - square_size / 2,
		y0: y - square_size / 2,
	}
	
	_bounds.x1 = _bounds.x0 + square_size
	_bounds.y1 = _bounds.y0 + square_size
	_bounds = _final_format(_bounds)
		
	draw_sprite_ext(_spr, 0, _bounds.xcenter, _bounds.ycenter, _draw_scale, _draw_scale, 0 , c_white, 1)
	
	if (_draw_opacity > 0) {
		draw_set_color(global.ultimate_colors[$ _k])
		draw_sprite_ext(_spr, 0, _bounds.xcenter, _bounds.ycenter, _draw_scale, _draw_scale, 0 , global.ultimate_colors[$ _k], _draw_opacity)
		draw_set_alpha(_draw_opacity)
		if (_k == staged_selection) {
			draw_set_alpha(min(_draw_opacity, 1 -  0.8 * (_draw_scale - default_scale) / (hovered_scale - default_scale)))
		}
		draw_rounded_rectangle(_bounds.x0, _bounds.y0, _bounds.x1, _bounds.y1, 10, 5)
		
		reset_composite_color()
	}
	
	if (is_spot_in_bounds(mouse_x, mouse_y, _bounds)) {
		_is_hovering = true
		staged_selection = _k
		
		if (mouse_check_button_pressed(mb_left)) {
			handle_select(_k)
		}
		
		draw_set_color(global.ultimate_colors[$ _k])
		draw_set_font(fnt_title)
		var _title_bounds = draw_text_with_alignment(x, y + icon_space, global.ultimate_descriptions[$ _k].title, ALIGN_CENTER)
		
		draw_set_color(c_white)
		draw_set_font(fnt_large)
		draw_text_with_alignment(x, _title_bounds.y1 + 20, global.ultimate_descriptions[$ _k].description, ALIGN_CENTER)
	}
}

if (!_is_hovering) {
	staged_selection = undefined
}

draw_set_color(c_white)
draw_set_font(fnt_base)