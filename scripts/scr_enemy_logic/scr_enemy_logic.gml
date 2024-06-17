/* 
	// this code is an example Create script for an enemy class object
	
	// all enemies must implement these private variables:
	spawn_time = get_play_time()
	firing_position = undefined
	shooting = false
	equation = "";
	speed = 0;
	approach_speed = 1
	point_value = 10


	// they must also implement these functions:
	function explode_and_destroy() {} // remove instance and create particle system explosion
	function register_hit(_insta_kill=false) {} // report hit by player
	function fire_shot() {} // shoot at player
	
	// must call this
	enemy_initialize(self)
*/


function enemy_draw_equation(_e) {	
	with (_e) {
		draw_set_font(fnt_large);
		draw_set_colour(c_white);
		var _string = global.paused ? "******" : (equation == "" ? "-- - --" : equation)
		// logically should be sprite_height / 2, but we scale the enemy image to .5 so it becomes / 4
		var _offset_y = 20 + string_height(_string)
		var _y = y > room_height / 2 ? y - _offset_y : y + _offset_y
		draw_text_with_alignment(x, _y, _string, ALIGN_CENTER);
	}
}

function enemy_generate_question(_e) {
	_wave = get_current_wave_number()
	
	with (_e) {
		var _max = math_determine_max_from_wave(_wave)
		var _attempts = 10;
		do {
			try {
				_attempts--;
				// every 5 levels
				var _values = generate_equation_and_answer(_max, min(MAX_MATH_DIFFICULTY, floor(_wave / WAVE_DIFFICULTY_STEP)))
				get_enemy_controller().reserve_answer(_values.answer, self)
				equation = _values.equation
				answer = _values.answer
			} catch (_err) {
				debug(_err)
				if (_err != "Answer in use") {
					debug("ENCOUNTERED ERROR:", _err)
					throw _err
				}
			}
		} until (equation != "" || _attempts <= 0)
	
		debug("Generated equation:", equation, answer)
	
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
		speed = approach_speed
	}
}