message = "";

y = 100
initial_x = global.x_center
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

// whenver we pause or unpause we clear the input
subscribe(EVENT_TOGGLE_PAUSE, function(_status) {
	message = ""
})

// vibrate on wrong guess
subscribe(EVENT_WRONG_GUESS, function(_guess) {
	shake_start = get_play_time()
	wrong_guess = _guess
	alarm[0] = game_get_speed(gamespeed_fps) * total_shake_time / 1000
})