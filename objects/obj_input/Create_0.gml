message = "";

is_controlled = owner_steam_id == global.my_steam_id
streak_color = get_player_color(owner_steam_id)

y = 40
initial_x = global.xcenter - (!global.is_coop ? 0 : (is_host(owner_steam_id) ? global.multiplayer_input_shift_off_center : -1 * global.multiplayer_input_shift_off_center))
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
wrong_guess = ""

if (is_undefined(owner_steam_id) || owner_steam_id == 0) {
	owner_steam_id = get_my_steam_id_safe()
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

// vibrate on wrong guess
subscribe(EVENT_WRONG_GUESS, function(_guess) {
	shake_start = get_play_time()
	wrong_guess = _guess
	alarm[0] = game_get_speed(gamespeed_fps) * total_shake_time / 1000
	broadcast(EVENT_INPUT_CHANGED, {
		input: "",
		is_wrong_guess: true,
	}, owner_steam_id)
}, owner_steam_id)

subscribe(EVENT_GAME_OVER, function() {
	// effectively destroy the particle system
	broadcast(EVENT_ON_OFF_STREAK, false, owner_steam_id)
})

subscribe(EVENT_ON_OFF_STREAK, function(_is_on_streak) {
	if (_is_on_streak) {
		streak_fire = draw_muzzle_smoke(x, y, global.p1_color)
		size_streak_fire()
		broadcast(EVENT_INPUT_CHANGED, {
			input: "",
			is_on_streak: true,
		}, owner_steam_id)
	} else {	
		if (is_undefined(streak_fire)) {
			return
		}
		destroy_particle(streak_fire.system)
		streak_fire = undefined
	}
}, owner_steam_id)
