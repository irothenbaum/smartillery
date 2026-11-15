target_y = y - 50
decrease_opacity = false
// a custom message can be passed in on creation (e.g. "Double Tap"); defaults to the score amount
if (!variable_instance_exists(id, "message")) {
	message = "+" + string(amount)
}
alarm[0] = 3 * game_get_speed(gamespeed_fps)
