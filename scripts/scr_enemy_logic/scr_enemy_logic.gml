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


	// they must also implement these functions:
	function explode_and_destroy() {} // remove instance and create particle system explosion
	function register_hit(_insta_kill=false) {} // report hit by player
	function handle_hit_player() {} // report collided with player
*/


// TODO: This approach logic should be refactored to not use the current_time at all (due to complications with Pause modes). 
// Instead, we will take a pre-defined number of pauses. Each one resuming towards a point AROUND the player
// nutul we complete the last pause - starting the final approach - in which case we head FOR the player
function enemy_start_approach(_e) {
	with (_e) {
		debug("start approach", needed_rest)
		speed = approach_speed
	
		// if the rest we need is less than 1 second remaining, we just skip it
		if (needed_rest >= 1) {
			// must walk at least 3 seconds, up to the time to solve (minus 3)
			var _next_approach_amount = irandom_range(2, (remaining_time_to_solve - needed_rest) - 2)
			alarm[0] = game_get_speed(gamespeed_fps) * _next_approach_amount
		}
		// else, we keep approaching until we reach it
	}
}

function enemy_stop_approach(_e, _force_wait_time = 0) {
	debug("stop approach")
	with (_e) {
		speed = 0;
		var _alive_time = current_time - spawn_time

		remaining_time_to_solve = time_to_solve - _alive_time
		// we will rest between 2 and 10 seconds
		var _next_rest_amount = min(irandom_range(2, 10), needed_rest)
		
		if (_force_wait_time) {
			_next_rest_amount = _force_wait_time
		}
		
		needed_rest -= _next_rest_amount
		
		// prevent needed rest from going below  0
		needed_rest = max(0, needed_rest)
		
		alarm[1] = game_get_speed(gamespeed_fps) * max(0, _next_rest_amount)
	}
}

function enemy_draw(_e) {
	with (_e) {
		draw_self();
		draw_set_valign(fa_middle);
		draw_set_font(fnt_large);
		draw_set_colour(c_white);
		var _offset_y = sprite_height / 2 + string_height(equation)
		var _y = y > room_height / 2 ? y - _offset_y : y + _offset_y
		draw_text(x - string_width(equation) / 2, _y, equation);
	}
}

function enemy_generate_question(_e) {
	_wave = get_current_wave_number()
	
	with (_e) {
		var _max = BASE_ANSWER_VALUE + (5 * floor(_wave / 2))
		var _attempts = 10;
		do {
			try {
				_attempts--;
				// every 5 levels
				var _values = generate_equation_and_answer(_max, min(MAX_MATH_DIFFICULTY, floor(_wave / 7)))
				get_enemy_controller().reserve_answer(_values.answer, self)
				equation = _values.equation
			} catch (_err) {
				debug(_err)
				if (_err != "Answer in use") {
					throw _err
				}
			}
		} until (equation != "" || _attempts <= 0)
	
		if (equation == "") {
			instance_destroy();
			debug("Could not create equation");
			return
		}
	}
}


function enemy_initialize(_e) {
	with (_e) {
		enemy_generate_question(self)
	
		var _distance_to_player = distance_to_object(get_player())
		// because approach speed is a pixels/fr, we divide by the frame rate to get the time to reach (in seconds)
		var _time_to_reach_player = (_distance_to_player / approach_speed) /	game_get_speed(gamespeed_fps);
		needed_rest = time_to_solve - _time_to_reach_player
		needed_rest = max(0, needed_rest)
	
		// we reset spawn time so we can calculate time remaining correctly + start the approach immediately
		spawn_time = current_time
		enemy_start_approach(self)
	}
}

function enemy_step(_e) {
	var _player = get_player()
	with (_e) {
		direction = point_direction(x, y, _player.x, _player.y);
		
		if (place_meeting(x, y, _player)) {
		    handle_hit_player()
			_player.execute_take_damage()
		}
	}
}