range = ult_collateral_get_radius(level)
ultimate_initialize(self, ULTIMATE_COLLATERAL)

subscribe(EVENT_ENEMY_HIT, method({_radius: range}, function(_target, _player_who_shot_id) {
	instance_create_layer(_target.x, _target.y, LAYER_INSTANCES, obj_ult_collateral_explosion)
	var _struck_enemies = enemy_strike_nearby_enemies(_target, _radius)
	
	var _on_streak = get_game_controller().has_point_streak(_player_who_shot_id)
	var _color = _on_streak ? get_player_color(_player_who_shot_id) : global.ultimate_colors[$ ULTIMATE_COLLATERAL]
	
	array_foreach(_struck_enemies, method({_origin: _target, _c: _color}, function(_enemy) {
		instance_create_layer(_origin.x, _origin.y, LAYER_INSTANCES, obj_electric_beam, {
			target_x: _enemy.x,
			target_y: _enemy.y,
			width: global.beam_width,
			color: _c
		})
	}))
}))