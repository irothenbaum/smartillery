/// @func debug()
/// @return {undefined}
function debug() {
	var _args = argument_count;
	var _out = "";

	for (var _i=0; _i < _args; ++_i) {
	    _out += string(argument[_i]);
   
	    if (_i < _args - 1) {
	        _out += " , "
	    }
	}

	show_debug_message(_out);
}

function get_game_controller() {
	if (global.is_solo || is_host(get_my_steam_id_safe())) {
		return instance_find(obj_game_controller, 0)
	} else {
		return instance_find(obj_guest_game_controller, 0)
	}
}

function get_player() {
	var _player = instance_find(obj_player, 0)
	return _player
}

global._G.input_player_map = {}
function get_input(_player_id) {
	if (struct_exists(global._G.input_player_map, _player_id)) {
		return global._G.input_player_map[$ _player_id]
	}
	
	var _input = find_instance(obj_input, function (_inst, _i, _total) {
		return _inst.owner_player_id == get_my_steam_id_safe()
	})
	
	if (is_undefined(_input)) {
		debug("Cannot find input for player ", _player_id)
	}
	
	global._G.input_player_map[$ _player_id] = _input
	
	return _input
}

/// returns {Real}
function get_current_wave_number() {
	return get_game_controller().current_wave
}

/**
 * @param {Asset.GMObject} _instance_type
 * @param {Function} _condition
 * @returns {Id.Instance|undefined}
 */
function find_instance(_instance_type, _condition) {
	var _count = instance_number(_instance_type)
	
	for (var _i =0; _i < _count; _i++) {
		var _inst = instance_find(_instance_type, _i)
		// we pass any other argument back to the callback
		if (script_execute(argument[1], _inst, _i, _count)) {
			return _inst
		}
	}
	
	return undefined
}

/// @func get_all_enemy_instances()
/// @return {Array}
function get_all_enemy_instances() {
	var _enemy1 = get_array_of_instances(obj_enemy_1)
	var _enemy2 = get_array_of_instances(obj_enemy_2)
	var _enemy3 = get_array_of_instances(obj_enemy_3)
	var _enemy4 = get_array_of_instances(obj_enemy_4)
	var _enemy4_fragment = get_array_of_instances(obj_enemy_4_fragment)
	var _enemy5 = get_array_of_instances(obj_enemy_5)
	var _enemy5_missile = get_array_of_instances(obj_enemy_5_missile)
	var _enemy_ring = get_array_of_instances(obj_ring_enemy)
	
	return array_concat(
		_enemy1,
		_enemy2,
		_enemy3,
		_enemy4,
		_enemy4_fragment,
		_enemy5
	)
}

/// @func count_all_enemies()
/// @return {Real}
function count_all_enemies() {
	return 0 
	+ instance_number(obj_enemy_1) 
	+ instance_number(obj_enemy_2)
	+ instance_number(obj_enemy_3)
	+ instance_number(obj_enemy_4)
	+ instance_number(obj_enemy_4_fragment)
	+ instance_number(obj_enemy_5)
	+ instance_number(obj_enemy_5_missile)
	+ instance_number(obj_ring_enemy)
}

/// takes a function that receives 2 params: enemy instance, index
function for_each_enemy() {
	var _instances = get_all_enemy_instances()
	var _count = array_length(_instances)
	
	for (var _i =0; _i < _count; _i++) {
		// we pass any other argument back to the callback
		script_execute(argument[0], _instances[_i], _i, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6])
	}
}

/**
 * @param {Asset.GMObject} _instance_type
 * @returns {Array<Id.Instance>}
 */
function get_array_of_instances(_instance_type) {
	var _count = instance_number(_instance_type)
	var _instances = []
	for (var _i = 0; _i < _count; _i++) {
		array_push(_instances, instance_find(_instance_type, _i))
	}
	return _instances
}

/// @param {Bool} [_status] 
function toggle_pause(_status) {
	global.paused = bool(_status) ? _status : !global.paused
	
	if (global.paused) {
		global.pause_start = current_time
	} else {
		global.total_paused_time += current_time - global.pause_start
		global.pause_start = undefined
	}
	
	broadcast(EVENT_TOGGLE_PAUSE, global.paused)
	
	var _layer = layer_get_id(LAYER_INSTANCES);
	var _layer_fg = layer_get_id(LAYER_FG_EFFECTS);
	var _layer_bg = layer_get_id(LAYER_BG_EFFECTS);
	var _instances = layer_get_all_elements(_layer);
	var _instances_fg = layer_get_all_elements(_layer_fg);
	var _instances_bg = layer_get_all_elements(_layer_bg);
	
	var _all_instances = array_concat(_instances, _instances_fg, _instances_bg)
	var _instance_count = array_length(_all_instances)	
	
	
	debug("Turning pause " + (global.paused ? "ON" : "OFF") + " for " + string(_instance_count) + " instances")
	var _alarm_length = 12
	
	for (var _i = 0; _i < _instance_count; _i++) {
		var _inst = layer_instance_get_instance(_all_instances[_i])
	
		with (_inst) {
			if (global.paused) {
				// memoize our pre-pause values
				paused_speed = speed
				paused_alarms = []
				is_paused = true
				
				for (var _j = 0; _j < _alarm_length; _j++) {
					if (alarm[_j] > 0) {
						// save the alarm state
						paused_alarms[_j] = alarm[_j]
						// turn off the alarm
						alarm[_j] = -1
					} else {
						paused_alarms[_j] = 0
					}
				}
				
				// disable movement
				speed = 0
			} else {
				// if is_paused was not set, then this object was not around when we first paused
				// probably was an ultimate or something
				if (!variable_instance_exists(self, "is_paused") || !is_paused) {
					continue
				}
				// restore pre-pause values
				speed = paused_speed
				
				if (variable_instance_exists(self, "paused_alarms")) {
					for (var _j = 0; _j < _alarm_length; _j++) {
						if (paused_alarms[_j] > 0) {
							alarm[_j] = paused_alarms[_j]
						}
					}
				}
				
				// remove all our paused states
				paused_speed = undefined
				paused_alarms = undefined
				is_paused = false
			}
		}
	}

}

/// @return {Real}
function get_play_time() {
	return current_time - global.total_paused_time
}

function round_ext(_val, _round_to) {
	return round(_val / _round_to) * _round_to
}


function is_spot_in_bounds(_x, _y, _bounds) {
	return _bounds.x0 < _x and _bounds.x1 > _x and _bounds.y0 < _y and _bounds.y1 > _y
}

/// @description color_to_array( color);
/// @param _color
// Converts GML color constants to rgb float array
function color_to_array() {
	var _hex = [];
	var _ret = [];
	var _quotient = argument0;

	// Convert to hex
	for( var _i = 0; _quotient != 0; ++_i){
		_hex[_i] = _quotient % 16;
		_quotient = floor(_quotient / 16);
	}

	// Make sure this is a color code
	while(array_length(_hex) < 6){
		_hex[array_length(_hex)] = 0;
	}
	if(array_length(_hex) > 6){
		show_error( "Unknown color: " + string( argument0), true);
		return -1;
	}

	// Convert hex to RGB
	for( var _i = 0; _i < 3; ++_i){
		_ret[_i] = _hex[_i * 2 + 1] * 16 + _hex[_i * 2];
		_ret[_i] /= 255; // Change from 255 to float
	}

	return _ret;
}

/**
 * @param {Real} _x0
 * @param {Real} _y0
 * @param {Real} _x1
 * @param {Real} _y1
 */
function Bounds(_x0, _y0, _x1, _y1) constructor {
	x0 = _x0
	y0 = _y0
	x1 = _x1
	y1 = _y1
	width = x1 - x0
	height = y1 - y0
	xcenter = x0 + width / 2
	ycenter = y0 + height / 2
}

function _apply_padding_to_bounds(_bounds, _vertical, _horizontal) {
	return new Bounds(_bounds.x0 - _horizontal,_bounds.y0 - _vertical,_bounds.x1 + _horizontal,_bounds.y1 + _vertical)
}

function get_max_bounds(_bounds_array) {
	if (!is_array(_bounds_array) || array_length(_bounds_array) == 0) {
		return undefined
	}
	var _ret_val = {
		x0: _bounds_array[0].x0,
		y0: _bounds_array[0].y0,
		x1: _bounds_array[0].x1,
		y1: _bounds_array[0].y1,
	}
	for (var _i = 1; _i < array_length(_bounds_array); _i++) {
		var _these_bounds = _bounds_array[_i];
		_ret_val.x0 = min(_ret_val.x0, _these_bounds.x0)
		_ret_val.x1 = max(_ret_val.x1, _these_bounds.x1)
		_ret_val.y0 = min(_ret_val.y0, _these_bounds.y0)
		_ret_val.y1 = max(_ret_val.y1, _these_bounds.y1)
	}
	
	return new Bounds(_ret_val.x0, _ret_val.y0, _ret_val.x1, _ret_val.y1)
}

/// @return {Real} -- will return 1 or -1, or 0
function normalize(_num) {
	return _num < 0 ? -1 : (_num > 0 ? 1 : 0)
}

function flip_coin(_sides = 2) {
	return roll_dice(_sides) == 1
}

function roll_dice(_sides = 6) {
	return irandom(_sides - 1) + 1
}

/**
 * @param {Real} _from_x
 * @param {Real} _from_y
 * @param {Real} _to_x
 * @param {Real} _to_y
 * @param {Real} _distance
 */
function get_tangent_point(_from_x, _from_y, _to_x, _to_y, _distance) {
	var _reverse = flip_coin() ? -1 : 1
	var _tangent_direction = point_direction(_to_x, _to_y, _from_x, _from_y) + (90 * _reverse)
	return {
		x: _to_x + lengthdir_x(_distance, _tangent_direction),
		y: _to_y + lengthdir_y(_distance, _tangent_direction)
	}
}

/// @param {string} _str
/// @param {Real} _pos
/// @param {string} _insert
function string_replace_at(_str, _pos, _insert) {
	return string_copy(_str, 1, _pos-1) + _insert + string_delete(_str, 1, _pos);
}


function get_bounds_of_draw_functions(_fiber, _offset) {
	var _bounds_array = []
	var _finished = false
	do {
		var _next_bounds = fiber_call(_fiber, _offset)
	} until(_finished)
}

/// @param {Struct} _target_object
/// @param {Struct} _source_object
/// @return {Struct}
function object_keys_copy(_target_object, _source_object) {	
	var _keys = variable_struct_get_names(_source_object);
	var _key_count = array_length(_keys)
	for (var _i = 0; _i < _key_count; _i++) {
	    var _key = _keys[_i];
	    _target_object[$ _key] = _target_object[$ _key];
	}
	
	// it overwrites inline AND returns the new object
	return _target_object
}

/**
 * @param {Any} _val
 * @returns {Struct}
 */
function initialize_player_map(_val) {
	var _ret_val = {}
	
	for_each_player(method({r: _ret_val, v: _val}, function(_player_id) {
		r[$ _player_id] = v
	}))
	return _ret_val
}

function reset_game_state() {
	global.is_math_mode = true
	global.total_paused_time = 0
	global.paused = false
	global.game_seed = randomize()
	global.is_solo = false
	global.is_coop = false
	global.is_training = false
	global.focused_input = undefined
	global.lobby_id = undefined
}

function array_copy_all(_arr) {
	var _copy = []
	array_copy(_copy, 0, _arr, 0, array_length(_arr));
	return _copy
}

function delta_time_seconds() {
	return delta_time / 1000000; // Convert delta_time to seconds
}

function set_viewport_dimensions() {
	var _cam = camera_create_view(0, 0, global.room_width, global.room_height);
	view_set_camera(0, _cam);

	view_set_wport(0, global.room_width);
	view_set_hport(0, global.room_height);

	view_enabled = true;
	view_visible[0] = true;
}

// this takes an angle from a point at the center of a rectangle and returns the position along the boundary that it intersects
/// @param {Real} _rect_width
/// @param {Real} _rect_height
/// @param {Real} _angle // in degrees
function find_point_on_rectangle_boundary_at_angle(_rect_width, _rect_height, _angle) {	
	_rect_width = _rect_width / 2
	_rect_height = _rect_height / 2
	
	// Convert angle to radians
    var _angle_radians = (_angle * pi) / 180
	
	// Calculate direction vector components
    var _dx = cos(_angle_radians)
    var _dy = -1 * sin(_angle_radians)
	
	// Find intersection with each edge of the rectangle
    var _t_max = 99999
	
	// Intersection with left and right sides
    if (_dx != 0) {
        _t_max = min(_t_max, (_rect_width / abs(_dx)))
    }

    // Intersection with top and bottom sides
    if (_dy != 0) {
        _t_max = min(_t_max, (_rect_height / abs(_dy)))
    }

    // Calculate intersection point
    return { 
		x: _t_max * _dx + global.xcenter, 
		y: _t_max * _dy + global.ycenter
	}
}

/**
 */
 
function find_point_distance_to_line(_line_x1, _line_y1, _line_x2, _line_y2, _point_x, _point_y) {
	// Calculate perpendicular distance from enemy to line segment
		var _dx = _line_x2 - _line_x1
		var _dy = _line_y2 - _line_y1
		var _line_length_sq = _dx * _dx + _dy * _dy

		if (_line_length_sq == 0) {
			return
		}

		// Calculate projection parameter t
		var _t = ((_point_x - _line_x1) * _dx + (_point_y - _line_y1) * _dy) / _line_length_sq
		_t = clamp(_t, 0, 1)

		// Find closest point on line segment
		var _closest_x = _line_x1 + _t * _dx
		var _closest_y = _line_y1 + _t * _dy

		// Calculate distance from enemy to closest point
		var _dist = point_distance(_point_x, _point_y, _closest_x, _closest_y)
		
		return _dist
}