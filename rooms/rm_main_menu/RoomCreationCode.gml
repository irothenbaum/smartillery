set_viewport_dimensions()

function set_up_test() {
	// Use this function to configue test criteria
	global.is_solo = true
	global.is_coop = false
	global.selected_ultimate[$ get_my_steam_id_safe()] = ULTIMATE_TURRET
	global.starting_wave = 5;
	
	room_goto(rm_play_solo)
}





// comment this out
set_up_test()
