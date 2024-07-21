draw_set_halign(fa_left);

// might be fun to make this configurable
game_seed = 132435345;
random_set_seed(game_seed);

current_wave = 0;
game_score = 0;
unit_score = 0; // base score
streak_score = 0; // streak bonus

streak = 0;
ultimate_charge = 0;
inst_ultimate = undefined;
inst_launch_time = undefined;
is_game_over = false;
is_scene_transitioning = false;

/// @returns {Bool}
function has_point_streak() {
	return streak >= global.point_streak_requirement
}

/// @returns {Bool}
function has_ultimate() {
	return ultimate_charge >= global.ultimate_requirement
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
	
	streak++
	ultimate_charge++
	
	// streak is + 30% of base
	var _streak_score = has_point_streak() ? floor(_enemy.point_value * 0.3) : 0;
	
	draw_point_indicators(_enemy.x, _enemy.y, _enemy.point_value, _streak_score)
	
	unit_score += _enemy.point_value
	streak_score += _streak_score
	game_score += _enemy.point_value + _streak_score
}


function draw_point_indicators(_x, _y, _base, _streak) {
	var _base_inst = instance_create_layer(_x, _y, LAYER_HUD, obj_text_score_increase)
	_base_inst.set_amount(_base, c_white, fnt_large)
	_y -= 20
	
	if (_streak) {	
		var _streak_inst = instance_create_layer(_x, _y, LAYER_HUD, obj_text_score_increase)
		_streak_inst.set_amount(_streak, c_orange)
	}
}


/// @param {String} _code
/// @returns {Bool}
function handle_submit_code(_code) {
	if (is_ulting()) { 
		return inst_ultimate.handle_submit_code(_code)
	} else if (_code == global.launch_code) {
		activate_ultimate()
		return true
	} else {
		// this was simply an inccorect submission, streak goes to 0
		streak = 0
		return false
	}
}

function activate_ultimate() {
	if (!has_ultimate() || is_scene_transitioning) {
		return
	}
	inst_ultimate = instance_create_layer(x, y, LAYER_HUD, obj_ultimate_interface)
	inst_launch_time = get_play_time()
	ultimate_charge = 0
	toggle_pause(true)
}

function mark_ultimate_used() {
	inst_ultimate = undefined
	inst_launch_time = undefined
	toggle_pause(false)
}

function is_ulting() {
	return !is_undefined(inst_ultimate)
}

// start off marking wave completed so game can start
mark_wave_completed();