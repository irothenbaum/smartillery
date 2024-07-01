function draw_particle_shockwave(x,y, _scale = 1) {
	//par_shockwave
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_circle);
	part_type_size(_ptype1, 1, 0, 1, 0);
	part_type_scale(_ptype1, 0.2 * _scale, 0.2 * _scale);
	part_type_speed(_ptype1, 0, 0, 0, 0);
	part_type_direction(_ptype1, 0, 0, 0, 0);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, $FFFFFF, $777777, $000000);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 20, 20);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 1);

	part_system_position(_ps, x, y);
	
	return _ps
}

function draw_particle_debirs(x,y, _number = 3) {
	//par_debris
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_line);
	part_type_size(_ptype1, 1, 1, 0, 0);
	part_type_scale(_ptype1, 0.4, 0.4);
	part_type_speed(_ptype1, 10, 10, -0.4, 0);
	part_type_direction(_ptype1, 0, 360, 0, 0);
	part_type_gravity(_ptype1, 0, 270);
	part_type_orientation(_ptype1, 0, 360, 0, 0, false);
	part_type_colour3(_ptype1, $FFFFFF, $FFFFFF, $000000);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 240, 240);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -32, 32, -32, 32, ps_shape_rectangle, ps_distr_invgaussian);
	part_emitter_burst(_ps, _pemit1, _ptype1, _number);

	part_system_position(_ps, x, y);

	return _ps
}

function draw_particle_sparks(x,y, _number = 12) {
	//par_sparks
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//GM_Electricity
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_pixel);
	part_type_size(_ptype1, 3, 3, 0, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 4, 8, -0.1, 0);
	part_type_direction(_ptype1, 0, 360, 0, 0);
	part_type_gravity(_ptype1, 0, 270);
	part_type_orientation(_ptype1, 0, 360, 10, 20, false);
	part_type_colour3(_ptype1, $FFFFFF, $B3B3B3, $000000);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 40, 40);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, _number);

	part_system_position(_ps, x, y);

	return _ps
}

function destroy_particle(_p) {
	if (is_undefined(_p)) {
		return
	}
	if (is_array(_p)) {
		array_foreach(_p, destroy_particle)
	} else {
		part_system_destroy(_p)
	}
}


// ---------------------------------------------------------
// COBOS FUNCITONS

function draw_particle_enemy_1_damage(x, y) {
	return draw_particle_sparks(x, y, 12)
}

function draw_particle_enemy_1_destroy(x, y) {
	return [draw_particle_shockwave(x, y), draw_particle_sparks(x, y, 18), draw_particle_debirs(x, y, 3)]
}

function draw_particle_enemy_2_damage(x, y) {
	return draw_particle_sparks(x, y, 12)
}

function draw_particle_enemy_2_destroy(x, y) {
	return [draw_particle_shockwave(x, y), draw_particle_sparks(x, y, 18), draw_particle_debirs(x, y, 5)]
}

function draw_particle_enemy_3_destroy(x, y) {
	return [draw_particle_shockwave(x, y), draw_particle_sparks(x, y, 18), draw_particle_debirs(x, y, 5)]
}

function draw_particle_ultimate_strike(x, y,) {
	return [draw_particle_shockwave(x, y, 1.5), draw_particle_sparks(x, y, 18)]
}
