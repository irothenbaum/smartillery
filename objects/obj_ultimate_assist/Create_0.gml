range = ult_assist_get_range(level)
max_mistake_score = ult_assist_get_max_mistake_score(level)
ultimate_initialize(self, ULTIMATE_ASSIST)

function handle_answer_given(_answer, _player_id) {
	var _enemies = global.is_math_mode
		? find_enemies_near_answer(_answer, range[0], range[1])
		: find_enemies_with_similar_word(_answer, max_mistake_score)

	for (var _i = 0; _i < array_length(_enemies); _i++) {
		var _e = _enemies[_i]
		instance_create_layer(_e.x, _e.y, LAYER_FG_EFFECTS, obj_ult_assist_target, {target: _e})
		get_player().fire_at_instance(_e, _player_id);
	}

	return array_length(_enemies) > 0
}
