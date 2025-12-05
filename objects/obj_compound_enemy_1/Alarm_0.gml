/// @description Spawn enemy
if (enemy_count > 0) {
	spawn_enemy()
	alarm[0] = game_get_speed(gamespeed_fps) * 1.2 // just feels right, no dependencies
}
