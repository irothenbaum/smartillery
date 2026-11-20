alarm[0] = duration * game_get_speed(gamespeed_fps)
x = bool(x) ? x : global.xcenter
y = bool(y) ? y : global.ycenter

// optional creation param: fade_duration (in seconds). Once duration is up, fade out over this long instead of
// disappearing right away
if (!variable_instance_exists(self, "fade_duration")) {
	fade_duration = 0
}
fade_elapsed = undefined // in seconds since the fade started (undefined = not fading yet)
