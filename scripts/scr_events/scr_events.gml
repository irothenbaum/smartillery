// from_player_shot basically means "apply to ult side effects"
function handle_enemy_hit(_enemy, _player_id, _damage_amount, _from_player_shot = false) {
	// these reactions need to run before register_hit, since a killing blow destroys
	// _enemy immediately and they all bail out via instance_exists(_enemy) checks otherwise
	get_game_controller().increase_combo(_player_id, _enemy)

	if (_from_player_shot) {
		// mark target indications as hit satisfied
		with(obj_ult_assist_target) {
			if (_enemy == target) {
				target_was_hit = true
			}
		}

		// trigger collateral damage
		with (obj_ultimate_collateral) {
			check_hit_enemy_for_collateral_targets(_enemy, _player_id)
		}

		// trigger leech response
		with (obj_ultimate_heal) {
			create_health_orb_on_enemy(_enemy, _player_id)
		}

		// trigger rings response
		with (obj_ultimate_rings) {
			apply_damage_to_enemies_on_ring(_enemy, _player_id)
		}
	}

	// trigger hit on enemy (may destroy _enemy if this is a killing blow)
	with(_enemy) {
		last_hit_by_player_id = _player_id
		register_hit(_damage_amount)
	}
}

function handle_toggle_pause() {
	// pause streak sparks on player
	var _player = get_player()
	with(_player) {
		if (!is_undefined(streak_fire)) {
			pause_particle(streak_fire.system, global.paused)
		}
	}
	
	// pause slow sparks on enemies
	for_each_enemy(function(_e) {
		with(_e) {
			if (!is_undefined(slow_sparks)) {
				pause_particle(slow_sparks, global.paused)
			}
		}
	})
	
	// pause particle effects
	with (obj_particle_effect) {
		pause_particle(ps, global.paused)
	}
	
	with (obj_input) {
		// message clears on pause toggle
		message = ""
		if (!is_undefined(streak_fire)) {
			pause_particle(streak_fire.system, global.paused)
		}
	}
}

function handle_player_streak(_player_id, _new_streak_value) {
	var _player = get_player()
	var _player_input = get_input(_player_id)

	// the shared turret's barrel color/fire reflects every player currently on streak,
	// blended together -- recomputed any time any player's streak status changes
	var _any_on_streak = array_length(get_streaking_player_ids()) > 0
	with (_player) {
		if (_any_on_streak) {
			var _fire_color = get_streak_color(global.turret_color)
			if (is_undefined(streak_fire)) {
				streak_fire = draw_muzzle_smoke(x, y, _fire_color)
			} else {
				part_type_color1(streak_fire.type, _fire_color)
			}
		} else if (!is_undefined(streak_fire)) {
			destroy_particle(streak_fire.system)
			streak_fire = undefined
		}
	}

	if (_new_streak_value == global.point_streak_requirement) {
		// now on streak: turn on fire for this player's own input box
		with (_player_input) {
			if (is_undefined(streak_fire)) {
				streak_fire = draw_muzzle_smoke(x, y, my_color)
				// make it not auto draw so we can control where it gets drawn
				part_system_automatic_draw(streak_fire.system,false);
				size_streak_fire()
			}
		}
	} else if(_new_streak_value == 0) {
		// now off streak

		// remove input fire
		with(_player_input) {
			if (is_undefined(streak_fire)) {
				return
			}
			destroy_particle(streak_fire.system)
			streak_fire = undefined
			
			// also shake the box
			shake_start = get_play_time()
			// total_shake_time is in milliseconds
			alarm[0] = game_get_speed(gamespeed_fps) * total_shake_time / 1000
		}
	}
}