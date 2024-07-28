can_spawn = false;
enemy_count = 0;
spawned_count = 0;
// these values are things that can be solved by the obj_input
// and keyed by the solution. This way we ensure unique solutions exist
active_answers = {};

/// @func init()
/// @returns {undefined}
function init_wave() {
	can_spawn = false;
	var _current_wave = get_current_wave_number()
	// we want each wave to progress the same way regardless of play so we reset the random seed deterministically
	random_set_seed(get_game_controller().game_seed + _current_wave);
	enemy_count = ceil(_current_wave * 1.5);
	spawned_count = 0;
	
	instance_create_layer(x, y, LAYER_HUD, obj_next_wave_text)
	alarm[0] = global.scene_transition_duration * 0.75 * game_get_speed(gamespeed_fps);
}

/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	can_spawn = false
	
	// out of bounds margin
	var _oob_margin = 100
	
	var _pos_x = irandom(room_width)
	var _pos_y = irandom(room_height)
	
	// the no spawn zone is the middle 33%, so if pos_x is in that range, we shift it
	var _no_spawn_marker = room_width * 0.33
	if (_pos_x > _no_spawn_marker && _pos_x < _no_spawn_marker * 2) {
		var _distance_to_center = _pos_x - (room_width / 2)
		// if _distance_to_center is negative, then pos_x is to the right of center, in the middle 33%.
		// this basically shifts our x position back into either the first or 3rd swction respctive to its position in the second
		_pos_x = _distance_to_center < 0 ? 2 * (_no_spawn_marker + abs(_distance_to_center)) : _no_spawn_marker - (_distance_to_center * 2)
	}
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	_pos_y = _quad == 1 ? -_oob_margin : (_quad == 3 ? room_height + _oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -_oob_margin : (_quad == 2 ? room_width + _oob_margin : _pos_x);
	
	
	var _max_enemy = 1 + floor(get_current_wave_number() / global.wave_difficulty_step)
	
	var _spawn_value
	var _next_enemy_type
	if (_max_enemy >= 4 && irandom(10) == 1) {
		_next_enemy_type = obj_enemy_4
		_spawn_value = 3
	} else if (_max_enemy >= 3 && irandom(8) == 1) {
		_next_enemy_type = obj_enemy_3
		_spawn_value = 2
	} else if (_max_enemy >= 2 && irandom(6) == 1) {
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

/// @func reserve_answer(_ans, _inst)
/// @param {String} _ans
/// @param {Id.Instance} _inst
/// @return {undefined}
function reserve_answer(_ans, _inst) {
	if (is_answer_active(_ans)) {
		throw "Answer in use";
	}
	active_answers[$ _ans] = _inst;
}

/// @func release_answer(_ans)
/// @param {String} _ans
/// @return {undefined}
function release_answer(_ans) {
	struct_remove(active_answers, _ans)
}

/// @func handle_submit_answer(_answer)
/// @param {String} _answer
/// @return {Bool}
function handle_submit_answer(_answer) {
	if (get_game_controller().is_ulting() || !is_answer_active(_answer)) {
		return get_game_controller().handle_submit_code(_answer);
	}
	
	var _instance = active_answers[$ _answer];
	
	get_player().fire_at_instance(_instance);
	return true;
}

function is_answer_active(_answer) {
	return struct_exists(active_answers, _answer)
}