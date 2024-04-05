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