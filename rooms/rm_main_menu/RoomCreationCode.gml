set_viewport_dimensions()

function set_up_test() {
	// Use this function to configue test criteria
	global.is_solo = true
	global.is_coop = false
	global.active_player_ids = [0]
	global.player_device_map[$ 0] = -1
	global.selected_ultimate[$ 0] = ULTIMATE_ASSIST
	global.starting_wave = 5;

	room_goto(rm_play_solo)
}





// comment this out
set_up_test()
