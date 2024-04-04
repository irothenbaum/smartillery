/* 
	// this code is an example Create script for an enemy class object
	
	// all enemies must implement these private variables:
	spawn_time = current_time
	equation = "";
	speed = 0;
	time_to_solve = 20
	remaining_time_to_solve = time_to_solve
	approach_speed = 1
	needed_rest = 0
	point_value = 10


	// they must also implement this function
	function register_hit(_answer) {
		// TODO: show explosion, particles, etc
		instance_destroy();
	
		get_enemy_controller().handle_enemy_killed(self)
	}

	// and they should call initlaize on themselves
	enemy_initialize(self);
*/


function enemy_start_approach(_e) {
	_e.speed = _e.approach_speed
	
	// if the rest we need is less than 1 second remaining, we just skip it
	if (_e.needed_rest >= 1) {
		// must walk at least 3 seconds, up to the time to solve (minus 3)
		var _next_approach_amount = irandom_range(2, (_e.remaining_time_to_solve - _e.needed_rest) - 2)
		_e.alarms[0] = game_get_speed(gamespeed_fps) * _next_approach_amount
	}
	// else, we keep approaching until we reach it
}

function enemy_stop_approach(_e) {
	_e.speed = 0;
	var _alive_time = current_time - _e.spawn_time

	_e.remaining_time_to_solve = _e.time_to_solve - _alive_time
	// we will rest between 2 and 10 seconds
	var _next_rest_amount = min(irandom_range(2, 10), _e.needed_rest)
	_e.needed_rest -= _next_rest_amount
	_e.alarms[1] = game_get_speed(gamespeed_fps) * _next_rest_amount
}

function enemy_generate_question(_e, _wave) {
	var _max = BASE_ANSWER_VALUE + (5 * floor(_wave / 2))
	var _attempts = 10;
	do {
		try {
			_attempts--;
			// every 5 levels
			var _values = generate_equation_and_answer(_max, min(MAX_MATH_DIFFICULTY, floor(_wave / 7)))
			get_enemy_controller().reserve_answer(_values.answer, _e)
			_e.equation = _values.equation
		} catch (_err) {
			debug(_err)
			if (_err != "Answer in use") {
				throw _err
			}
		}
	} until (_e.equation != "" || _attempts <= 0)
	
	if (_e.equation == "") {
		instance_destroy();
		debug("Could not create equation");
		return
	}
}


function enemy_initialize(_e, _wave) {
	enemy_generate_question(_e, _wave)
	
	var _distance_to_player = distance_to_object(get_player())
	// because approach speed is a pixels/fr, we divide by the frame rate to get the time to reach (in seconds)
	var _time_to_reach_player = (_distance_to_player / _e.approach_speed) /	game_get_speed(gamespeed_fps);
	_e.needed_rest = _e.time_to_solve - _time_to_reach_player
	
	// we reset spawn time so we can calculate time remaining correctly + start the approach immediately
	_e.spawn_time = current_time
	enemy_start_approach(_e)
}