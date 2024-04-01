// might be fun to make this configurable
var _seed = 12345123456;

random_set_seed(_seed);

wave = 1;
wave_ready = true;

function mark_wave_complete() {
	// TODO: Show wave complete message, set timer, start next wave
	wave_ready = true;
}