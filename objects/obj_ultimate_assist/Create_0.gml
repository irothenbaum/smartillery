range = ult_assist_get_range(level)
ultimate_initialize(self, ULTIMATE_ASSIST)

function handle_answer_given(_answer, _player_id) {
	var _enemies = find_enemies_near_answer(_answer, range)
	
	debug("Found enemies near answe", array_length(_enemies))
	
	array_foreach(_enemies, method({_player_id: _player_id}, function(_e) {
		instance_create_layer(_e.x, _e.y, LAYER_FG_EFFECTS, obj_ult_assist_target, {target: _e})
		get_player().fire_at_instance(_e, _player_id);
	}))
	
	return array_length(_enemies) > 0
}