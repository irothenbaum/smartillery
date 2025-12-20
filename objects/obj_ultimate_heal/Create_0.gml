player = get_player();
leach_amount = ult_heal_get_leech_amount(level)

subscribe(self, EVENT_ENEMY_HIT, method(self, function(_enemy, _player_who_shot_id) {
	// var _turret_muzzle = player.get_turret_muzzle()
	instance_create_layer(_enemy.x, _enemy.y, LAYER_BG_EFFECTS, obj_orb_score_increase, {
		amount: leach_amount,
		type: ORB_TYPE_HEALTH,
		owner_player_id: _player_who_shot_id,
	})
}))

ultimate_initialize(self, ULTIMATE_HEAL)