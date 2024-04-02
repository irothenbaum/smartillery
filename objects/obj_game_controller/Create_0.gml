// might be fun to make this configurable
var _seed = 132435345;
random_set_seed(_seed);

current_wave = 4;
wave_ready = true;
global.score = 0;

function mark_wave_complete() {
	current_wave++;
	// TODO: Show wave complete message, set timer, start next wave
	wave_ready = true;
}
