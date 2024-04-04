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

/// @func calculate_time_bonus(_lifetime) 
/// @param {Real} _lifetime // in seconds
/// @return {Real}
function calculate_time_bonus(_lifetime) {
	return TIME_BONUS_PERIOD - (_lifetime / TIME_BONUS_PERIOD);
}

/// @func count_all_enemies()
/// @return {Real}
function count_all_enemies() {
	return 0 + instance_number(obj_enemy_1)
}

function for_each_enemy() {
	var _i = 0
	var _enemy1 = instance_number(obj_enemy_1)
	for (; _i < _enemy1; _i++) {
		script_execute(argument[0], instance_find(obj_enemy_1, _i), _i)
	}
	
	// at this point _i = how many enemy type 1s there are,
	// without resetting we continue to enemy2 so that the overall index is persisted
	var _enemy2 = instance_number(obj_enemy_2)
	for (; _i < _enemy2; _i++) {
		script_execute(argument[0], instance_find(obj_enemy_2, _i - _enemy1), _i)
	}
}