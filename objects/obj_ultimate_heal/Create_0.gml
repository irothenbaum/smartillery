player = get_player();

subscribe(EVENT_ENEMY_HIT, function(_enemy, _player_who_shot_id) {
	var _leech_amount = ult_heal_get_leech_amount(level)
	if (_leech_amount == 0) {
		return
	}
	
	var _turret_muzzle = player.get_turret_muzzle()
	instance_create_layer(_turret_muzzle.x, _turret_muzzle.y, LAYER_INSTANCES, obj_orb_score_increase, {
		amount: _leech_amount,
		type: ORB_TYPE_HEALTH,
		owner_player_id: _player_who_shot_id,
	})
})

ultimate_initialize(self, ULTIMATE_HEAL)