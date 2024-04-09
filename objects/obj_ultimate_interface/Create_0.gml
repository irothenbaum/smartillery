// ------------------------------------------------------------
// DRAWING CONSTANTS
// ------------------------------------------------------------
x = room_width / 2
y = room_height / 2

width = room_width / 2
height = room_height / 2
width_half = width / 2
height_half = height / 2

y_content_start = y - height_half + 40
x_content_start = x - width_half + 20
y_content_end = y + height_half - 40
x_content_end = x + width_half - 20

// ------------------------------------------------------------
// CODE CONSTANTS
// ------------------------------------------------------------

//these are all possible code sequences to enter
code_options_math = [
	{ label: "Markov numbers", codes: CODE_MATH_MARKOV },
	{ label: "Even numbers", codes: CODE_MATH_EVENS },
	{ label: "Prime numbers", codes: CODE_MATH_PRIMES },
	{ label: "Fibonacci", codes: CODE_MATH_FIB },
	{ label: "Digits of Pi", codes: CODE_MATH_PI },
	{ label: "Pell numbers", codes: CODE_MATH_PELL },
	{ label: "Composite numbers", codes: CODE_MATH_COMPOSITES},
	{ label: "Woodall numbers", codes: CODE_MATH_WOODALL}
]

// the ultimate default is 3 strikes, you can earn bonus codes by solving them faster
default_strike_count = 3
// can score up to 3 extra strikes
total_codes = 3
codes = array_shuffle(code_options_math)
array_resize(codes, total_codes)

solved_codes = 0
current_step = 0

// the user only has 10 seconds to solve this
time_to_solve = 10 * game_get_speed(gamespeed_fps)
alarm[0] = time_to_solve

// ------------------------------------------------------------

function handle_submit_code(_code) {
	var _sequence = codes[solved_codes]
	if (_sequence.codes[current_step] == _code) {
		current_step++
		
		if (current_step >= array_length(_sequence.codes)) {
			current_step = 0
			solved_codes++
	
			if (solved_codes == total_codes) {
				execute_ultimate()
			}
		}
	}
}

function execute_ultimate() {
	// NOTE: We must unpause first before actually triggering the ult
	get_game_controller().mark_ultimate_used()
	
	var _ultimate = instance_create_layer(x,y, LAYER_INSTANCES, obj_ultimate)
	_ultimate.execute(default_strike_count + solved_codes)
	
	instance_destroy()
}