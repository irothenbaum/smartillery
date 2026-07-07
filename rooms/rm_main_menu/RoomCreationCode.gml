set_viewport_dimensions()


function set_up_test() {
	// comment this out
	// rm_test's placed instances (e.g. obj_game_controller, which creates obj_input) run
	// their Create events before rm_test's own Room Creation Code does, so any globals
	// they depend on must be set here, before the jump, rather than over there.
	global.is_solo     = true
	global.is_coop     = false
	global.active_player_ids      = [0]
	global.player_device_map[$ 0] = -1
	set_player_ultimate(0, ULTIMATE_STRIKE)
	global.skip_ult_overlay = true
	room_goto(rm_test)
}

set_up_test()