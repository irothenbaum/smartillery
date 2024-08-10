var _player = get_player();
x = _player.x
y = _player.y
heal_sparks = draw_particle_sparkle(x, y, global.heal_color_tint, global.heal_radius)
wave_1 = instance_create_layer(x, y, LAYER_INSTANCES, obj_rotating_wave, {
	color: global.heal_color,
	rotate_speed: 1,
	waves: 12,
	wave_length: 40,
	amplitude: 10,
	thickness: 2,
})
