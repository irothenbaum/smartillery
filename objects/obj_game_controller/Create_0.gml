draw_set_halign(fa_left);

// might be fun to make this configurable
game_seed = game_seed || current_time;
random_set_seed(game_seed);

current_wave = 3;
game_score = 0;
unit_score = 0; // base score
streak_score = 0; // streak bonus

streak = 0;
longest_streak = 0;

is_selecting_ult = false
ultimate_charge = 0;
ultimate_experience = 0
ultimate_level = 1
inst_ultimate = undefined;

is_game_over = false;

is_scene_transitioning = false;

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
	alarm[1] = (global.scene_transition_duration - 2) * game_get_speed(gamespeed_fps)
	
	return _controller
}

function handle_game_over() {
	function explode_enemy(_e, _index) {
		with (_e) {
			instance_destroy();
		}
	}
	
	is_game_over = true;
	
	// destroy all enemies
	for_each_enemy(explode_enemy)
	
	// destroy the enemy controller and user input
	var _input = instance_find(obj_input, 0)
	instance_destroy(_input)
	instance_destroy(get_enemy_controller())
	
	var _game_over_message = instance_create_layer(x, y, LAYER_HUD, obj_game_over)
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
	
	// streak is + 30% of base
	var _streak_score = (!_skip_streak && has_point_streak()) ? floor(_enemy.point_value * 0.3) : 0;
	
	draw_point_indicators(_enemy.x, _enemy.y, _enemy.point_value, _streak_score)
	
	unit_score += _enemy.point_value
	streak_score += _streak_score
	game_score += _enemy.point_value + _streak_score
	
	broadcast(EVENT_ENEMY_KILLED, _enemy)
		
	increase_ult_score()
}


function draw_point_indicators(_x, _y, _base, _streak) {
	var _base_inst = instance_create_layer(_x, _y, LAYER_INSTANCES, obj_text_score_increase, {
		amount: _base,
		font: fnt_large
	})
	_y -= 20
	
	if (_streak) {	
		var _streak_inst = instance_create_layer(_x, _y, LAYER_INSTANCES, obj_text_score_increase, {
			amount: _streak,
			color: global.power_color
		})
	}
}


/// @param {String} _code
/// @returns {Bool}
function handle_submit_code(_code) {
	if (string_length(_code) == 0) {
		return false;
	}

	if (is_ulting()) { 
		return inst_ultimate.handle_submit_code(_code)
	} else if (_code == global.ultimate_code && global.selected_ultimate != ULTIMATE_NONE) {
		activate_ultimate()
		return true
	} else if (get_enemy_controller().handle_submit_answer(_code)) {
		// if this was a correct enemy answer
		return true
	} else {
		// this was simply an inccorect submission, streak goes to 0
		streak = 0
		broadcast(EVENT_WRONG_GUESS, _code)
		return false
	}
}

function activate_ultimate() {
	if (!has_ultimate() || is_scene_transitioning) {
		return
	}
	// TODO: Add Slow power here
	var _ult_obj = global.selected_ultimate == ULTIMATE_STRIKE ? obj_ultimate_strike : obj_heal_power
	inst_ultimate = instance_create_layer(x, y, LAYER_HUD, _ult_obj, {level: ultimate_level})
	ultimate_charge = 0
}


function mark_ultimate_used() {
	if (!is_undefined(inst_ultimate)) {
		instance_destroy(inst_ultimate)
	}
	inst_ultimate = undefined
}

function is_ulting() {
	if (is_undefined(inst_ultimate)) {
		return false
	}
	if (instance_exists(inst_ultimate)) {
		return true
	}
	inst_ultimate = undefined
	return false
}

function get_experience_needed_for_next_level() {
	return min(5 * ultimate_level, 50)
}

function increase_streak() {
	streak++
	longest_streak = max(longest_streak, streak)
}

function increase_ult_score() {
	if (has_point_streak()) {
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
			
				var _next_level_experience = get_experience_needed_for_next_level()
				if (ultimate_experience >= _next_level_experience) {
					ultimate_level++
					ultimate_experience = 0
				}
			}
		}
	}
}

// start off marking wave completed so game can start
mark_wave_completed();