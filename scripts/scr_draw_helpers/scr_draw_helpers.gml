/**
 * @param {Real} _color
 * @param {Real} _opacity
 */
function CompositeColor(_color, _opacity) constructor {
	c = _color
	o = _opacity
}

/**
 * @param {Struct.CompositeColor} _color1
 * @param {Struct.CompositeColor} _color2
 * @param {Real} _proportion -- [0,1] where 0 = full _color1, 1 = full _color2
 * @returns {Struct.CompositeColor}
 */
function blend_composite_colors(_color1, _color2, _proportion = 0.5) {
	var _blended_color = merge_color(_color1.c, _color2.c, _proportion)
	var _blended_opacity = lerp(_color1.o, _color2.o, _proportion)
	return new CompositeColor(_blended_color, _blended_opacity)
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
	var _with_padding = _apply_padding_to_bounds(_bounds, global.margin_md, global.margin_md)
	
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

function draw_text_with_alignment(_x, _y, _text, _align = ALIGN_LEFT, _line_height = 1.1) {	
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
	
		_line_bounds.x1 = _line_bounds.x0 + _str_width
		_line_bounds.y1 = _line_bounds.y0 + _str_height
	
		draw_text(_line_bounds.x0, _line_bounds.y0, _line_text);
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

function draw_arc(_x, _y, _radius, _degrees, _start = 0, _thickness = 1, _segment_override = 0) {
	var _segments = _segment_override > 0 ? _segment_override : floor(log2(max(1, ceil(_radius / 10))) * 10 * (_degrees / 360))
	
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
 * @param {Real} _x0
 * @param {Real} _y0
 * @param {Real} _x1
 * @param {Real} _y1
 * @param {Bool} _horizontal_first
 */
function draw_line_between(_x0, _y0, _x1, _y1, _horizontal_first = false) {
	var _y_direction = normalize(_y1 - _y0)
	_y1 -= 30 * _y_direction
	
	if (_horizontal_first) {
		var _x_direction = normalize(_x1 - _x0)
		_x0 += 10 * _x_direction
	} else {
		_y0 += 10 * _y_direction
	}
	
	var _thickness = 2
	
	var _half_y = _y0 + _y_direction * (_y1 - _y0) / 2
	if (_horizontal_first) {
		_half_y = _y0
	}
	
	draw_line_width(_x0, _y0, _x0, _half_y, _thickness)	
	
	if (_x0 != _x1) {
		draw_line_width(_x0, _half_y, _x1, _half_y, _thickness)
	}
	draw_line_width(_x1, _half_y, _x1, _y1, _thickness)
}