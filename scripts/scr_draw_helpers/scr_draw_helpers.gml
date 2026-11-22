/**
 * @param {Real} _color
 * @param {Real} _opacity
 */
function CompositeColor(_color, _opacity) constructor {
	c = get_color_from_composite(_color)
	o = _opacity
}

/**
 * @param {Struct.CompositeColor|Real|Constant.Color} _color1
 * @param {Struct.CompositeColor|Real|Constant.Color} _color2
 * @param {Real} _proportion -- [0,1] where 0 = full _color1, 1 = full _color2
 * @returns {Struct.CompositeColor}
 */
function blend_composite_colors(_color1, _color2, _proportion = 0.5) {
	var _c1 = get_color_from_composite(_color1)
	var _c2 = get_color_from_composite(_color2)

	var _o1 = is_struct(_color1) ? _color1.o : 1
	var _o2 = is_struct(_color2) ? _color2.o : 1
/*
	// Deconstruct colors into HSV components
	var _h1 = color_get_hue(_c1)
	var _s1 = color_get_saturation(_c1)
	var _v1 = color_get_value(_c1)

	var _h2 = color_get_hue(_c2)
	var _s2 = color_get_saturation(_c2)
	var _v2 = color_get_value(_c2)

	// Blend each component separately
	var _blended_h = lerp(_h1, _h2, _proportion)
	var _blended_s = lerp(_s1, _s2, _proportion)
	var _blended_v = lerp(_v1, _v2, _proportion)

	// Reconstruct the color from HSV
	var _blended_color = make_color_hsv(_blended_h, _blended_s, _blended_v)
*/
	var _blended_color = merge_color(_c1, _c2, _proportion)
	var _blended_opacity = lerp(_o1, _o2, _proportion)

	return new CompositeColor(_blended_color, _blended_opacity)
}

/**
 * There's some kind of rounding issue with blending similar colors where lerping between 
 * c1 and c2 with a proportion like 0.2 ends up always returning c1. So this function uses
 * additional logic to try and step it close to c2 and eventually returns c2 directly
 * @param {Struct.CompositeColor|Real|Constant.Color} _color1
 * @param {Struct.CompositeColor|Real|Constant.Color} _color2
 * @param {Real} _proportion -- [0,1] where 0 = full _color1, 1 = full _color2
 * @returns {Struct.CompositeColor}
 */
function lerp_color(_color1, _color2, _proportion) {
	var _c1 = get_color_from_composite(_color1)
	var _c2 = get_color_from_composite(_color2)
	
	if (_c1 == _c2) {
		return get_composite_from_color(_color1)
	}
	
	if (_proportion == 0) {
		return get_composite_from_color(_color1)
	} else if (_proportion == 1) {
		return get_composite_from_color(_color2)
	}
	
	var _result = blend_composite_colors(_color1, _color2, _proportion)
	
	var _result_is_1 = _result.c == _c1
	var _result_is_2 = _result.c == _c2

	if (_result_is_1) {
		if (_proportion < 0.5) {
			return lerp_color(_color1, _color2, 0.7)
		} else {
			return get_composite_from_color(_color2)
		}
	}
	
	return _result
}

/**
 * @param {Struct.CompositeColor|Real|Constant.Color} _color
 * @returns {Real|Constant.Color}
 */
function get_color_from_composite(_color) {
	return is_struct(_color) ? _color.c : _color
}

/**
 * @param {Struct.CompositeColor|Real|Constant.Color} _color
 * @returns {Struct.CompositeColor}
 */
function get_composite_from_color(_color) {
	return is_struct(_color) ? _color : new CompositeColor(_color, 1)
}

/**
 * Returns black or white, whichever is more readable on top of the given background color
 * @param {Struct.CompositeColor|Real|Constant.Color} _background_color
 * @returns {Constant.Color}
 */
function get_contrast_color(_background_color) {
	var _c = get_color_from_composite(_background_color)
	// perceived brightness (ITU-R BT.601 luma), normalized to [0,1]
	var _luminance = (0.299 * color_get_red(_c) + 0.587 * color_get_green(_c) + 0.114 * color_get_blue(_c)) / 255
	return _luminance > 0.5 ? c_black : c_white
}

/**
 * Splits a span (e.g. a ring's sweep, or a ring's thickness) into keyed sections and animates each section's
 * share as sections are added (grow in from 0) or removed (shrink out to 0), instead of snapping to the new layout.
 * Call update() once per frame with the keys that should exist now, then read get_layout().
 * @param {Real} _speed -- lerp amount per frame
 */
function AnimatedSections(_speed = 0.15) constructor {
	speed = _speed
	// {key, weight, target, data} in display order. weight animates toward target (1 = present, 0 = removed)
	entries = []

	/**
	 * @param {Array} _keys -- the sections that should exist now, in display order
	 * @param {Array} _data -- (optional) one payload per key. It's kept on the entry, so a removed section can still be drawn while it shrinks out
	 */
	static update = function(_keys, _data = undefined) {
		for (var _i = 0; _i < array_length(entries); _i++) {
			entries[_i].target = 0
		}

		// new keys are inserted right after the previous key's entry, so they grow in at the right spot
		var _insert_at = 0
		for (var _k = 0; _k < array_length(_keys); _k++) {
			var _index = find_entry_index(_keys[_k])
			if (_index < 0) {
				_index = _insert_at
				array_insert(entries, _index, {key: _keys[_k], weight: 0, target: 1, data: undefined})
			}
			var _entry = entries[_index]
			_entry.target = 1
			if (!is_undefined(_data)) {
				_entry.data = _data[_k]
			}
			_insert_at = _index + 1
		}

		for (var _i = array_length(entries) - 1; _i >= 0; _i--) {
			var _entry = entries[_i]
			_entry.weight = lerp(_entry.weight, _entry.target, speed)
			if (abs(_entry.weight - _entry.target) < 0.001) {
				_entry.weight = _entry.target
			}
			if (_entry.target == 0 && _entry.weight == 0) {
				array_delete(entries, _i, 1)
			}
		}
	}

	/**
	 * @param {Any} _key
	 * @returns {Real} -1 if not found
	 */
	static find_entry_index = function(_key) {
		for (var _i = 0; _i < array_length(entries); _i++) {
			if (entries[_i].key == _key) {
				return _i
			}
		}
		return -1
	}

	/**
	 * Sum of all section weights -- roughly how many sections are showing. 1 or more means the span is fully used
	 * @returns {Real}
	 */
	static get_total_weight = function() {
		var _total = 0
		for (var _i = 0; _i < array_length(entries); _i++) {
			_total += entries[_i].weight
		}
		return _total
	}

	/**
	 * start and size are fractions [0,1] of the span. While the total weight is under 1 (the first section growing in,
	 * or the last one shrinking out) the sections don't fill the whole span
	 * @returns {Array<Struct>} {key, data, start, size}
	 */
	static get_layout = function() {
		var _scale = 1 / max(1, get_total_weight())
		var _layout = []
		var _start = 0
		for (var _i = 0; _i < array_length(entries); _i++) {
			var _size = entries[_i].weight * _scale
			array_push(_layout, {key: entries[_i].key, data: entries[_i].data, start: _start, size: _size})
			_start += _size
		}
		return _layout
	}
}

/**
 * @param {Real} _x
 * @param {Real} _y
 * @param {Real} _x1
 * @param {Real} _y1
 * @param {Real} _progress -- [0,1]
 * @param {Struct.CompositeColor} _color
 * @param {Struct.CompositeColor} _background_color
 * @param {Bool} _vertical
 * @returns {Struct.Bounds}
 */
function draw_progress_bar(_x, _y, _x1, _y1, _progress, _color, _background_color, _vertical = false) {
	draw_set_composite_color(_background_color)
	draw_rectangle(_x, _y, _x1, _y1, false)
	draw_set_composite_color(_color)

	if (_vertical) {
		var _y_diff = _y1 - _y
		draw_rectangle(_x, _y1 - (min(max(0, _progress), 1) * _y_diff), _x1, _y1, false)
	} else {
		var _x_diff = _x1 - _x
		draw_rectangle(_x, _y, _x + (min(max(0, _progress), 1) * _x_diff), _y1, false)
	}

	reset_composite_color()

	return new Bounds(_x, _y, _x1, _y1)
}

/**
 * @param {Struct.Bounds} _bounds
 * @param {Real} _step
 */
function draw_info_modal(_bounds, _step) {
	_step = min(1, max(0, _step))
	var _with_padding = apply_padding_to_bounds(_bounds, global.margin_md, global.margin_md)
	
	if (_step < 1) {
		_with_padding = new Bounds(
			lerp(_bounds.xcenter, _with_padding.x0, min(1, _step * 2)),
			lerp(_bounds.ycenter, _with_padding.y0, max(0, _step * 2 - 1)),
			lerp(_bounds.xcenter, _with_padding.x1, min(1, _step * 2)),
			lerp(_bounds.ycenter, _with_padding.y1, max(0, _step * 2 - 1))
		)
	}
	
	draw_set_composite_color(new CompositeColor(c_white, 1))
	draw_rectangle(_with_padding.x0, _with_padding.y0, _with_padding.x1, _with_padding.y1, true)
	draw_set_composite_color(new CompositeColor(c_black, 0.3))
	draw_rectangle(_with_padding.x0, _with_padding.y0, _with_padding.x1, _with_padding.y1, false)
	reset_composite_color()
}

/**
 * @param {Struct.Bounds} _bounds
 * @param {Real} _width
 * @param {Real} _height
 * @returns {Struct.Bounds}
 */
function center_bounds_in_frame(_bounds, _width = 0, _height = 0) {
	if (_width == 0) {
		_width = global.room_width
	}
	if (_height == 0) {
		_height = global.room_height
	}
	
	var _center = {
		x: round(_width / 2),
		y: round(_height / 2)
	}
	
	var _new_bounds = {
		x0: _center.x - round(_bounds.width / 2),
		y1: _center.y - round(_bounds.height / 2)
	}
	
	_new_bounds.x1 = _new_bounds.x0 + _bounds.width
	_new_bounds.y1 = _new_bounds.y0 + _bounds.height
	
	return new Bounds(_new_bounds.x0, _new_bounds.y0, _new_bounds.x1, _new_bounds.y1)
}

/**
 * @param {Real} _x
 * @param {Real} _y
 * @param {String} _text
 * @param {String} _align
 * @param {Real} _line_height
 * @returns {Struct.Bounds}
 */

/**
 * Inserts line breaks into _text so that, drawn with the currently set font, no line
 * exceeds _max_width. Existing "\n" breaks in the source text are preserved.
 * @param {String} _text
 * @param {Real} _max_width
 * @returns {String}
 */
function word_wrap(_text, _max_width) {
	var _paragraphs = string_split(_text, "\n")
	var _wrapped = ""

	for (var _p = 0; _p < array_length(_paragraphs); _p++) {
		var _words = string_split(_paragraphs[_p], " ")
		var _current_line = ""

		for (var _i = 0; _i < array_length(_words); _i++) {
			var _word = _words[_i]
			var _candidate = (_current_line == "") ? _word : string_concat(_current_line, " ", _word)
			if (string_width(_candidate) > _max_width && _current_line != "") {
				_wrapped = (_wrapped == "") ? _current_line : string_concat(_wrapped, "\n", _current_line)
				_current_line = _word
			} else {
				_current_line = _candidate
			}
		}

		_wrapped = (_wrapped == "") ? _current_line : string_concat(_wrapped, "\n", _current_line)
	}

	return _wrapped
}

function draw_text_with_alignment(_x, _y, _text, _align = ALIGN_LEFT, _line_height = 1.1, _trail_run = false) {
	var _lines = string_split(_text, "\n")
	var _final_bounds = {
		x0: _x,
		y0: _y,
		x1: _x,
		y1: _y
	}
		
	var _total_lines = array_length(_lines)
	for (var _i = 0; _i < _total_lines; _i++) {
		var _line_text = _lines[_i]
		var _line_bounds = {
			x0: _x,
			y0: _y,
			x1: _x,
			y1: _y
		}
		
		var _str_width = string_width(_line_text)
		var _str_height = string_height(_line_text)
		
		// we always draw the text center aligned vertically
		_line_bounds.y0 = _y - (_str_height / 2)
			
		switch (_align) {
			case ALIGN_CENTER:
				_line_bounds.x0 = _x - _str_width / 2 
				break
			
			case ALIGN_RIGHT:
				_line_bounds.x0 = _x - _str_width
				break
			
			case ALIGN_LEFT:
			default: 
				// do nothing
				break
		}
	
		// snap to whole pixels: centering (and callers' own math) often lands on .5, and with pixel interpolation off
		// each glyph then rounds to a pixel on its own -- some up, some down -- so the text looks jagged
		_line_bounds.x0 = round(_line_bounds.x0)
		_line_bounds.y0 = round(_line_bounds.y0)

		_line_bounds.x1 = _line_bounds.x0 + _str_width
		_line_bounds.y1 = _line_bounds.y0 + _str_height
	
		if (!_trail_run) {
			draw_text(_line_bounds.x0, _line_bounds.y0, _line_text);
		}
		_y += _str_height * _line_height
		
		_final_bounds.x0 = min(_final_bounds.x0, _line_bounds.x0)
		_final_bounds.x1 = max(_final_bounds.x1, _line_bounds.x1)
		_final_bounds.y0 = min(_final_bounds.y0, _line_bounds.y0)
		_final_bounds.y1 = max(_final_bounds.y1, _line_bounds.y1)
	}
	
	return new Bounds(_final_bounds.x0, _final_bounds.y0, _final_bounds.x1, _final_bounds.y1)
}

/**
 * @param {Real} _alpha
 */
function draw_overlay(_alpha  = 0.5) {
	// TODO Might want to use draw_clear_alpha() here but it's not working. I must be doing something wrong
	draw_set_alpha(_alpha)
	draw_set_color(c_black)
	draw_rectangle(0, 0, global.room_width, global.room_height, false)
	reset_composite_color()
}

/**
 * @param {Struct.Bounds} _bounds
 * @param {Real} _radius
 * @param {Real} _thickness
 * @returns {Struct.Bounds}
 */
function draw_rounded_rectangle(_bounds, _radius, _thickness = 1) {
	var _content_area = new Bounds(
		_bounds.x0 + _radius,
		_bounds.y0 + _radius,
		_bounds.x1 - _radius,
		_bounds.y1 - _radius
	)

	draw_line_width(_content_area.x0, _bounds.y0, _content_area.x1, _bounds.y0, _thickness)
	if (_radius > 0) {
		draw_arc(_content_area.x1, _content_area.y0, _radius, 90, 0, _thickness)
	}
	draw_line_width(_bounds.x1, _content_area.y0, _bounds.x1, _content_area.y1, _thickness)
	if (_radius > 0) {
		draw_arc(_content_area.x1, _content_area.y1, _radius, 90, 270, _thickness)
	}
	draw_line_width(_content_area.x0, _bounds.y1, _content_area.x1, _bounds.y1, _thickness)
	if (_radius > 0) {
		draw_arc(_content_area.x0, _content_area.y1, _radius, 90, 180, _thickness)
	}
	draw_line_width(_bounds.x0, _content_area.y0,_bounds.x0, _content_area.y1, _thickness)
	if (_radius > 0) {
		draw_arc(_content_area.x0, _content_area.y0, _radius, 90, 90, _thickness)
	}
	
	return new Bounds(_bounds.x0, _bounds.y0, _bounds.x1, _bounds.y1)
}


/*
 * @param {Real} _x
 * @param {Real} _y
 * @param {Real} _radius
 * @param {Real} _degrees
 * @param {Real} _start
 * @param {Real} _thickness
 
function draw_arc(_x, _y, _radius, _degrees, _start = 0, _thickness = 1) {
	var _steps = ceil((_radius * ((_degrees / 360) * TAU)) / 10)
	var _step_degree = _degrees / _steps
	
	var _last_point = {
		x: _x + lengthdir_x(_radius, _start),
		y: _y + lengthdir_y(_radius, _start)
	}
	
	for (var _i = 1; _i <= _steps; _i++) {
		var _end_angle = _start + (_i * _step_degree)
		var _end_angle_compensated = _end_angle + (0.1 * _step_degree)
		var _end_x = _x + lengthdir_x(_radius, _end_angle)
		var _end_y = _y + lengthdir_y(_radius, _end_angle)
		
		var _end_x_compensated = _x + lengthdir_x(_radius, _end_angle_compensated)
		var _end_y_compensated = _y + lengthdir_y(_radius, _end_angle_compensated)
		
		draw_line_width(_last_point.x, _last_point.y, _end_x_compensated, _end_y_compensated, _thickness)	
		_last_point.x = _end_x
		_last_point.y = _end_y
	}
}
*/

function get_circle_precision_from_radius_and_degrees(_radius, _degrees) {
	return floor(log2(max(1, ceil(_radius / 10))) * 10 * (_degrees / 360))
}

/**
 * A filled pie slice (sector) from the center out to _radius
 * @param {Real} _x
 * @param {Real} _y
 * @param {Real} _radius
 * @param {Real} _degrees -- sweep
 * @param {Real} _start -- angle the sweep starts at
 */
function draw_pie(_x, _y, _radius, _degrees, _start = 0) {
	if (_degrees <= 0) {
		return
	}
	var _segments = max(3, get_circle_precision_from_radius_and_degrees(_radius, _degrees))
	// width 0 so the slice's edge sits exactly at _radius
	__draw_circle_ext(_x, _y, _radius, _segments, _start, _degrees, 0, false)
}

/**
 * A filled circle built from our own triangle fan. Use this instead of the built-in draw_circle for anything drawn
 * under a custom shader (e.g. shader_set_shine): the built-in draw_circle doesn't draw at all under sh_shine, while
 * primitives we build ourselves (like draw_arc's) work fine
 * @param {Real} _x
 * @param {Real} _y
 * @param {Real} _radius
 * @param {Real} _segments -- 24 matches draw_circle's default precision
 */
function draw_circle_filled(_x, _y, _radius, _segments = 24) {
	__draw_circle_ext(_x, _y, _radius, _segments, 0, 360, 0, false)
}

function draw_arc(_x, _y, _radius, _degrees, _start = 0, _thickness = 1, _segment_override = 0) {
	var _segments = _segment_override > 0 ? _segment_override : get_circle_precision_from_radius_and_degrees(_radius, _degrees)
	
	// the +1 is to fix a minor bug that makes the arc appear shifted, not sure where in the logic it's occuring
	return __draw_circle_ext(_x + 1, _y + 1, _radius, _segments, _start, _degrees, _thickness, true)
}

// From https://marketplace.yoyogames.com/assets/1423/advanced-circle-drawing
// by Patych
// Upgraded to GMS2 and cleaned up by Matt
// 
// Arguments: 
// x, y — Center of circle.
// r — Radius.
// bones — Amount of bones. More bones = more quality, but less speed. Minimum — 3.
// ang — Angle of first circle's point.
// angadd — Angle of last circle's point (relative to ang). 
// width — Width of circle (may be positive or negative).
// outline — 0 = curve, 1 = sector. 
function __draw_circle_ext(_x, _y, r, bones = 15, ang = 0, angadd = 360, width = 1, outline = false)
{
    bones = max(3, bones);
 
    var a = angadd / bones;
    var halfWidth = width / 2;
    var lp = r + halfWidth;
    var lm = r - halfWidth;
    var AAa = ang + angadd;
    
    if(outline)
    {
        //OUTLINE
        draw_primitive_begin(pr_trianglestrip); //Change to pr_linestrip, to see how it works.
        draw_vertex(_x + lengthdir_x(lm, ang), _y + lengthdir_y(lm, ang)); //First point.
        for(var i = 1; i <= bones; i++)
        {
            var dp = ang + a * i;
            var dm = dp - a;
            draw_vertex(_x + lengthdir_x(lp, dm), _y + lengthdir_y(lp, dm));
            draw_vertex(_x + lengthdir_x(lm, dp), _y + lengthdir_y(lm, dp));
        }
        draw_vertex(_x + lengthdir_x(lp, AAa), _y + lengthdir_y(lp,AAa));
        draw_vertex(_x + lengthdir_x(lm, AAa), _y + lengthdir_y(lm,AAa)); //Last two points to make circle look right.
    }
    else
    {
        //SECTOR
        draw_primitive_begin(pr_trianglefan); //Change to pr_linestrip, to see how it works.
        draw_vertex(_x, _y); //First point in the circle's center.
        for(var i = 1; i <= bones; i += 1)
        {
            var dp = ang + a * i;
            var dm = dp - a;
            draw_vertex(_x + lengthdir_x(lp,dm), _y + lengthdir_y(lp,dm));
        }
        draw_vertex(_x + lengthdir_x(lp,AAa), _y + lengthdir_y(lp,AAa)); //Last point.
    }
    draw_primitive_end();
}

/**
 * @param {Struct.Bounds} _rectangle_bounds
 * @param {Real} _ratio
 * @param {String} _align
 * @returns {Struct.Bounds}
 */
function draw_input_box_with_progress(_rectangle_bounds, _ratio, _align) {
	_ratio = max(0, min(_ratio, 1))
	var _final_bounds = draw_rounded_rectangle(_rectangle_bounds, 8, 3)

	draw_set_alpha(0.15)
	if (is_undefined(_align) || _align == ALIGN_LEFT) {
		draw_roundrect(
			_rectangle_bounds.x0, 
			_rectangle_bounds.y0, 
			_rectangle_bounds.x0 + _rectangle_bounds.width * _ratio,
			_rectangle_bounds.y1, 
			false
		)
	} else if (_align == ALIGN_RIGHT) {
		draw_roundrect(
			_rectangle_bounds.x1 - _rectangle_bounds.width * _ratio, 
			_rectangle_bounds.y0, 
			_rectangle_bounds.x1,
			_rectangle_bounds.y1, 
			false
		)
	} else {
		// TODO: this is not right, but also not in use so 
	}

	reset_composite_color()
	
	return new Bounds(_final_bounds.x0, _final_bounds.y0, _final_bounds.x1, _final_bounds.y1)
}

/**
 * @param {Struct.CompositeColor} _c
 */
function draw_set_composite_color(_c) {
	draw_set_alpha(_c.o)
	draw_set_color(_c.c)
}

function reset_composite_color() {
	draw_set_composite_color(new CompositeColor(c_white, 1))
}


// ----------------------------------------------------------------------
// these are background circle related functions

/**
 * @param {Real} _i
 * @returns {Real}
 */
function get_radius_for_ring(_i) {
	return global.bg_circle_max_radius - ((_i / global.bg_number_of_circles) * global.bg_circle_magnitude)
}

/**
 * this inverse of get_radius_for_ring
 * @param {Real} _distance
 * @returns {Real}
 */
function get_ring_from_distance(_distance) {
	return  floor(global.bg_number_of_circles * (global.bg_circle_max_radius - _distance) / global.bg_circle_magnitude)
}

/**
 * @param {Struct.Bounds} _bounds
 * @param {Real} _color
 * @param {Real} _spr
 * @param {Real} _scale
 * @returns {Real}
 */
function draw_rectangle_clipped(_bounds, _color, _spr, _scale) {
	// Set the shader
	var _mask_texture = sprite_get_texture(_spr, 0);
	shader_set(sh_clip_sprite);
/*
	// Set the mask texture as the second texture unit
	var _u_mask_texture = shader_get_uniform(sh_clip_sprite, "u_maskTexture");
	texture_set_stage(1, _mask_texture);
	shader_set_uniform_i(_u_mask_texture, 1);

	// Set the scaling for the mask
	var _u_scale = shader_get_uniform(sh_clip_sprite, "u_scale");
	shader_set_uniform_f(_u_scale, _scale, _scale);
*/
	// Draw the rectangle
	draw_rectangle_color(_bounds.x0, _bounds.y0, _bounds.x1, _bounds.y1, _color, _color, _color, _color, false);

	// Reset the shader
	shader_reset();

}
/**
 * Draws a menu item (obj_menu_button, obj_menu_number_input, obj_menu_toggle): its label centered in a rounded
 * outline box. Uses the current font, color, and alpha.
 * @param {Real} _x -- the box's left edge for ALIGN_LEFT, its center for ALIGN_CENTER
 * @param {Real} _y -- the box's vertical center
 * @param {String} _message
 * @param {String} _align -- ALIGN_LEFT or ALIGN_CENTER
 * @param {Real} _min_width -- the box is at least this wide (not counting padding), so a group of items can match
 * @param {Bool} _filled -- also fill the box (at a quarter of the current alpha), e.g. a selected toggle
 * @param {Bool} _inverted -- a solid box in the current color with black text (e.g. a button strobing as it's chosen)
 * @returns {Struct.Bounds} the box's bounds, for click testing
 */
function draw_menu_box(_x, _y, _message, _align = ALIGN_CENTER, _min_width = 0, _filled = false, _inverted = false) {
	var _pad_x = 12
	var _content_width = max(string_width(_message), _min_width)
	var _x0 = _align == ALIGN_LEFT ? _x : _x - (_content_width / 2) - _pad_x
	var _x1 = _x0 + _content_width + (_pad_x * 2)
	var _text_x = (_x0 + _x1) / 2

	// measure first, so an inverted box can be filled before its text is drawn on top
	var _text_bounds = draw_text_with_alignment(_text_x, _y, _message, ALIGN_CENTER, undefined, true)
	var _box = new Bounds(_x0, _text_bounds.y0 - 8, _x1, _text_bounds.y1 + 6)
	var _corner = _box.height / 2

	if (_inverted) {
		draw_roundrect_ext(_box.x0, _box.y0, _box.x1, _box.y1, _corner, _corner, false)
		var _color = draw_get_color()
		draw_set_color(c_black)
		draw_text_with_alignment(_text_x, _y, _message, ALIGN_CENTER)
		draw_set_color(_color)
		return _box
	}

	draw_text_with_alignment(_text_x, _y, _message, ALIGN_CENTER)
	draw_roundrect_ext(_box.x0, _box.y0, _box.x1, _box.y1, _corner, _corner, true)
	if (_filled) {
		var _alpha = draw_get_alpha()
		draw_set_alpha(_alpha * 0.25)
		draw_roundrect_ext(_box.x0, _box.y0, _box.x1, _box.y1, _corner, _corner, false)
		draw_set_alpha(_alpha)
	}
	return _box
}

/**
 * The width to pass as min_box_width so a group of menu items all draw the same size
 * @param {Array<String>} _messages -- every label the group will show (use the longest expected value for inputs)
 * @param {Asset.GMFont} _font -- the font the items draw with
 * @returns {Real}
 */
function get_menu_box_group_width(_messages, _font = fnt_title) {
	draw_set_font(_font)
	var _width = 0
	for (var _i = 0; _i < array_length(_messages); _i++) {
		_width = max(_width, string_width(_messages[_i]))
	}
	return _width
}

// -------------------------------------------------------------------------------------------
// SHINE
// -------------------------------------------------------------------------------------------

/**
 * Sets sh_shine for drawing something "shiny": while it's set, whatever is drawn (sprites or primitives) turns
 * white where the shared shine band is passing. Call shader_reset() when done. Timed off game time, so the band
 * freezes while paused. Can't be combined with sh_hue_shift (only one shader at a time).
 * Note: the built-in draw_circle draws nothing under this shader -- use draw_circle_filled / draw_arc / draw_pie
 *
 * Scaling: global.shine_width is the band's width on something global.shine_reference_size across (the shield).
 * Pass a thing's center and size and the band is scaled to it around its center -- both its width and how far it
 * moves -- so a small thing gets a proportionally thin band that crosses it at the same pace the full band crosses
 * the shield (instead of being swallowed whole by it, which reads as a flash). Everything still lights up as the
 * one shared band passes it, so it still reads as one light crossing the screen. Leave them out for the unscaled band
 * @param {Real} _x -- the thing's center
 * @param {Real} _y
 * @param {Real} _size -- px across
 * @param {Bool} _textured -- true when drawing sprites/text; false (default) for primitives (draw_circle_filled,
 * draw_arc, ...), which have no texture bound to sample
 */
function shader_set_shine(_x = undefined, _y = undefined, _size = undefined, _textured = false) {
	if (!global.shine_enabled) {
		return
	}
	if (!shader_is_compiled(sh_shine)) {
		debug("sh_shine isn't compiled -- drawing without shine")
		return
	}
	static _u_dir = shader_get_uniform(sh_shine, "u_vDir")
	static _u_band_pos = shader_get_uniform(sh_shine, "u_fBandPos")
	static _u_half_width = shader_get_uniform(sh_shine, "u_fHalfWidth")
	static _u_textured = shader_get_uniform(sh_shine, "u_fTextured")

	var _dir_x = lengthdir_x(1, global.shine_angle)
	var _dir_y = lengthdir_y(1, global.shine_angle)

	// the room's extent along the travel direction: the band starts just before it and ends just past it
	var _start = infinity
	var _end = -infinity
	var _corners = [[0, 0], [global.room_width, 0], [0, global.room_height], [global.room_width, global.room_height]]
	for (var _i = 0; _i < 4; _i++) {
		var _d = _corners[_i][0] * _dir_x + _corners[_i][1] * _dir_y
		_start = min(_start, _d)
		_end = max(_end, _d)
	}
	_start -= global.shine_width
	_end += global.shine_width

	// sweep once at the start of each interval; the rest of the interval it sits past the end, out of sight
	var _seconds = get_play_time() / 1000
	var _progress = (_seconds mod global.shine_interval) / global.shine_sweep_duration
	var _band_pos = lerp(_start, _end, min(_progress, 1))
	var _half_width = global.shine_width / 2

	// scale the band around the thing's center: its offset from the center and its width both shrink (or grow) by
	// the same factor, so it lines up with the shared band's timing (centered when the shared band is) but sized
	// to the thing. While the shared band is parked off-room, the scaled one is still clear of the thing
	if (!is_undefined(_size)) {
		var _scale = _size / global.shine_reference_size
		var _center = _x * _dir_x + _y * _dir_y
		_band_pos = _center + (_band_pos - _center) * _scale
		_half_width *= _scale
	}

	shader_set(sh_shine)
	shader_set_uniform_f(_u_dir, _dir_x, _dir_y)
	shader_set_uniform_f(_u_band_pos, _band_pos)
	shader_set_uniform_f(_u_half_width, _half_width)
	shader_set_uniform_f(_u_textured, _textured ? 1 : 0)
}
