ps = effect(x, y)
// long enough to complete any animation
alarm[0] = 10 * game_get_speed(gamespeed_fps)

subscribe(self, EVENT_TOGGLE_PAUSE, function(_status) {
	pause_particle(ps, _status)
})