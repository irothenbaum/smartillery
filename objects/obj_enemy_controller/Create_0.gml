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
	debug("INITTING", _current_wave)
	// we want each wave to progress the same way regardless of play so we reset the random seed deterministically
	random_set_seed(get_game_controller().game_seed + _current_wave);
	enemy_count = _current_wave * 2;
	spawned_count = 0;
	
	// draw the wave text
	instance_create_layer(x, y, LAYER_HUD, obj_text_title, {
		message: "Beginning Wave #" + string(_current_wave),
		align: ALIGN_CENTER,
		y: room_height * 0.25,
		duration: 5,
		on_render: function(_bounds) {			
			var _copy = []
			array_copy(_copy, 0, global.operations_order, 0, array_length(global.operations_order))
			array_resize(_copy, floor(get_current_wave_number() / WAVE_DIFFICULTY_STEP) + 1)
			draw_set_font(fnt_base)
			draw_text_with_alignment(_bounds.x0, _bounds.y1, "Operations: " + array_reduce(_copy, function(_aggr, _o) {
				return _aggr + " " + _o 
			}, ""), ALIGN_LEFT)
			draw_text_with_alignment(_bounds.x1, _bounds.y1, "Max: " + string(math_determine_max_from_wave(get_current_wave_number())), ALIGN_RIGHT)
			
			var _current_wave = get_current_wave_number()
			if (_current_wave % WAVE_DIFFICULTY_STEP == 1) {
				var _new_operation_index = floor(_current_wave / WAVE_DIFFICULTY_STEP)
				var _new_operation = global.operations_order[_new_operation_index]
				draw_set_font(fnt_large)
				draw_text_with_alignment(room_width / 2, _bounds.y1 + 40, "New operation: " + _new_operation, ALIGN_CENTER)
			}
		}
	})
	
	// hide the wave text after some duration
	alarm_set(0, MESSAGE_SHOW_DURATION * game_get_speed(gamespeed_fps));
}

/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	can_spawn = false
	// todo: maybe a log or something?
	// at wave 20 they'll spawn just half a second apart
	alarm[0] = game_get_speed(gamespeed_fps) * (10 / get_current_wave_number())
	
	// out of bounds margin
	var _oob_margin = 100
	
	var _pos_x = irandom(room_width)
	var _pos_y = irandom(room_height)
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	_pos_y = _quad == 1 ? -_oob_margin : (_quad == 3 ? room_height + _oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -_oob_margin : (_quad == 2 ? room_width + _oob_margin : _pos_x);
	
	spawned_count++;

	var _new_enemy =  instance_create_layer(_pos_x, _pos_y, LAYER_INSTANCES, obj_enemy_1);
	return _new_enemy
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
	var _answer_in_use = struct_exists(active_answers, _answer)
	if (get_game_controller().is_ulting() || !_answer_in_use) {
		return get_game_controller().handle_submit_code(_answer);
	}
	
	var _instance = active_answers[$ _answer];
	
	get_player().fire_at_instance(_instance);
	return true;
}
