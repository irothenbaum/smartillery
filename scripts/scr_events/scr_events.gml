// from_player_shot basically means "apply to ult side effects"
function handle_enemy_hit(_enemy, _player_id, _damage_amount, _from_player_shot = false) {
	// trigger hit on enemy
	with(_enemy) {
		last_hit_by_player_id = _player_id
		register_hit(_damage_amount)
	}
	
	// increase combo for shooter
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
			pause_particle(streak_fire.system, _status)
		}
	}
}

function handle_player_streak(_player_id, _new_streak_value) {
	var _player = get_player()
	var _player_input = get_input(_player_id)
	
	if (_new_streak_value == global.point_streak_requirement) {
		// now on streak
		
		// turn on fire for player muzzle
		with(_player)  {
			if (is_undefined(streak_fire)) {
				streak_fire = draw_muzzle_smoke(x, y, my_color)
			}
		}
		
		// turn on fire for player input box
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
		
		// remove player fire
		with(_player)  {
			if (is_undefined(streak_fire)) {
				return
			}
			destroy_particle(streak_fire.system)
			streak_fire = undefined
		}
		
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