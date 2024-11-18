can_spawn = false;
enemy_count = 0;
spawned_count = 0;
current_wave = get_current_wave_number()


/// @func init()
/// @returns {undefined}
function init_wave() {
	can_spawn = false;
	enemy_count = ceil(current_wave * 1.5);
	spawned_count = 0;
	
	instance_create_layer(x, y, LAYER_INSTANCES, obj_next_wave_text)
	alarm[0] = global.scene_transition_duration * 2 * game_get_speed(gamespeed_fps);
}

/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	// we want each wave to progress the same way regardless of play so we reset the random seed deterministically each time
	random_set_seed(global.game_seed + current_wave + spawned_count);
	can_spawn = false
	
	// out of bounds margin
	var _oob_margin = 100
	
	var _rotation = irandom(360)
	var _pos_x = global.xcenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	var _pos_y = global.ycenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	
	// the no spawn zone is the middle 33%, so if pos_x is in that range, we shift it
	var _no_spawn_marker = room_width * 0.33
	if (_pos_x > _no_spawn_marker && _pos_x < _no_spawn_marker * 2) {
		var _distance_to_center = _pos_x - global.xcenter
		// if _distance_to_center is negative, then pos_x is to the right of center, in the middle 33%.
		// this basically shifts our x position back into either the first or 3rd swction respctive to its position in the second
		_pos_x = _distance_to_center < 0 ? 2 * (_no_spawn_marker + abs(_distance_to_center)) : _no_spawn_marker - (_distance_to_center * 2)
	}
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	_pos_y = _quad == 1 ? -_oob_margin : (_quad == 3 ? room_height + _oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -_oob_margin : (_quad == 2 ? room_width + _oob_margin : _pos_x);
	
	
	var _max_enemy = 1 + floor(current_wave / global.wave_difficulty_step)
	
	var _spawn_value
	var _next_enemy_type
	if (_max_enemy >= 4 && irandom(20) == 1) {
		_next_enemy_type = obj_enemy_4
		_spawn_value = 3
	} else if (_max_enemy >= 3 && irandom(14) == 1) {
		_next_enemy_type = obj_enemy_3
		_spawn_value = 2
	} else if (_max_enemy >= 2 && irandom(8) == 1) {
		_next_enemy_type = obj_enemy_2
		_spawn_value = 1
	} else {
		_next_enemy_type = obj_enemy_1
		_spawn_value = 1
	}
	
	var _new_enemy =  instance_create_layer(_pos_x, _pos_y, LAYER_INSTANCES, _next_enemy_type);
	// at round 20 they'll spawn half a second apart
	alarm[0] = game_get_speed(gamespeed_fps) * _spawn_value * (global.wave_difficulty_step / _max_enemy)
	
	spawned_count++;
	
	return _new_enemy
}