message = ""
color = c_white
font = fnt_base
vspeed = -3

function set_amount(_amt, _color, _font) {
	color = is_undefined(_color) ? color : _color 
	font = is_undefined(_font) ? font : _font
	message = "+" + string(_amt)
	alarm[0] = 3 * game_get_speed(gamespeed_fps)
}