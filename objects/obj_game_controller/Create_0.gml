draw_set_halign(fa_left);

random_set_seed(global.game_seed);

tutorial = undefined;

current_wave = 0
game_score = 0
drawn_game_score = 0
unit_score = 0
streak_score = 0
combo_score = 0

combo_count = 0
longest_combo = 0

streak = 0;
longest_streak = 0;

is_selecting_ult = false
ultimate_charge = 0;
ultimate_experience = 0
ultimate_level = 1
ult_overlay = 0
cached_ultimate_level = undefined;
inst_ultimate = undefined;

is_game_over = false;

is_scene_transitioning = false;

combo_max_alarm = (global.combo_delay_ms / 1000) * game_get_speed(gamespeed_fps)
instance_create_layer(x, y, LAYER_INSTANCES, obj_combo_drawer)

debug("USING SEED :" + string(global.game_seed))

/// @returns {Bool}
function has_point_streak() {
	return streak >= global.point_streak_requirement
}

/// @returns {Bool}
function has_ultimate() {
	return !is_ulting() && ultimate_charge >= global.ultimate_requirement
}

function mark_wave_completed() {
	if (get_enemy_controller()) {	
		instance_destroy(get_enemy_controller())
	}
	get_player().my_health = global.max_health
	current_wave++;
	// Even those the enemy controller is a controller, 
	var _controller = instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_controller);
	with (_controller) {
		init_wave()
	}
	
	alarm[0] = 1 * game_get_speed(gamespeed_fps)
	alarm[1] = (global.scene_transition_duration * 0.6) * game_get_speed(gamespeed_fps)
	
	return _controller
}

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
	instance_destroy(get_enemy_controller())
	instance_destroy(instance_find(obj_hud, 0))
	
	var _game_over_message = instance_create_layer(x, y, LAYER_HUD, obj_game_over)
}

function reset_starting_values() {
	global.selected_ultimate = ULTIMATE_NONE
	combo_score = 0
	unit_score = 0
	streak_score = 0
	game_score = 0
	drawn_game_score = 0
	ultimate_charge = 0
	ultimate_experience = 0
	ultimate_level = 1
	cached_ultimate_level = undefined
	current_wave = 0
	random_set_seed(global.game_seed);
}

/// @func handle_enemy_killed(_enemy)
/// @param {Id.Instance} _enemy
/// @param {Bool} _skip_streak
/// @return {undefined}
function handle_enemy_killed(_enemy, _skip_streak = false) {
	// we don'tcount enemy points when the game is over
	if (is_game_over) {
		return 
	}
	
	increase_streak()
	
	increase_combo()
	
	// streak is + 30% of base
	var _streak_score = (!_skip_streak && has_point_streak()) ? floor(_enemy.point_value * 0.3) : 0;
	var _combo_score = combo_count >= global.minimum_combo ? combo_count : 0
	
	draw_point_indicators(_enemy.x, _enemy.y, _enemy.point_value, _streak_score, _combo_score)
	
	unit_score += _enemy.point_value
	streak_score += _streak_score
	combo_score += _combo_score
	game_score += _enemy.point_value + _streak_score + _combo_score
	
	broadcast(EVENT_ENEMY_KILLED, _enemy)
		
	if (has_point_streak()) {
		increase_ult_score()
	}
}


function draw_point_indicators(_x, _y, _base, _streak, _combo) {
	instance_create_layer(_x, _y, LAYER_INSTANCES, obj_orb_score_increase, {
		amount: _base,
		font: fnt_large
	})
	_y -= 20
	
	if (_streak) {	
		instance_create_layer(_x, _y, LAYER_INSTANCES, obj_orb_score_increase, {
			amount: _streak,
			color: global.power_color
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
/// @returns {Bool}
function handle_submit_code(_code) {
	if (string_length(_code) == 0) {
		return false;
	}
	
	if (_handle_test_string(_code)) {
		return true
	}

	if (_code == global.ultimate_code && global.selected_ultimate != ULTIMATE_NONE) {
		activate_ultimate()
		return true
	} else if (handle_submit_answer(_code)) {
		// if this was a correct enemy answer
		return true
	} else {
		// this was simply an inccorect submission, streak goes to 0
		streak = 0
		broadcast(EVENT_ON_OFF_STREAK, false)
		broadcast(EVENT_WRONG_GUESS, _code)
		return false
	}
}

function activate_ultimate() {
	if (!has_ultimate() || is_scene_transitioning) {
		return
	}
	
	ult_overlay = 1
	var _ult_obj = global.selected_ultimate == ULTIMATE_STRIKE ? obj_ultimate_strike : (global.selected_ultimate == ULTIMATE_HEAL ? obj_heal_power : obj_slow_time)
	inst_ultimate = instance_create_layer(x, y, LAYER_HUD, _ult_obj, {level: ultimate_level})
	cached_ultimate_level = ultimate_level
}


function mark_ultimate_used() {
	if (!is_undefined(inst_ultimate)) {
		instance_destroy(inst_ultimate)
	}
	ultimate_charge = 0
	inst_ultimate = undefined
	cached_ultimate_level = undefined
}

function get_ulting_level() {
	return cached_ultimate_level
}

function is_ulting() {
	if (is_undefined(inst_ultimate)) {
		return false
	}
	if (instance_exists(inst_ultimate)) {
		return true
	}
	mark_ultimate_used()
	return false
}

function increase_streak() {
	_had_sreak = self.has_point_streak()
	streak++	
	
	longest_streak = max(longest_streak, streak)
	
	if (!_had_sreak && self.has_point_streak()) {
		broadcast(EVENT_ON_OFF_STREAK, true)
	}
}

function increase_combo() {
	// can only combo if you're on streak
	if (!has_point_streak()) {
		return
	}
	
	combo_count++
	alarm[2] = combo_max_alarm
	longest_combo = max(longest_combo, combo_count)
}

function increase_ult_score() {
	// once we get on streak for the first time, we need to select an ultimate type
	if (global.selected_ultimate == ULTIMATE_NONE) {
		is_selecting_ult = true
		instance_create_layer(x,y, LAYER_HUD, obj_select_ultimate)
	} else if (!is_ulting()) {
		// if we're ulting then we don't count kills to our ult bar
		if (ultimate_charge < global.ultimate_requirement) {
			ultimate_charge++
		} else {
			ultimate_experience++
			
			var _next_level_experience = get_experience_needed_for_next_level(ultimate_level)
			if (ultimate_experience >= _next_level_experience) {
				ultimate_level_up_controller = instance_create_layer(x, y, LAYER_HUD, global.is_math_mode ? obj_ult_upgrade_math : obj_ult_upgrade_typing)
			}
		}
	}
	
}

function increate_ult_level() {
	ultimate_level_up_controller = undefined
	ultimate_level++
	ultimate_experience = 0
	broadcast(EVENT_UTLTIMATE_LEVEL_UP, ultimate_level)
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
/// @return {Bool}
function handle_submit_answer(_answer) {
	if (!is_answer_active(_answer)) {
		return false
	}
	
	var _instance = active_answers[$ _answer];
	get_player().fire_at_instance(_instance);
	return true;
}

function is_answer_active(_answer) {
	return struct_exists(active_answers, _answer)
}

// start off marking wave completed so game can start
mark_wave_completed();



// TESTING
function _handle_test_string(_code) {
	if(_code == "_damage") {
		get_player().execute_take_damage(20)
		return true;
	}
	
	if (_code == "_test") {
		var _next_level_experience = get_experience_needed_for_next_level(ultimate_level)
		ultimate_experience = _next_level_experience	
		ultimate_level_up_controller = instance_create_layer(x, y, LAYER_HUD, global.is_math_mode ? obj_ult_upgrade_math : obj_ult_upgrade_typing)
		return true
	}

	if (_code == "_level") {
		increase_ult_score()
		ultimate_level++
		ultimate_charge = global.ultimate_requirement
		return true;
	}
	
	if (_code == "_wave") {
		get_enemy_controller().spawned_count = get_enemy_controller().enemy_count
		current_wave++;
		return true
	}
}