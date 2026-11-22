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
	if (global.is_solo || is_host(0)) {
		return instance_find(obj_game_controller, 0)
	} else {
		return instance_find(obj_guest_game_controller, 0)
	}
}

function get_player() {
	var _player = instance_find(obj_player, 0)
	return _player
}

function get_input(_player_id) {
	with (obj_input) {
		if (owner_player_id == _player_id) {
			return id
		}
	}
	
	debug("Cannot find input for player ", _player_id)
	return undefined
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

/// Prefer `with (obj_enemy_parent)` for simple iteration -- use this when you need an array (sorting, pairs, etc.)
/// @func get_all_enemy_instances()
/// @return {Array}
function get_all_enemy_instances() {
	return get_array_of_instances(obj_enemy_parent)
}

/**
 * @param {Id.Instance} _inst
 * @return {Bool}
 */
function instance_is_enemy(_inst) {
	return object_is_ancestor(_inst.object_index, obj_enemy_parent)
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


/**
 * @param {Bool} _status
 */
function set_paused(_status) {
	var _next_paused = bool(_status)
	
	if (_next_paused == global.paused) {
		return
	}
	
	global.paused = _next_paused
	
	set_audio_paused(global.paused)

	// pause streak sparks on player
	var _player = get_player()
	with(_player) {
		if (!is_undefined(streak_fire)) {
			pause_particle(streak_fire.system, global.paused)
		}
	}
	
	// pause slow sparks on enemies
	with (obj_enemy_parent) {
		if (!is_undefined(slow_sparks)) {
			pause_particle(slow_sparks, global.paused)
		}
	}
	
	// pause particle effects
	with (obj_particle_effect) {
		pause_particle(ps, global.paused)
	}
	
	// message clears on pause toggle
	with (obj_input) {
		message = ""
		if (!is_undefined(streak_fire)) {
			pause_particle(streak_fire.system, global.paused)
		}
	}
	
	debug("Turning pause " + (global.paused ? "ON" : "OFF") + " for " + string(instance_count) + " instances")
	var _alarm_length = 12
	
	with (all) {
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
 
function toggle_pause() {
	set_paused(!global.paused)
}

/// Milliseconds of (unpaused) game time. Advanced one fixed step per frame by advance_play_time()
/// @returns {Real}
function get_play_time() {
	return global.play_time_ms
}

function advance_play_time() {
	global.play_time_ms += 1000 / game_get_speed(gamespeed_fps)
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
 * @param {Id.Instance} _i
 * @returns {Struct.Bounds}
 */
function get_bounds_for_instance(_i) {
	with (_i) {
		var _spr = object_get_sprite(object_index);
		if (_spr == -1) {
			// default bounds to a generic size
			return new Bounds(
				x - global.player_body_radius, 
				y - global.player_body_radius, 
				x + global.player_body_radius, 
				y +  global.player_body_radius
			)
		}
		
		var _left   = x - sprite_xoffset;
		var _top    = y - sprite_yoffset;
		var _right  = _left + sprite_width;
		var _bottom = _top + sprite_height;
		
		return new Bounds(_left, _top, _right, _bottom)
	}
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

/**
 * @returns {Struct.Bounds}
 */
function apply_padding_to_bounds(_bounds, _vertical, _horizontal) {
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
	// quitting while paused would otherwise leave sfx paused forever and the music muffled
	set_audio_paused(false)
	stop_all_sfx(0)
	// global.is_math_mode is left alone: the mode picked on the main menu sticks until it's changed there
	global.play_time_ms = 0
	global.paused = false
	randomize_game_seed()
	global.is_solo = false
	global.is_coop = false
	global.is_training = false
	global.focused_input = undefined
	global.active_player_ids = []
	global.player_device_map = {}
}

function array_copy_all(_arr) {
	var _copy = []
	array_copy(_copy, 0, _arr, 0, array_length(_arr));
	return _copy
}

/// The game runs at a fixed step, so each frame advances game time by exactly 1 / fps seconds.
/// If the game lags, everything slows down together instead of drifting out of sync.
/// @returns {Real}
function step_seconds() {
	return 1 / game_get_speed(gamespeed_fps)
}

function set_viewport_dimensions() {
	var _cam = camera_create_view(0, 0, global.room_width, global.room_height);
	view_set_camera(0, _cam);

	view_set_wport(0, global.room_width);
	view_set_hport(0, global.room_height);

	view_enabled = true;
	view_visible[0] = true;
}

/// Main menu only: like set_viewport_dimensions, but the camera shows a MENU_ZOOM-sized window of the world,
/// scaled up to fill the full port. It's placed so the player (world center) is _margin room px from both the
/// top and right edges of the view. The GUI layer is unaffected.
function set_menu_viewport_dimensions(_zoom = MENU_ZOOM, _margin = MENU_PLAYER_MARGIN) {
	var _view_w = global.room_width * _zoom
	var _view_h = global.room_height * _zoom
	var _view_x = global.xcenter + _margin - _view_w
	var _view_y = global.ycenter - _margin

	var _cam = camera_create_view(_view_x, _view_y, _view_w, _view_h);
	view_set_camera(0, _cam);

	view_set_wport(0, global.room_width);
	view_set_hport(0, global.room_height);

	view_enabled = true;
	view_visible[0] = true;
}

/**
 * Converts a room position to where it appears on the GUI layer, through view 0's camera
 * @param {Real} _x
 * @param {Real} _y
 * @returns {{x: Real, y: Real}}
 */
function world_to_gui(_x, _y) {
	var _cam = view_camera[0]
	return {
		x: (_x - camera_get_view_x(_cam)) * display_get_gui_width() / camera_get_view_width(_cam),
		y: (_y - camera_get_view_y(_cam)) * display_get_gui_height() / camera_get_view_height(_cam),
	}
}

/**
 * Converts a GUI-layer position to the room position drawn there, through view 0's camera
 * @param {Real} _x
 * @param {Real} _y
 * @returns {{x: Real, y: Real}}
 */
function gui_to_world(_x, _y) {
	var _cam = view_camera[0]
	return {
		x: camera_get_view_x(_cam) + _x * camera_get_view_width(_cam) / display_get_gui_width(),
		y: camera_get_view_y(_cam) + _y * camera_get_view_height(_cam) / display_get_gui_height(),
	}
}

// this takes an angle from a point at the center of a rectangle and returns the position along the boundary that it intersects
/// @param {Struct.Bounds} _bounds 
/// @param {Real} _angle // in degrees
function find_point_on_bounds_at_angle(_bounds, _angle) {	
	var _rect_width = _bounds.width / 2
	var _rect_height = _bounds.height / 2
	
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
		x: _t_max * _dx + _bounds.xcenter, 
		y: _t_max * _dy + _bounds.ycenter
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
/**
 * How much of an alarm's countdown is left, for showing timers (ultimates ring, stationary turret, ...).
 * Reads the paused value while paused, since set_paused turns alarms off and holds them in paused_alarms
 * @param {Id.Instance} _inst
 * @param {Real} _total_frames -- what the alarm was started at
 * @param {Real} _full_buffer -- in seconds: the ratio stays at 1 for this long after the alarm starts, then counts down over the rest
 * @param {Real} _alarm_index
 * @returns {Real} [0,1]
 */
function get_alarm_remaining_ratio(_inst, _total_frames, _full_buffer = 0, _alarm_index = 0) {
	if (_total_frames <= 0) {
		return 1
	}
	with (_inst) {
		var _remaining = (variable_instance_exists(id, "is_paused") && is_paused) ? paused_alarms[_alarm_index] : alarm[_alarm_index]
		var _countdown_frames = max(1, _total_frames - _full_buffer * game_get_speed(gamespeed_fps))
		return clamp(_remaining / _countdown_frames, 0, 1)
	}
	return 0
}

/**
 * How many more hits a targetable can take. Enemies with more than 1 health track it in my_health; everything else dies in 1 hit
 * @param {Id.Instance} _inst
 * @returns {Real}
 */
function get_instance_health(_inst) {
	return variable_instance_exists(_inst, "my_health") ? _inst.my_health : 1
}

/**
 * A new struct with every key of _a, then every key of _b (so _b wins on conflicts). Neither input is changed.
 * @param {Struct} _a
 * @param {Struct} _b
 * @returns {Struct}
 */
function merge_structs(_a, _b) {
	var _result = {}
	var _sources = [_a, _b]
	for (var _s = 0; _s < 2; _s++) {
		var _names = variable_struct_get_names(_sources[_s])
		for (var _i = 0; _i < array_length(_names); _i++) {
			_result[$ _names[_i]] = _sources[_s][$ _names[_i]]
		}
	}
	return _result
}

/**
 * Fades the screen to black, changes to _room (or restarts, if _room is the current room), then fades back in.
 * Use this instead of room_goto / room_restart. While a fade out is underway, further calls are ignored, so a
 * double click or double submit can't start a second transition.
 * @param {Asset.GMRoom} _room
 */
function transition_to_room(_room) {
	var _existing = instance_find(obj_room_transition, 0)
	if (instance_exists(_existing)) {
		with (_existing) {
			// already leaving -- ignore. If it's still fading the new room in, turn around from the current alpha
			if (!is_fading_out) {
				start(_room)
			}
		}
		return
	}
	var _transition = instance_create_depth(0, 0, -10000, obj_room_transition)
	_transition.start(_room)
}

/**
 * @returns {Bool} whether we're fading out toward another room (see transition_to_room). Check this before
 * changing global state on the way out, since a second transition_to_room call during the fade is ignored
 */
function is_room_transitioning() {
	with (obj_room_transition) {
		if (is_fading_out) {
			return true
		}
	}
	return false
}

/**
 * Triggers a menu item (obj_menu_button, obj_menu_toggle, obj_menu_number_input), however it was chosen -- clicked,
 * typed into an obj_menu_input, or shot by the main menu's turret. Buttons go through activate() so they can react
 * (e.g. strobe when they start a room transition); everything else just runs on_click
 * @param {Id.Instance} _inst
 */
function activate_menu_item(_inst) {
	if (!instance_exists(_inst)) {
		return
	}
	if (_inst.object_index == obj_menu_button) {
		_inst.activate()
	} else {
		_inst.on_click(_inst)
	}
}

/**
 * Sets the game seed from what was typed in the menu's Seed box. All digits is used as the number itself ("1234"
 * is seed 1234); anything else is hashed (FNV-1a, 31-bit) so the same text always plays the same way.
 * Empty picks a new random seed
 * @param {String} _text
 */
function set_game_seed(_text) {
	if (string_length(_text) == 0) {
		randomize_game_seed()
		return
	}
	if (string_digits(_text) == _text) {
		global.game_seed = real(_text)
	} else {
		var _hash = 2166136261
		for (var _i = 1; _i <= string_length(_text); _i++) {
			_hash = _hash ^ ord(string_char_at(_text, _i))
			_hash = (_hash * 16777619) & 0xFFFFFFFF
		}
		global.game_seed = _hash & 0x7FFFFFFF
	}
	global.game_seed_text = _text
}

function randomize_game_seed() {
	global.game_seed = randomize()
	global.game_seed_text = string(global.game_seed)
}

/**
 * Switches between Math mode (enemies show equations) and Typing mode (enemies show words), along with the
 * colors that go with each. Takes effect for things created afterward (e.g. the next play room's background)
 * @param {Bool} _is_math
 */
function set_game_mode(_is_math) {
	global.is_math_mode = _is_math
	global.bg_color = _is_math ? MATH_BACKGROUND_COLOR : TYPING_BACKGROUND_COLOR
	global.world_color = _is_math ? MATH_WORLD_COLOR : TYPING_WORLD_COLOR
	apply_bg_color_to_room()
}

/**
 * Colors the current room's background layer(s) with global.bg_color. The rooms' Background layers are a fixed
 * color in the room editor, so this keeps the backdrop (e.g. around the training court, or behind the main menu's
 * rings while they boot up) in step with the game mode's colors. Called at the start of the menu and play rooms,
 * and again whenever the mode changes
 */
function apply_bg_color_to_room() {
	var _layers = layer_get_all()
	for (var _i = 0; _i < array_length(_layers); _i++) {
		var _bg = layer_background_get_id(_layers[_i])
		// colour-only backgrounds (no sprite) are drawn in their blend color
		if (_bg != -1) {
			layer_background_blend(_bg, global.bg_color)
		}
	}
}
