can_spawn = false;
enemy_count = 0;
spawned_count = 0;
spawn_delay_seconds = 0;
current_wave = get_current_wave_number();
game_controller = get_game_controller();

min_spawn_delay_seconds = 0.5;
max_spawn_delay_seconds = 10;
round_duration_seconds = 60;


/// @func init()
/// @returns {undefined}
function init_wave() {
	can_spawn = false;
	enemy_count = ceil(current_wave * 1.5);
	spawned_count = 0;
	spawn_delay_seconds = max(min_spawn_delay_seconds, min(max_spawn_delay_seconds, 30 / enemy_count))
	
	instance_create_layer(x, y, LAYER_INSTANCES, obj_next_wave_text)
	
	alarm[0] = global.scene_transition_duration * 2 * game_get_speed(gamespeed_fps);
}

_enemy_order = [
	obj_enemy_1,
	obj_enemy_2,
	obj_compound_enemy_1,
	obj_enemy_3,
	obj_compound_enemy_2,
	obj_enemy_4,
	// obj_enemy_5, not working right
]

function _get_enemy_variables(_enemy_type) { 
	var _ret_val = {}
	switch(_enemy_type) {
		case obj_compound_enemy_1:
			_ret_val.enemy_count = max(3, current_wave / global.wave_difficulty_step)
			_ret_val.waypoint_count = floor(_ret_val.enemy_count / 2)
			break
		
		case obj_compound_enemy_2:
			_ret_val.enemy_count = max(2, current_wave / global.wave_difficulty_step)
			break
	}
	
	return _ret_val
}

/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	// we want each wave to progress the same way regardless of play so we reset the random seed deterministically each time
	random_set_seed(global.game_seed + current_wave * 10000 + spawned_count);
	can_spawn = false
	
	// out of bounds margin
	var _oob_margin = 30
	
	var _rotation = irandom(360)
	var _pos_x = global.xcenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	var _pos_y = global.ycenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	
	// the no spawn zone is the middle 33%, so if pos_x is in that range, we shift it
	var _no_spawn_marker = global.room_width * 0.33
	if (_pos_x > _no_spawn_marker && _pos_x < _no_spawn_marker * 2) {
		var _distance_to_center = _pos_x - global.xcenter
		// if _distance_to_center is negative, then pos_x is to the right of center, in the middle 33%.
		// this basically shifts our x position back into either the first or 3rd swction respctive to its position in the second
		_pos_x = _distance_to_center < 0 ? 2 * (_no_spawn_marker + abs(_distance_to_center)) : _no_spawn_marker - (_distance_to_center * 2)
	}
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	
	_pos_y = _quad == 1 ? -_oob_margin : (_quad == 3 ? global.room_height + _oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -_oob_margin : (_quad == 2 ? global.room_width + _oob_margin : _pos_x);
	
	var _max_enemy = floor(current_wave / global.wave_difficulty_step)
	
	var _next_enemy_type = undefined
	var _next_enemy_params = undefined
	do {
		if (_max_enemy == 0 || flip_coin(max(2, (_max_enemy) * 10 - current_wave))) {
			_next_enemy_type = _enemy_order[_max_enemy]
		} else {
			_max_enemy--
		}
	} until (!is_undefined(_next_enemy_type))
	
	
	// JUST FOR TESTING:
	// _next_enemy_type = obj_enemy_5
	// -----
	_next_enemy_params = _get_enemy_variables(_next_enemy_type)
		
	var _new_enemy =  instance_create_layer(
		_pos_x,
		_pos_y, 
		LAYER_INSTANCES, 
		_next_enemy_type, 
		_next_enemy_params
	);
	alarm[0] = game_get_speed(gamespeed_fps) * spawn_delay_seconds
	
	spawned_count++;
	
	return _new_enemy
}