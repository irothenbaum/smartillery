player = get_player();
heal_radius = 75
heal_color = global.ultimate_colors[$ ULTIMATE_HEAL]
heal_color_tint = global.ultimate_color_tints[$ ULTIMATE_HEAL]
x = global.xcenter
y = global.ycenter
heal_rate = ult_heal_get_rate(level)
heal_sparks = draw_particle_sparkle(x, y, heal_color_tint, heal_radius)
wave_1 = instance_create_layer(x, y, LAYER_INSTANCES, obj_rotating_wave, {
	color: heal_color,
	rotate_speed: 1,
	waves: 12,
	wave_length: 40,
	amplitude: 10,
	thickness: 2,
})

subscribe(EVENT_ENEMY_DAMAGED, function(_enemy) {
	var _leech_amount = ult_heal_get_leech_amount(level)
	if (_leech_amount == 0) {
		return
	}
	
	var _turret_muzzle = player.get_turret_muzzle()
	instance_create_layer(_turret_muzzle.x, _turret_muzzle.y, LAYER_INSTANCES, obj_text_score_increase, {
		amount: _leech_amount,
		color: heal_color
	})
	player.my_health = min(global.max_health, player.my_health + _leech_amount)
})

subscribe(EVENT_TOGGLE_PAUSE, function(_status) {
	pause_particle(heal_sparks, _status)
})

starting_duration = ult_heal_get_duration(level)
alarm[0] = starting_duration