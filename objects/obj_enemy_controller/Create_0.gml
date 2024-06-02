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
		duration: global.scene_transition_duration,
		on_render: function(_bounds) {			
			var _copy = []
			array_copy(_copy, 0, global.operations_order, 0, array_length(global.operations_order))
			array_resize(_copy, floor(get_current_wave_number() / WAVE_DIFFICULTY_STEP) + 1)
			draw_set_font(fnt_base)
			draw_text_with_alignment(_bounds.x0, _bounds.y1 + 10, "Operations: " + array_reduce(_copy, function(_aggr, _o) {
				return _aggr + " " + _o 
			}, ""), ALIGN_LEFT)
			draw_text_with_alignment(_bounds.x1, _bounds.y1 + 10, "Max: " + string(math_determine_max_from_wave(get_current_wave_number())), ALIGN_RIGHT)
			
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
	
	// enemy 2 types only start appearing after wave 3 and only ~once every 6 enemies
	var _spawn_enemy_2 = (get_current_wave_number() > 3 && irandom(5) == 0)
	var _new_enemy =  instance_create_layer(_pos_x, _pos_y, LAYER_INSTANCES, _spawn_enemy_2 ? obj_enemy_2 : obj_enemy_1);
	
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