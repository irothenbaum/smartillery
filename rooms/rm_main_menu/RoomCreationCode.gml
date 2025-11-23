function set_up_test() {
	// Use this function to configue test criteria
	global.is_solo = true
	global.is_coop = false
	global.selected_ultimate[$ get_my_steam_id_safe()] = ULTIMATE_COLLATERAL
	global.starting_wave = 6;
	
	room_goto(rm_play_solo)
}





// commend this out
set_up_test()