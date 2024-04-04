function draw_particle_player_death(x,y) {
	//par_shockwave
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_circle);
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