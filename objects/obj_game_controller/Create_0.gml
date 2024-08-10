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

ultimate_charge = global.ultimate_requirement;
inst_ultimate = undefined;
ultimate_hint = ""
ultimate_code = ""

// half way to heal
heal_charge = global.heal_requirement // / 2;
inst_heal = undefined;
heal_hint = ""
heal_code = ""

is_game_over = false;

is_scene_transitioning = false;

/// @returns {Bool}
function has_point_streak() {
	return streak >= global.point_streak_requirement
}

/// @returns {Bool}
function has_ultimate() {
	return !self.is_ulting() && ultimate_charge >= global.ultimate_requirement
}

/// @returns {Bool}
function has_heal() {
	return !self.is_healing() && heal_charge >= global.heal_requirement
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
	
	// we shuffle for new Heal and Strike codes
	var _values = global.is_math_mode ? generate_equation_and_answer(current_wave) : generate_text_and_answer(current_wave)
	ultimate_code = _values.answer
	ultimate_hint = _values.equation
	// reserve the answer so no enemy can use it
	_controller.reserve_answer(_values.answer, self)
	
	_values = global.is_math_mode ? generate_equation_and_answer(current_wave) : generate_text_and_answer(current_wave)
	heal_code = _values.answer
	heal_hint = _values.equation
	// reserve the answer so no enemy can use it
	_controller.reserve_answer(_values.answer, self)
	
	return _controller
}

function handle_game_over() {
	function explode_enemy(_e, _index) {
		with (_e) {
			explode_and_destroy();
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
/// @return {undefined}
function handle_enemy_killed(_enemy) {
	// we don'tcount enemy points when the game is over
	if (is_game_over) {
		return 
	}
	
	// streak is + 30% of base
	var _streak_score = has_point_streak() ? floor(_enemy.point_value * 0.3) : 0;
	
	draw_point_indicators(_enemy.x, _enemy.y, _enemy.point_value, _streak_score)
	
	unit_score += _enemy.point_value
	streak_score += _streak_score
	game_score += _enemy.point_value + _streak_score
	
	streak++
	ultimate_charge++
	heal_charge++
	
	longest_streak = max(longest_streak, streak)
}


function draw_point_indicators(_x, _y, _base, _streak) {
	var _base_inst = instance_create_layer(_x, _y, LAYER_HUD, obj_text_score_increase)
	_base_inst.set_amount(_base, c_white, fnt_large)
	_y -= 20
	
	if (_streak) {	
		var _streak_inst = instance_create_layer(_x, _y, LAYER_HUD, obj_text_score_increase)
		_streak_inst.set_amount(_streak, global.power_color)
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
	} else if (_code == ultimate_code) {
		activate_ultimate()
		return true
	} else if (_code == heal_code) {
		activate_heal()
		return true
	} else if (get_enemy_controller().handle_submit_answer(_code)) {
		// do nothing, this was an enemy answer
		return true
	} else {
		// this was simply an inccorect submission, streak goes to 0
		streak = 0
		// we also stop healing if they were
		mark_heal_used()
		return false
	}
}

function activate_ultimate() {
	if (!has_ultimate() || is_scene_transitioning) {
		return
	}
	inst_ultimate = instance_create_layer(x, y, LAYER_HUD, obj_ultimate_interface)
	ultimate_charge = 0
	toggle_pause(true)
}

function activate_heal() {
	if (!has_heal() || is_scene_transitioning) {
		return
	}
	inst_heal = instance_create_layer(x, y, LAYER_HUD, obj_heal_power)
	heal_charge = 0
}

function mark_ultimate_used() {
	inst_ultimate = undefined
	toggle_pause(false)
}

function mark_heal_used() {
	inst_heal = undefined
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

function is_healing() {
	if (is_undefined(inst_heal)) {
		return false
	}
	if (instance_exists(inst_heal)) {
		return true
	}
	inst_heal = undefined
	return false
}

function get_ultimate_text() {
	return ultimate_hint
}

function get_heal_text() {
	return heal_hint
}

// start off marking wave completed so game can start
mark_wave_completed();