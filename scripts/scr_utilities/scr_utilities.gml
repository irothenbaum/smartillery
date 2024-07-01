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

function get_game_controller(){
	var _game_controller = instance_find(obj_game_controller, 0)
	return _game_controller 
}

function get_enemy_controller() {
	var _enemy_controller = instance_find(obj_enemy_controller, 0)
	return _enemy_controller
}

function get_player() {
	var _player = instance_find(obj_player, 0)
	return _player
}

function get_input() {
	var _input = instance_find(obj_input, 0)
	return _input
}

/// returns {Real}
function get_current_wave_number() {
	return get_game_controller().current_wave
}

/// @func calculate_time_bonus(_lifetime) 
/// @param {Real} _lifetime // in seconds
/// @return {Real}
function calculate_time_bonus(_lifetime) {
	return 1 - (_lifetime / TIME_BONUS_PERIOD);
}

/// @func count_all_enemies()
/// @return {Array<Id.Instance>}
function get_all_enemy_instances() {
	var _instances = []
	var _enemy1 = instance_number(obj_enemy_1)
	var _enemy2 = instance_number(obj_enemy_2)
	var _enemy3 = instance_number(obj_enemy_3)
	var _enemy4 = instance_number(obj_enemy_4)
	for (var _i = 0; _i < _enemy1; _i++) {
		array_push(_instances, instance_find(obj_enemy_1, _i))
	}
	for (var _i = 0; _i < _enemy2; _i++) {
		array_push(_instances, instance_find(obj_enemy_2, _i))
	}
	for (var _i = 0; _i < _enemy3; _i++) {
		array_push(_instances, instance_find(obj_enemy_3, _i))
	}
	for (var _i = 0; _i < _enemy4; _i++) {
		array_push(_instances, instance_find(obj_enemy_4, _i))
	}
	
	return _instances
}

/// @func count_all_enemies()
/// @return {Real}
function count_all_enemies() {
	return 0 
	+ instance_number(obj_enemy_1) 
	+ instance_number(obj_enemy_2)
}

/// takes a function that receives 2 params: enemy instance, index
function for_each_enemy() {
	var _instances = get_all_enemy_instances()
	var _count = array_length(_instances)
	
	for (var _i =0; _i < _count; _i++) {
		script_execute(argument[0], _instances[_i], _i)
	}
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
	
	var _layer = layer_get_id(LAYER_INSTANCES);
	var _instances = layer_get_all_elements(_layer);
	var _instance_count = array_length(_instances)	
	
	debug("Turning pause " + (global.paused ? "ON" : "OFF") + " for " + string(_instance_count) + " instances")
	var _alarm_length = 12
	
	for (var _i = 0; _i < _instance_count; _i++) {
		var _inst = layer_instance_get_instance(_instances[_i])
		debug(_instances[_i], _inst)
		
		with (_inst) {
			debug("Status: ", global.paused)
			if (global.paused) {
				// memoize our pre-pause values
				paused_speed = speed
				paused_image_speed = image_speed
				paused_alarms = []
				
				// disable movement and animation
				speed = 0
				image_speed = 0
				
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
			} else {
				// if paused alarms was not set, then this object was not around when we first paused
				// probably was an ultimate or something
				if (!variable_instance_exists(self, "paused_alarms")) {
					continue
				}
				// restore pre-pause values
				speed = paused_speed
				image_speed = paused_image_speed
				
				for (var _j = 0; _j < _alarm_length; _j++) {
					if (paused_alarms[_j] > 0) {
						alarm[_j] = paused_alarms[_j]
					}
				}
				
				// remove all out paused states
				paused_speed = undefined
				paused_image_speed  = undefined
				paused_alarms = undefined
			}
		}
	}

}

/// @return {Real}
function get_play_time() {
	return current_time - global.total_paused_time
}

function math_determine_max_from_wave(_wave) {
	// 20 is basically the min if it will ever be
	return 20 + (5 * floor(_wave / 2))
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
	var hex = [];
	var ret = [];
	var quotient = argument0;

	// Convert to hex
	for( var i = 0; quotient != 0; ++i){
		hex[i] = quotient % 16;
		quotient = floor( quotient / 16);
	}

	// Make sure this is a color code
	while(array_length(hex) < 6){
		hex[array_length(hex)] = 0;
	}
	if(array_length(hex) > 6){
		show_error( "Unknown color: " + string( argument0), true);
		return -1;
	}

	// Convert hex to RGB
	for( var i = 0; i < 3; ++i){
		ret[i] = hex[i * 2 + 1] * 16 + hex[i * 2];
		ret[i] /= 255; // Change from 255 to float
	}

	return ret;
}