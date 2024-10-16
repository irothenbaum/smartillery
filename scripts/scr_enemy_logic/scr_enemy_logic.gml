/* 
	// this code is an example Create script for an enemy class object
	
	// all enemies must implement these private variables:
	spawn_time = get_play_time()
	equation = "";
	point_value = 10

	// they must also implement this functions:
	function register_hit(_insta_kill=false) {} // report hit by player
*/

function enemy_initlaize(_e, _point_value) {
	with (_e) {
		spawn_time = get_play_time()
		draw_offset_y = undefined
		equation = "";
		point_value = _point_value
		slow_multiplier = 1
		slow_sparks = undefined
	}
	
	enemy_generate_question(_e)
}

function enemy_handle_destroy(_e) {
	with (_e) {
		if (!is_undefined(slow_sparks)) {
			destroy_particle(slow_sparks)
		}
	}
}


function enemy_draw_equation(_e) {	
	with (_e) {
		draw_set_font(fnt_large);
		draw_set_colour(c_white);
		var _string = global.paused ? "" : equation
		// logically should be sprite_height / 2, but we scale the enemy image to .5 so it becomes / 4
		var _offset_y = (y > room_height / 2 ? -1 : 1)*(20 + string_height(_string))
		draw_offset_y = typeof(draw_offset_y) == "number" ? lerp(draw_offset_y, _offset_y, global.fade_speed) : _offset_y
		draw_text_with_alignment(x, y + draw_offset_y, _string, ALIGN_CENTER);
	}
}

function enemy_generate_question(_e) {
	_wave = get_current_wave_number()
	equation = ""
	answer = ""
	
	with (_e) {
		var _attempts = 10;
		do {
			try {
				_attempts--;
				var _values = global.is_math_mode ? generate_equation_and_answer(_wave) : generate_text_and_answer(_wave)
				get_game_controller().reserve_answer(_values.answer, self)
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
	
		debug("Generated equation:", equation, answer, _attempts)
	
		if (equation == "") {
			instance_destroy();
			debug("Could not create equation");
			return
		}
	}
}
		
function explode_nearby_enemies(_enemy, _radius) {
	for_each_enemy(function(_e, _index, _enemy, _radius) {
		if (!instance_exists(_e) || !instance_exists(_enemy)) {
			return;
		}
		if (_e.id == _enemy.id) {
			// obviously don't count ourselves as nearby to ourselves
			return
		}
		if (point_distance(_e.x, _e.y, _enemy.x, _enemy.y) < _radius) {
			_e.register_hit(true)
		}
	}, _enemy, _radius)
}

function enemy_remove_slow(_enemy) {
	enemy_apply_slow(_enemy, 1)
}

function enemy_apply_slow(_enemy, _multiplier) {
	with(_enemy) {
		if (slow_multiplier != _multiplier) {
			debug("Applying multiplier ", _multiplier, _enemy)
			// undo our last multiplier
			speed = speed / slow_multiplier
			// apply the new one
			slow_multiplier = _multiplier
			speed = speed * slow_multiplier
			
			if (_multiplier == 1) {
				if (!is_undefined(slow_sparks)) {
					destroy_particle(slow_sparks)
				}
				slow_sparks = undefined
			} else {
				slow_sparks = draw_particle_sparkle(x, y, global.ultimate_color_tints[$ ULTIMATE_SLOW], 20)
			}
		}
		
		if (!is_undefined(slow_sparks)) {
			part_system_position(slow_sparks, x, y)
		}
	}
}