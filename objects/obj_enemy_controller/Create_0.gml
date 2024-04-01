wave_number = 0;
enemy_count = 0;
spawned_count = 0;
// these values are things that can be solved by the obj_input
// and keyed by the solution. This way we ensure unique solutions exist
active_answers = {};

/// @func init()
/// @param {Real} _wave
/// @returns {undefined}
function init_wave(_wave) {
	debug("wave init ");
	wave_number = _wave
	enemy_count = _wave * 2;
	debug(_wave, wave_number, enemy_count);
	spawned_count = 0;
}

/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	// out of bounds margin
	var _oob_margin = 100
	
	debug("Spawning enemy");
	var _pos_x = irandom(room_width)
	var _pos_y = irandom(room_height)
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	_pos_y = _quad == 1 ? -_oob_margin : (_quad == 3 ? room_height + _oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -_oob_margin : (_quad == 2 ? room_width + _oob_margin : _pos_x);
	
	spawned_count++;
	
	return instance_create_layer(_pos_x, _pos_y, "Instances", obj_enemy_1);
}

/// @func reserve_answer(_ans, _inst)
/// @param {String} _ans
/// @param {Id.Instance} _inst
/// @return {undefined}
function reserve_answer(_ans, _inst) {
	if (struct_exists(active_answers, _ans)) {
		throw "Answer in use";
	}
	active_answers[$ _ans] = _inst;
}


/// @func release_answer(_ans)
/// @param {String} _ans
/// @return {undefined}
function release_answer(_ans) {
	delete active_answers[$ _ans];
}

/// @func handle_submit_answer(_answer)
/// @param {String} _answer
/// @return {Bool}
function handle_submit_answer(_answer) {
	if (!struct_exists(active_answers, _answer)) {
		return false;
	}
	
	var _instance = active_answers[$ _answer];
	
	get_player().fire_at_instance(_instance);
	release_answer(_answer);
	return true;
}


/// @func handle_enemy_killed(_enemy)
/// @param {Id.Instance} _enemy
/// @return {undefined}
function handle_enemy_killed(_enemy) {
	var _time_bonus = calculate_time_bonus(current_time - _enemy.spawn_time)
	global.score += _enemy.point_value + _time_bonus
}