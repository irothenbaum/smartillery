draw_set_halign(fa_left);

random_set_seed(global.game_seed);

tutorial = undefined;
enemy_controller = undefined;

current_wave = 0
game_score = 0
drawn_game_score = 0
unit_score = 0
streak_score = 0
combo_score = 0

// these are player specific values that we track
combo_count = {}
longest_combo = {}
streak = {};
longest_streak = {};
ultimate_charge = {};
ultimate_experience = {}
ultimate_level = {}
cached_ultimate_level = {};
inst_ultimate = {};

is_game_over = false;

is_scene_transitioning = false;

combo_max_alarm = (global.combo_delay_ms / 1000) * game_get_speed(gamespeed_fps)
instance_create_layer(x, y, LAYER_CONTROLLERS, obj_select_ultimate)
instance_create_layer(x, y, LAYER_INSTANCES, obj_combo_drawer)

debug("USING SEED :" + string(global.game_seed))

/**
 * @param {String} _player_id
 * @returns {Bool}
 */
function has_point_streak(_player_id) {
	if (is_undefined(_player_id)) {
		_player_id = get_my_steam_id_safe()
	}
	return streak[$ _player_id] >= global.point_streak_requirement
}

/**
 * @param {String} _player_id
 * @returns {Bool}
 */
function has_ultimate(_player_id) {
	return !is_ulting(_player_id) && ultimate_charge[$ _player_id] >= global.ultimate_requirement
}

/**
 * @param {String} _ultimate_type
 * @returns {Boolean}
 */
function is_ult_active(_ultimate_type) {
	return instance_number(global._G.ultimate_object_map[$ _ultimate_type]) > 0
}

/**
 * @returns {undefined}
 */
function mark_wave_completed() {
	if (!is_undefined(enemy_controller)) {	
		instance_destroy(enemy_controller)
		enemy_controller = undefined
	}
	get_player().my_health = global.max_health
	current_wave++;
	// Even those the enemy controller is a controller, 
	enemy_controller = instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_controller);
	with (enemy_controller) {
		init_wave()
	}
	
	alarm[0] = 1 * game_get_speed(gamespeed_fps)
	alarm[1] = (global.scene_transition_duration * 0.6) * game_get_speed(gamespeed_fps)
	
	return enemy_controller
}

/**
 * @returns {undefined}
 */
function end_game() {
	function explode_enemy(_e, _index) {
		with (_e) {
			instance_destroy();
		}
	}
	
	// this will destroy the ult
	mark_ultimate_used();
	
	is_game_over = true;
	broadcast(EVENT_GAME_OVER, game_score)
	
	// destroy all enemies
	for_each_enemy(explode_enemy)
	
	// destroy the enemy controller and user input
	instance_destroy(instance_find(obj_input, 0))
	instance_destroy(enemy_controller)
	enemy_controller = undefined
	instance_destroy(instance_find(obj_hud, 0))
	
	var _game_over_message = instance_create_layer(x, y, LAYER_HUD, obj_game_over)
}

/**
 * @returns {undefined}
 */
function reset_starting_values() {
	// TODO: we should track each of these score items per player as well (or maybe just the total?)
	combo_score = 0
	unit_score = 0
	streak_score = 0
	game_score = 0
	current_wave = 0
	drawn_game_score = 0
	combo_count = initialize_player_map(0)
	longest_combo = initialize_player_map(0)
	streak = initialize_player_map(0)
	longest_streak = initialize_player_map(0)
	ultimate_charge = initialize_player_map(0)
	ultimate_experience = initialize_player_map(0)
	ultimate_level = initialize_player_map(1)
	cached_ultimate_level = initialize_player_map(undefined)
	inst_ultimate = initialize_player_map(undefined)
	random_set_seed(global.game_seed);
}
reset_starting_values()

/// @func handle_enemy_killed(_enemy)
/// @param {Id.Instance} _enemy
/// @return {undefined}
function handle_enemy_killed(_enemy) {
	// we don't count enemy points when the game is over
	if (is_game_over) {
		return 
	}
	
	var _player_id = _enemy.last_hit_by_player_id
	release_answer(_enemy.answer);
	
	// if the player didn't hit them (they hit the player most likely)
	if (is_undefined(_player_id)) {
		return
	}
	
	increase_streak(_player_id)
	increase_combo(_player_id)
	
	// streak is + 30% of base
	var _streak_score = has_point_streak() ? floor(_enemy.point_value * 0.3) : 0;
	var _combo_score = combo_count[$ _player_id] >= global.minimum_combo ? combo_count[$ _player_id] : 0
	
	draw_point_indicators(_enemy.x, _enemy.y, _enemy.point_value, _streak_score, _combo_score)
	
	unit_score += _enemy.point_value
	streak_score += _streak_score
	combo_score += _combo_score
	game_score += _enemy.point_value + _streak_score + _combo_score
	
	broadcast(EVENT_SCORE_CHANGED, {
		unit_score: unit_score,
		streak_score: streak_score,
		combo_score: combo_score,
		game_score: game_score,
	})
	broadcast(EVENT_ENEMY_KILLED, _enemy)
		
	if (has_point_streak(_player_id)) {
		increase_ult_score(_player_id)
	}
}

/**
 * @returns {undefined}
 */
function draw_point_indicators(_x, _y, _base, _streak, _combo) {
	instance_create_layer(_x, _y, LAYER_INSTANCES, obj_orb_score_increase, {
		amount: _base,
		font: fnt_large
	})
	_y -= 20
	
	if (_streak) {	
		instance_create_layer(_x, _y, LAYER_INSTANCES, obj_orb_score_increase, {
			amount: _streak,
			color: global.p1_color
		})
		_y -= 20
	}
	
	if (_combo) {
		instance_create_layer(_x, _y, LAYER_INSTANCES, obj_orb_score_increase, {
			amount: _combo,
			color: global.combo_color
		})
	}
}


/// @param {String} _code
/// @param {String} _player_id
/// @returns {Bool}
function handle_submit_code(_code, _player_id = undefined) {
	_player_id = is_undefined(_player_id) ? get_my_steam_id_safe() : _player_id
	
	if (string_length(_code) == 0) {
		return false;
	}
	
	if (_handle_test_string(_code)) {
		return true
	}

	if (_code == global.ultimate_code) {
		activate_ultimate(_player_id)
		return true
	} else if (handle_submit_answer(_code, _player_id)) {
		// if this was a correct enemy answer
		return true
	} else {
		// this was simply an inccorect submission, streak goes to 0
		streak[$ _player_id] = 0
		broadcast(EVENT_ON_OFF_STREAK, 0, _player_id)
		return false
	}
}

/**
 * @returns {undefined}
 */
function activate_ultimate(_player_id) {
	if (!has_ultimate(_player_id) || is_scene_transitioning) {
		return
	}
	
	var _ult_obj = global._G.ultimate_object_map[get_player_ultimate(_player_id)]
	inst_ultimate[$ _player_id] = instance_create_layer(x, y, LAYER_HUD, _ult_obj, {level: ultimate_level[$ _player_id], owner_player_id: _player_id})
	cached_ultimate_level[$ _player_id] = ultimate_level[$ _player_id]
}

/**
 * @param {String} _player_id
 */
function mark_ultimate_used(_player_id) {
	if (!is_undefined(inst_ultimate[$ _player_id])) {
		instance_destroy(inst_ultimate[$ _player_id])
	}
	ultimate_charge[$ _player_id] = 0
	inst_ultimate[$ _player_id] = undefined
	cached_ultimate_level[$ _player_id] = undefined
}

/**
 * @param {String} _player_id
 * @returns {Real}
 */
function get_ulting_level(_player_id) {
	return cached_ultimate_level[$ _player_id]
}

/**
 * @param {String?} _player_id
 * @returns {Bool}
 */
function is_ulting(_player_id) {
	// if player id is not provided, check both* players
	if (is_undefined(_player_id)) {
		var _results = for_each_player(is_ulting)
		return array_any(_results, function(_r) {return _r == true}) 
	}
	
	if (is_undefined(inst_ultimate[$ _player_id])) {
		return false
	}
	if (instance_exists(inst_ultimate[$ _player_id])) {
		return true
	}
	
	// this is an edge case, basically means our references are out of sync so we take this moment to update 
	mark_ultimate_used(_player_id)
	return false
}

/**
 * @param {String} _player_id
 */
function increase_streak(_player_id) {
	var _had_sreak = has_point_streak(_player_id)
	streak[$ _player_id]++	
	
	longest_streak[$ _player_id] = max(longest_streak[$ _player_id], streak[$ _player_id])
	
	if (!_had_sreak && has_point_streak(_player_id)) {
		broadcast(EVENT_ON_OFF_STREAK, streak[$ _player_id], _player_id)
	}
}

/**
 * @param {String} _player_id
 */
function increase_combo(_player_id) {
	// can only combo if you're on streak
	if (!has_point_streak(_player_id)) {
		return
	}
	
	combo_count[$ _player_id]++
	// TODO: we need a different alarm per player
	alarm[2] = combo_max_alarm
	longest_combo[$ _player_id] = max(longest_combo[$ _player_id], combo_count[$ _player_id])
}

/**
 * @param {String} _player_id
 */ 
function increase_ult_score(_player_id) {
	if (!is_ulting(_player_id)) {
		// if we're ulting then we don't count kills to our ult bar
		if (ultimate_charge[$ _player_id] < global.ultimate_requirement) {
			ultimate_charge[$ _player_id]++
		} else {
			ultimate_experience[$ _player_id]++
			
			var _next_level_experience = get_experience_needed_for_next_level(ultimate_level[$ _player_id])
			if (ultimate_experience[$ _player_id] >= _next_level_experience) {
				// disabling level up mini game for now
				// ultimate_level_up_controller = instance_create_layer(x, y, LAYER_HUD, global.is_math_mode ? obj_ult_upgrade_math : obj_ult_upgrade_typing)
				increate_ult_level(_player_id)
			}
		}
	}
}

/**
 * @param {String} _player_id
 */ 
function increate_ult_level(_player_id) {
	ultimate_level[$ _player_id]++
	ultimate_experience[$ _player_id] = 0
	broadcast(EVENT_UTLTIMATE_LEVEL_UP, ultimate_level[$ _player_id], _player_id)
}

// --------------------------------------------------------------------
// ANSWER TRACKING

// these values are things that can be solved by the obj_input
// and keyed by the solution. This way we ensure unique solutions exist
active_answers = {};

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
/// @param {String} _player_id
/// @return {Bool}
function handle_submit_answer(_answer, _player_id) {
	if (!is_answer_active(_answer)) {
		return false
	}
	
	var _instance = active_answers[$ _answer];
	get_player().fire_at_instance(_instance, _player_id);
	return true;
}

function is_answer_active(_answer) {
	return struct_exists(active_answers, _answer)
}

// TESTING
function _handle_test_string(_code) {
	if(_code == "_damage") {
		get_player().execute_take_damage(20)
		return true;
	}
	

	if (_code == "_level") {
		increase_ult_score()
		ultimate_level++
		ultimate_charge = global.ultimate_requirement
		return true;
	}
	
	if (_code == "_wave") {
		enemy_controller.spawned_count = enemy_controller.enemy_count
		current_wave++;
		return true
	}
}