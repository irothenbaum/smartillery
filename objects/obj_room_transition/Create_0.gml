/// @description Fade to black, change rooms, fade back in
// Created by transition_to_room (scr_utilities) -- use that rather than creating this directly. Persistent, so the
// same instance fades the old room out and the new room in. Draws in Draw GUI End so it covers everything,
// including the HUD and menus, and is unaffected by the menu's zoomed camera.

fade_out_duration = 0.4 // in seconds
fade_in_duration = 0.4 // in seconds

target_room = undefined // set by transition_to_room
is_fading_out = true // false once the room has changed and we're fading the new one in
alpha = 0

/**
 * @param {Asset.GMRoom} _room
 */
function start(_room) {
	target_room = _room
	is_fading_out = true
}
