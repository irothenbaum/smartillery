message = "";

y = 30
initial_x = global.xcenter
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
})

// vibrate on wrong guess
subscribe(EVENT_GAME_OVER, function() {
	destroy_particle(streak_fire.system)
})

subscribe(EVENT_ON_OFF_STREAK, function(_is_on_streak) {
	if (_is_on_streak) {
		streak_fire = draw_muzzle_smoke(x, y, global.power_color)
		size_streak_fire()
	} else {	
		if (is_undefined(streak_fire)) {
			return
		}
		destroy_particle(streak_fire.system)
		streak_fire = undefined
	}
})
