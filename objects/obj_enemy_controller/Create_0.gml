// this is set by game controller on instantiation
wave_number = 0;
enemy_count = wave_number * 2;
spawned_count = 0;

// these values are things that can be solved by the obj_input
// and keyed by the solution. This way we ensure unique solutions exist
active_answers = {};


var _oob_margin = 100
/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	var _pos_x = irandom(room_width)
	var _pos_y = irandom(room_height)
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	_pos_y = _quad == 1 ? -_oob_margin : _quad == 3 ? room_height + _oob_margin : _pos_y;
	_pos_x = _quad == 0 ? -_oob_margin : _quad == 2 ? room_width + _oob_margin : _pos_x;
	
	spawned_count++;
	
	return instance_create_layer(_pos_x, _pos_y, "Instances", obj_enemy_1);
}

/// @func reserve_solution(_sol, _inst)
/// @param {String} _sol
/// @param {Id.Instance} _inst
/// @return {undefined}
function reserve_solution(_sol, _inst) {
	if (struct_exists(active_answers, _sol)) {
		throw "Answer in use";
	}
	active_answers[_sol] = _inst;
}


/// @func reserve_solution(_sol, _inst)
/// @param {String} _sol
/// @return {undefined}
function release_solution(_sol) {
	delete active_answers[_sol];
}