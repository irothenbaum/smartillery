function draw_particle_player_death(x,y) {
	//par_shockwave
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_circle);
	part_type_size(_ptype1, 1, 0, 1, 0);
	part_type_scale(_ptype1, 0.2, 0.2);
	part_type_speed(_ptype1, 0, 0, 0, 0);
	part_type_direction(_ptype1, 0, 0, 0, 0);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, $FFFFFF, $B3B3B3, $1A1A1A);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 20, 20);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 1);

	part_system_position(_ps, x, y);
	
	return _ps
}

function draw_particle_enemy_damage(x,y) {
	return [
		_create_spark(x, y, spr_particle_divide),
		_create_spark(x, y, spr_particle_exponent),
		_create_spark(x, y, spr_particle_add)
	]
}

function _create_spark(x,y, _sprite) {
	//par_sparks
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//GM_Electricity
	var _ptype1 = part_type_create();
	part_type_sprite(_ptype1, _sprite, false, true, false)
	part_type_size(_ptype1, 1, 1, 0, 0);
	part_type_scale(_ptype1, 0.6, 0.6);
	part_type_speed(_ptype1, 4, 8, -0.1, 0);
	part_type_direction(_ptype1, 0, 360, 0, 0);
	part_type_gravity(_ptype1, 0, 270);
	part_type_orientation(_ptype1, 0, 360, 10, 20, false);
	part_type_colour3(_ptype1, $FFFFFF, $B3B3B3, $1A1A1A);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 40, 40);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 3);

	part_system_position(_ps, x, y);

	return _ps
}