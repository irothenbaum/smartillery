function draw_particle_player_death(x,y) {
	//par_shockwave
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_ring);
	part_type_size(_ptype1, 2, 2, 1, 0);
	part_type_scale(_ptype1, 0.1, 0.1);
	part_type_speed(_ptype1, 0, 0, 0, 0);
	part_type_direction(_ptype1, 0, 0, 0, 0);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, $FFFFFF, $B3B3B3, $1A1A1A);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 20, 20);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -32, 32, -32, 32, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 1);


	part_system_position(_ps, x, y);
	
	return _ps
}

function draw_particle_enemy_damage(x,y) {
	//par_sparks
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//GM_Electricity
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_star);
	part_type_size(_ptype1, 0.2, 0.4, 0, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 4, 8, -0.2, 0);
	part_type_direction(_ptype1, 0, 360, 0, 0);
	part_type_gravity(_ptype1, 0, 270);
	part_type_orientation(_ptype1, 0, 360, 10, 20, false);
	part_type_colour3(_ptype1, $FFFFFF, $FFFFFF, $FFFFFF);
	part_type_alpha3(_ptype1, 1, 0.58, 0.129);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 20, 20);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -8, 8, -8, 8, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 10);

	part_system_position(_ps, x, y);

	return _ps
}