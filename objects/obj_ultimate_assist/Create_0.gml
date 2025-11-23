range = ult_assist_get_range(level)
ultimate_initialize(self, ULTIMATE_ASSIST)

function handle_answer_given(_answer, _player_id) {
	var _enemies = find_enemies_near_answer(_answer, range)
	
	array_foreach(_enemies, method({_player_id: _player_id}, function(_e) {
		with (_e) {
			instance_create_layer(x, y, LAYER_INSTANCES, obj_ult_assist_target, {target: self})
			get_player().fire_at_instance(self, _player_id);
		}
	}))
	
	return array_length(_enemies) > 0
}