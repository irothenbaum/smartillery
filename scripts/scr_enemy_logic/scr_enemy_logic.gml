/**
 * @param {Id.Instance} _e
 * @param {Bool} _skip_question_generation
 */
function enemy_initialize(_e, _skip_question_generation = false) {
	with (_e) {
		spawn_time = get_play_time()
		draw_equation_position = undefined
		equation = "";
		point_value = ds_map_find_value(global.points_map, object_index)
		debug("Point value:",  point_value)
		slow_multiplier = 1
		slow_sparks = undefined
		last_hit_by_player_id = undefined
		streak_ineligible = false
		
		subscribe(EVENT_TOGGLE_PAUSE, function(_status) {
			if (!is_undefined(slow_sparks)) {
				pause_particle(slow_sparks, _status)
			}
		})
	}
	
	if (!_skip_question_generation) {
		enemy_generate_question(_e)
	}
}

/**
 * @param {Id.Instance} _e
 */
function enemy_handle_destroy(_e) {
	get_game_controller().handle_enemy_killed(_e)
	with (_e) {
		if (!is_undefined(slow_sparks)) {
			destroy_particle(slow_sparks)
		}
	}
}

/**
 * @param {Id.Instance} _e
 */
function enemy_step(_e) {
	/*
	// do nothing, was going to set depth but it's behaving oddly
	with(_e) {
		
	}
	*/
}

/**
 * @param {Id.Instance} _e
 */
function enemy_draw_equation(_e) {
	with (_e) {
		var _string = global.paused ? " " : equation
		var _positions = get_draw_equation_position(_string, x, y)
		var _actual_position = _positions[0]
		var _target_position = _positions[1]
				
		draw_equation_position = is_undefined(draw_equation_position) ? _target_position : {
			x: lerp(draw_equation_position.x, _actual_position.x, global.fade_speed * 2),
			y: lerp(draw_equation_position.y, _actual_position.y, global.fade_speed * 2)
		}
		draw_text_with_alignment(draw_equation_position.x, draw_equation_position.y, _string, ALIGN_CENTER);
	}
}

/**
 * @param {String} _string
 * @param {Real} _x
 * @param {Real} _y
 * Returns a tuple. The first value is the actual render position, the second is the target render position
 */
function get_draw_equation_position(_string, _x, _y) {
	draw_set_font(fnt_large);
		draw_set_color(c_white);
		var _string_height = string_height(_string)
		var _string_width = string_width(_string)
		// 25 is a constant that basically indicates half the sprite size
		var _offset_y = (_y > global.ycenter ? -1 : 1) * (25 + _string_height)
		
		// this logic is going to draw the equation within the game bounds even if the enemy us out of screen
		var _string_directional_bounds = new Bounds(
			global.directional_hint_bounds.x0 + _string_width / 2,
			global.directional_hint_bounds.y0 + _string_height / 2,
			global.directional_hint_bounds.x1 - _string_width / 2,
			global.directional_hint_bounds.y1 - _string_height / 2
		)
		
		var _target_position = {
			x: _x,
			y: _y + _offset_y
		}
		var _actual_position = _target_position
		
		// we're out of bounds of any of our coordinates as off screen
		var _is_out_of_bounds = 
			_target_position.x < _string_directional_bounds.x0 || 
			_target_position.y < _string_directional_bounds.y0 ||
			_target_position.x > _string_directional_bounds.x1 || 
			_target_position.y > _string_directional_bounds.y1
			
		if (_is_out_of_bounds) {
			var _direction_from_center = point_direction(global.xcenter, global.ycenter, _target_position.x, _target_position.y)
			_actual_position = find_intersection(_string_directional_bounds.width, _string_directional_bounds.height, _direction_from_center)
		}
		
		// make sure we never draw the equation ontop of the HUD elements
		_actual_position.y = max(70, _actual_position.y) // this 70 is basically the HUD height
		
		// we check again here because we need _actual_position in its final state.
		if (_is_out_of_bounds) {
			var _direction_from_equation_to_enemy = point_direction(_actual_position.x, _actual_position.y, x, y) 
			draw_sprite_ext(
				spr_chevron, 
				0, 
				_actual_position.x + lengthdir_x(40, _direction_from_equation_to_enemy), 
				_actual_position.y + lengthdir_y(40, _direction_from_equation_to_enemy),
				0.07, 
				0.07, 
				_direction_from_equation_to_enemy, 
				c_white, 
				1
			)
		}
		
		return [_actual_position, _target_position]
}

function enemy_generate_question(_e) {
	var _wave = get_current_wave_number()
	var _functional_wave = ceil(_wave / ds_map_find_value(global.enemy_difficulty_multiplier, _e.object_index))
	equation = ""
	answer = ""
	
	with (_e) {
		var _attempts = 10;
		do {
			try {
				_attempts--;
				var _values = global.is_math_mode ? generate_equation_and_answer(_functional_wave) : generate_text_and_answer(_functional_wave)
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

function enemy_strike_nearby_enemies(_enemy, _radius) {
	for_each_enemy(function(_e, _index, _enemy, _radius) {
		if (!instance_exists(_e) || !instance_exists(_enemy)) {
			return;
		}
		if (_e.id == _enemy.id) {
			// obviously don't count ourselves as nearby to ourselves
			return
		}
		if (point_distance(_e.x, _e.y, _enemy.x, _enemy.y) < _radius) {
			_e.last_hit_by_player_id = _enemy.last_hit_by_player_id
			_e.register_hit()
			broadcast(EVENT_ENEMY_HIT, _e)
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
				slow_sparks = draw_particle_sparkle(x, y, global.ultimate_color_tints[$ ULTIMATE_SLOW], sprite_width / 2)
			}
		}
		
		if (!is_undefined(slow_sparks)) {
			part_system_position(slow_sparks, x, y)
		}
	}
}


/// @param {Real} _rect_width
/// @param {Real} _rect_height
/// @param {Real} _angle // in degrees
function find_intersection(_rect_width, _rect_height, _angle) {	
	_rect_width = _rect_width / 2
	_rect_height = _rect_height / 2
	
	// Convert angle to radians
    var _angle_radians = (_angle * pi) / 180
	
	// Calculate direction vector components
    var _dx = cos(_angle_radians)
    var _dy = -1 * sin(_angle_radians)
	
	// Find intersection with each edge of the rectangle
    var _t_max = 99999
	
	// Intersection with left and right sides
    if (_dx != 0) {
        _t_max = min(_t_max, (_rect_width / abs(_dx)))
    }

    // Intersection with left and right sides
    if (_dy != 0) {
        _t_max = min(_t_max, (_rect_height / abs(_dy)))
    }

    // Calculate intersection point
    return { 
		x: _t_max * _dx + global.xcenter, 
		y: _t_max * _dy + global.ycenter
	}
}
