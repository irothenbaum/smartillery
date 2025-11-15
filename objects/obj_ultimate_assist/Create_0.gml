range = ult_assist_get_range(level)
ultimate_initialize(self, ULTIMATE_ASSIST)

subscribe(EVENT_ANSWER_GIVEN, method({_range: range}, function(_answer, _player_id) {
	var _gc = get_game_controller()
	var _player = get_player()
	
	var _enemies = find_enemies_near_answer(_answer, _range)
}))