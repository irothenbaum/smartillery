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
	for (var _i = 0; _i < _enemy1; _i++) {
		array_push(_instances, instance_find(obj_enemy_1, _i))
	}
	for (var _i = 0; _i < _enemy2; _i++) {
		array_push(_instances, instance_find(obj_enemy_2, _i))
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

function toggle_pause(_status) {
	var _layer = layer_get_id(LAYER_INSTANCES);
	var _instances = layer_get_all_elements(_layer);
	var _instance_count = array_length(_instances)
	
	debug("Turning pause " + (_status ? "ON" : "OFF") + " for " + string(_instance_count) + " instances")
	var _alarm_length = 12
	
	for (var _i = 0; _i < _instance_count; _i++) {
		var _inst = layer_instance_get_instance(_instances[_i])
		debug(_instances[_i], _inst)
		
		with (_inst) {
			debug("Status: ", _status)
			if (_status) {
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
					
						debug("Turning off alarm " + string(_j))
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
					debug("INSTANCE NOT PAUSED", self)
					continue
				}
				debug("unpausing instance", self)
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

function math_determine_max_from_wave(_wave) {
	return BASE_ANSWER_VALUE + (5 * floor(_wave / 2))
}