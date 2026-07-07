/// @description Cycle and confirm ultimate selection

if (is_locked) exit

if (device_index >= 0) {
	if (gamepad_button_check_pressed(device_index, gp_padl))  { cycle(-1) }
	if (gamepad_button_check_pressed(device_index, gp_padr))  { cycle(1) }
	if (gamepad_button_check_pressed(device_index, gp_face1)) { confirm_selection() }
} else {
	if (keyboard_check_pressed(vk_left))  { cycle(-1) }
	if (keyboard_check_pressed(vk_right)) { cycle(1) }
	if (keyboard_check_pressed(vk_enter)) { confirm_selection() }
}

// clicking the on-screen arrows cycles this card specifically (the one that owns
// whichever arrow bounds the click landed in)
if (mouse_check_button_pressed(mb_left)) {
	if (!is_undefined(left_arrow_bounds) && is_spot_in_bounds(mouse_x, mouse_y, left_arrow_bounds)) {
		cycle(-1)
	} else if (!is_undefined(right_arrow_bounds) && is_spot_in_bounds(mouse_x, mouse_y, right_arrow_bounds)) {
		cycle(1)
	}
}
