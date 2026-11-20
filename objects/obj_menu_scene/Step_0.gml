// keep target_enemy_count enemies alive, one at a time, with a little randomness between spawns
if (instance_number(obj_menu_enemy_1) < target_enemy_count && !(alarm[0] > 0)) {
	alarm[0] = random_range(min_spawn_delay, max_spawn_delay) * game_get_speed(gamespeed_fps)
}
