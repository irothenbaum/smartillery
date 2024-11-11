function draw_particle_sparkle(x, y, _color, _radius) {
	//par_healing_sparkle
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_sprite(_ptype1, spr_pixel, false, true, false)
	part_type_size(_ptype1, 0.5, 1.5, 0, 1);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 1, 2, 0, 0);
	part_type_direction(_ptype1, 0, 359, 0, 20);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, _color, _color, _color);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, false);
	part_type_life(_ptype1, 70, 90);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -_radius, _radius, -_radius, _radius, ps_shape_ellipse, ps_distr_gaussian);
	part_emitter_stream(_ps, _pemit1, _ptype1, 1);
	part_emitter_interval(_ps, _pemit1, 1, 3, time_source_units_frames);

	part_system_position(_ps, x, y);

	return _ps
}

// scale 1 = ~100
function draw_particle_shockwave(x,y, _scale = 1, _sprite_override = pt_shape_circle) {
	//par_shockwave
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, _sprite_override);
	part_type_size(_ptype1, 1, 1, 1, 0);
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
	part_type_life(_ptype1, 8 * game_get_speed(gamespeed_fps), 8 * game_get_speed(gamespeed_fps));

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -32, 32, -32, 32, ps_shape_rectangle, ps_distr_invgaussian);
	part_emitter_burst(_ps, _pemit1, _ptype1, _number);

	part_system_position(_ps, x, y);

	return _ps
}

function draw_particle_sparks(x,y, _number = 12, _color = c_white) {
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
	part_type_colour3(_ptype1, _color, _color, _color);
	part_type_alpha3(_ptype1, 1, 0.8, 0);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 40, 40);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, _number);

	part_system_position(_ps, x, y);

	return _ps
}

function draw_muzzle_smoke(x, y, _color) {
	//par_muzzle_smoke
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_square);
	part_type_size(_ptype1, 0.2, 0.8, 0, 0);
	part_type_scale(_ptype1, 0.1, 0.1);
	part_type_speed(_ptype1, 0.2, 0.8, 0, 0);
	part_type_direction(_ptype1, 90, 90, 0, 40);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour1(_ptype1, _color);
	part_type_alpha1(_ptype1, 1);
	part_type_blend(_ptype1, false);
	part_type_life(_ptype1, 40, 10);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -10, 10, -10, 10, ps_shape_ellipse, ps_distr_linear);
	part_emitter_stream(_ps, _pemit1, _ptype1, 1);
	part_emitter_interval(_ps, _pemit1, 2, 10, time_source_units_frames)

	part_system_position(_ps, x, y);

	return {
		system: _ps,
		emitter: _pemit1,
		type: _ptype1,
	}
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
	return draw_particle_sparks(x, y, 4)
}

function draw_particle_enemy_1_destroy(x, y) {
	return [draw_particle_shockwave(x, y, 0.8), draw_particle_sparks(x, y, 6), draw_particle_debirs(x, y, 3)]
}

function draw_particle_enemy_2_damage(x, y) {
	return draw_particle_sparks(x, y, 6)
}

function draw_particle_enemy_2_destroy(x, y) {
	return [draw_particle_shockwave(x, y), draw_particle_sparks(x, y, 12), draw_particle_debirs(x, y, 5)]
}

function draw_particle_enemy_3_damage(x, y) {
	return draw_particle_sparks(x, y, 8)
}

function draw_particle_enemy_3_destroy(x, y) {
	return [draw_particle_shockwave(x, y, 0.8), draw_particle_sparks(x, y, 18), draw_particle_debirs(x, y, 5)]
}

function draw_particle_enemy_4_destroy(x, y) {
	return draw_particle_sparks(x, y, 18)
}

function draw_particle_enemy_4_fragment_destroy(x, y) {
	return [draw_particle_shockwave(x, y, 0.4), draw_particle_sparks(x, y, 6), draw_particle_debirs(x, y, 2)]
}

function draw_particle_ultimate_strike(x, y, _radius) {
	return [draw_particle_shockwave(x, y, _radius/100, pt_shape_ring), draw_particle_sparks(x, y, 18)]
}





function pause_particle(_p, _status) {
	if (is_undefined(_p)) {
		return
	}
	if (is_array(_p)) {
		for (var _i = 0; _i < array_length(_p); _i++) {
			if (instance_exists(_p[_i])) {
				part_system_automatic_update(_p[_i], !_status)
			}
		}
	} else if (instance_exists(_p)) {		
		part_system_automatic_update(_p, !_status)
	}
}