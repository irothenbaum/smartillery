/// @description Regenerate lines and requeue
generate_all_lines()
// change frquency of every 100ms
alarm[0] = 0.1 * game_get_speed(gamespeed_fps)