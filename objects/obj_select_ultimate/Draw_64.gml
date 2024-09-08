/// @description Draw selection interface
draw_overlay()

var _keys = variable_struct_get_names(icons)
var _is_hovering = false
for (var _i = 0; _i < array_length(_keys); _i++) {
    var _k = _keys[_i];
	var _spr = icons[$ _k];
	var _scale = _k == staged_selection ? 1 : 0.8
	var _sprite_width = sprite_get_width(_spr) * _scale
	var _sprite_height = sprite_get_height(_spr) * _scale
	var _bounds = {
		x0: x + ((_i - 1) * icon_space) - _sprite_width / 2,
		y0: y - sprite_height / 2,
	}
	
	_bounds.x1 = _bounds.x0 + _sprite_width
	_bounds.y1 = _bounds.y0 + _sprite_height
	_bounds = _final_format(_bounds)
	
	draw_sprite_ext(_spr, 0, _bounds.xcenter, _bounds.ycenter, _scale, _scale, 0 , c_white, 1)
	
	if (is_spot_in_bounds(mouse_x, mouse_y, _bounds)) {
		_is_hovering = true
		staged_selection = _k
		
		if (mouse_check_button_pressed(mb_left)) {
			handle_select(_k)
		}
	}
}

if (!_is_hovering) {
	staged_selection = undefined
}

