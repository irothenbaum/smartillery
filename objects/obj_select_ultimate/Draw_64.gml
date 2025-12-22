/// @description Draw selection interface
draw_overlay()

draw_set_color(c_white)
draw_set_font(fnt_title)
draw_text_with_alignment(x, y - icon_space, "Select your Ultimate", ALIGN_CENTER)

// global.selected_ultimate is keyed by user_id, _selected_ultimates_lookup is keyed by ultimate name
var _selected_ultimates_lookup = {}
var _selected_users = variable_struct_get_names(global.selected_ultimate);
for (var _i = 0;_i < array_length(_selected_users); _i++) {
    _selected_ultimates_lookup[$ global.selected_ultimate[$ _selected_users[_i]]] = _selected_users[_i]
}
var _ultimate_names = variable_struct_get_names(global.ultimate_icons)
var _is_hovering = false

for (var _i = 0; _i < array_length(_ultimate_names); _i++) {
    var _this_ultimate = _ultimate_names[_i];
	var _is_selected_by_other_player = _selected_ultimates_lookup[$ _this_ultimate] && _selected_ultimates_lookup[$ _this_ultimate] != get_my_steam_id_safe()
	var _spr = global.ultimate_icons[$ _this_ultimate];
	var _new_scale = _this_ultimate == staged_selection ? hovered_scale : default_scale
	var _draw_scale = lerp(drawn_icon_scales[$ _this_ultimate], _new_scale, global.fade_speed)
	var _ult_color = global.ultimate_colors[$ _this_ultimate]
	
	drawn_icon_scales[$ _this_ultimate] = _draw_scale
	
	var _overlay_color_opacity = (_this_ultimate == staged_selection || _this_ultimate == hovered_selection) ? 1 : 0
	
	if (_is_selected_by_other_player) {
		_ult_color = c_grey;
		_overlay_color_opacity = 1;
	}
	
	var _draw_opacity = lerp(drawn_icon_opacity[$ _this_ultimate], _overlay_color_opacity, global.fade_speed)
	drawn_icon_opacity[$ _this_ultimate] = _draw_opacity
	
	var _b = {
		x0: x + ((_i - 1) * icon_space) - square_size / 2,
		y0: y - square_size,
	}
	
	if (_i >= 3) {
		_b.x0 -= icon_space * 3
		_b.y0 += square_size + global.margin_lg
	}
	
	_b.x1 = _b.x0 + square_size
	_b.y1 = _b.y0 + square_size
	var _bounds = new Bounds(_b.x0,_b.y0, _b.x1, _b.y1)
	
		
	draw_sprite_ext(_spr, 0, _bounds.xcenter, _bounds.ycenter, _draw_scale, _draw_scale, 0 , c_white, 1)
	// draw_rounded_rectangle(_bounds, 10, 5)
	
	if (_draw_opacity > 0) {
		draw_set_color(global.ultimate_colors[$ _this_ultimate])
		draw_sprite_ext(_spr, 0, _bounds.xcenter, _bounds.ycenter, _draw_scale, _draw_scale, 0 , _ult_color, _draw_opacity)
		draw_set_alpha(_draw_opacity)
		if (_this_ultimate == staged_selection || _this_ultimate == hovered_selection) {
			draw_set_alpha(min(_draw_opacity, 1 -  0.8 * (_draw_scale - default_scale) / (hovered_scale - default_scale)))
		}
		draw_rounded_rectangle(_bounds, 10, 5)
		
		reset_composite_color()
	}

	if (is_spot_in_bounds(mouse_x, mouse_y, _bounds) && !_is_selected_by_other_player) {
		_is_hovering = true
		hovered_selection = _this_ultimate
		if (mouse_check_button_pressed(mb_left)) {
			handle_select(_this_ultimate)
		}
	}
}

if (!_is_hovering) {
	hovered_selection = undefined
}

var _focued_ult = is_undefined(hovered_selection) ? staged_selection : hovered_selection
if (!is_undefined(_focued_ult)) {
	draw_set_color(global.ultimate_colors[$ _focued_ult])
	draw_set_font(fnt_title)
	var _title_bounds = draw_text_with_alignment(x, y + icon_space + global.margin_lg, global.ultimate_descriptions[$ _focued_ult].title, ALIGN_CENTER)
		
	draw_set_color(c_white)
	draw_set_font(fnt_large)
	draw_text_with_alignment(x, _title_bounds.y1 + global.margin_md, global.ultimate_descriptions[$ _focued_ult].description, ALIGN_CENTER)
}

reset_composite_color()
draw_set_font(fnt_base)