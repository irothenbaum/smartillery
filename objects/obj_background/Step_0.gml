var _is_at_max_health = get_player().my_health == global.max_health

if (_is_at_max_health) {
	if (!draw_idle_color && !alarm[0]) {
		alarm[0] = 3 * game_get_speed(gamespeed_fps)
	}
} else {
	draw_idle_color = false
}