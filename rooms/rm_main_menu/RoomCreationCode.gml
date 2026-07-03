set_viewport_dimensions()

function set_up_test() {
	// Use this function to configure test criteria
	global.is_solo = true
	global.is_coop = false
	global.starting_wave = 1
	global.selected_ultimate[$ 0] = ULTIMATE_STRIKE
	room_goto(rm_test)
}


// comment this out
set_up_test()
