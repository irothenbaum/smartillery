ps = draw_particle_player_death(x, y)
// long enough to complete the animation, short enough to not run again
alarm[0] = 1 * game_get_speed(gamespeed_fps)

function destroy_ps() {
	part_system_destroy(ps)
}