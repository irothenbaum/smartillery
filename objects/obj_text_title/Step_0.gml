/// @description Fade out (see Alarm 0)
if (!is_undefined(fade_elapsed)) {
	fade_elapsed += step_seconds()
	if (fade_elapsed >= fade_duration) {
		instance_destroy()
	}
}
