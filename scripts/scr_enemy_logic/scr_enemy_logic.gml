/* 
	// this code is an example Create script for an enemy class object
	
	// all enemies must implement these private variables:
	spawn_time = get_play_time()
	equation = "";
	point_value = 10

	// they must also implement these functions:
	function explode_and_destroy() {} // remove instance and create particle system explosion
	function register_hit(_insta_kill=false) {} // report hit by player
	
	// must call this
	enemy_generate_question(self)
*/

function enemy_initlaize(_e, _point_value) {
	with (_e) {
		spawn_time = get_play_time()
		draw_offset_y = undefined
		equation = "";
		point_value = _point_value
	}
	
	enemy_generate_question(_e)
}


function enemy_draw_equation(_e) {	
	with (_e) {
		draw_set_font(fnt_large);
		draw_set_colour(c_white);
		var _string = global.paused ? "******" : equation
		// logically should be sprite_height / 2, but we scale the enemy image to .5 so it becomes / 4
		var _offset_y = (y > room_height / 2 ? -1 : 1)*(20 + string_height(_string))
		draw_offset_y = typeof(draw_offset_y) == "number" ? lerp(draw_offset_y, _offset_y, global.fade_speed) : _offset_y
		draw_text_with_alignment(x, y + draw_offset_y, _string, ALIGN_CENTER);
	}
}

function enemy_generate_question(_e) {
	_wave = get_current_wave_number()
	
	with (_e) {
		var _attempts = 10;
		do {
			try {
				_attempts--;
				var _values = global.is_math_mode ? generate_equation_and_answer(_wave) : generate_text_and_answer(_wave)
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