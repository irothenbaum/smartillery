message = "";

is_controlled = owner_player_id == get_my_steam_id_safe()
streak_color = get_player_color(owner_player_id)

y = 40
initial_x = global.xcenter - (!global.is_coop ? 0 : (is_host(owner_player_id) ? global.multiplayer_input_shift_off_center : -1 * global.multiplayer_input_shift_off_center))
x = initial_x
render_x = x

min_box_width = 80
streak_ratio = 0
draw_streak_ratio = 0
shake_start = undefined

// how long we shake for (milliseconds)
total_shake_time = 500
// how many shakes we do
total_shakes = 3
shake_magnitude = 10
last_guess = ""

if (is_undefined(owner_player_id) || owner_player_id == 0) {
	owner_player_id = get_my_steam_id_safe()
}

my_bounds = undefined
streak_fire = undefined

function size_streak_fire() {
	part_emitter_region(streak_fire.system, streak_fire.emitter, 0, my_bounds.width, 0, 0, ps_shape_rectangle, ps_distr_linear);
	part_system_position(streak_fire.system, my_bounds.x0, my_bounds.y1)		
}

// whenver we pause or unpause we clear the input
subscribe(EVENT_TOGGLE_PAUSE, function(_status) {
	message = ""
	
	if (!is_undefined(streak_fire)) {
		pause_particle(streak_fire.system, _status)
	}
})

subscribe(EVENT_GAME_OVER, function() {
	// effectively destroy the particle system
	broadcast(EVENT_ON_OFF_STREAK, false, owner_player_id)
})

subscribe(EVENT_ON_OFF_STREAK, function(_streak_count) {
	if (_streak_count > 0) {
		streak_fire = draw_muzzle_smoke(x, y, global.p1_color)
		size_streak_fire()
	} else {	
		if (is_undefined(streak_fire)) {
			return
		}
		destroy_particle(streak_fire.system)
		streak_fire = undefined
	}
}, owner_player_id)
