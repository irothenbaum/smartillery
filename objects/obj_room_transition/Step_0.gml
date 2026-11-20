// runs on its own clock (fixed step), so it still works while the game is paused (e.g. Quit from the pause screen)
if (is_fading_out) {
	alpha = min(1, alpha + step_seconds() / fade_out_duration)
	if (alpha >= 1) {
		is_fading_out = false
		// the screen is black now, so clear every particle (death debris, sparks, ...) before they carry over
		destroy_all_particles()
		if (target_room == room) {
			room_restart()
		} else {
			room_goto(target_room)
		}
	}
} else {
	alpha = max(0, alpha - step_seconds() / fade_in_duration)
	if (alpha <= 0) {
		instance_destroy()
	}
}
