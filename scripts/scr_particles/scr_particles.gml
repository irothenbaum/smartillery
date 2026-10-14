function draw_particle_sparkle(x, y, _color, _radius) {
	//par_healing_sparkle
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_sprite(_ptype1, spr_pixel, false, true, false)
	part_type_size(_ptype1, 0.25, 0.8, 0, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 0.5, 1, 0, 0);
	part_type_direction(_ptype1, 0, 359, 0, 20);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_color3(_ptype1, _color, _color, _color);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, false);
	part_type_life(_ptype1, 40, 50);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -_radius, _radius, -_radius, _radius, ps_shape_ellipse, ps_distr_gaussian);
	part_emitter_stream(_ps, _pemit1, _ptype1, 1);
	part_emitter_interval(_ps, _pemit1, 1, 3, time_source_units_frames);

	part_system_position(_ps, x, y);

	return _ps
}

// scale 1 = ~100
function draw_particle_shockwave(x,y, _scale = 1, _sprite_override = pt_shape_circle, _color = c_white) {
	//par_shockwave
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	//Emitter
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, _sprite_override);
	part_type_size(_ptype1, 1, 1, 1, 0);
	part_type_scale(_ptype1, _scale / 10, _scale / 10);
	part_type_speed(_ptype1, 0, 0, 0, 0);
	part_type_direction(_ptype1, 0, 0, 0, 0);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_color3(_ptype1, _color, _color, _color);
	part_type_alpha3(_ptype1, 1, 1, 0.1);
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
	part_type_color3(_ptype1, $FFFFFF, $FFFFFF, $000000);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 8 * game_get_speed(gamespeed_fps), 8 * game_get_speed(gamespeed_fps));

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -32, 32, -32, 32, ps_shape_rectangle, ps_distr_invgaussian);
	part_emitter_burst(_ps, _pemit1, _ptype1, _number);

	part_system_position(_ps, x, y);

	return _ps
}

function draw_particle_sparks(x,y, _number = 12, _color = c_white, _direction=0, _sweep = 360) {
	//par_sparks
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);
	
	var _half_sweep = _sweep / 2

	//GM_Electricity
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_pixel);
	part_type_size(_ptype1, 8, 8, -0.2, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 4, 8, -0.1, 0);
	part_type_direction(_ptype1, _direction - _half_sweep, _direction + _half_sweep, 0, 0);
	part_type_gravity(_ptype1, 0, 270);
	part_type_orientation(_ptype1, 0, 360, 0, 20, false);
	part_type_color3(_ptype1, _color, _color, _color);
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
	part_type_color1(_ptype1, _color);
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

function draw_particle_enemy_5_damage(x, y) {
	return draw_particle_sparks(x, y, 6)
}

function draw_particle_enemy_5_destroy(x, y) {
	return [draw_particle_shockwave(x, y), draw_particle_sparks(x, y, 12), draw_particle_debirs(x, y, 5)]
}

function draw_particle_enemy_5_missile_destroy(x, y) {
	return [draw_particle_shockwave(x, y), draw_particle_sparks(x, y, 12), draw_particle_debirs(x, y, 5)]
}

function draw_particle_extra_ultimate_destroy(x, y, _ult_color) {
	return [draw_particle_shockwave(x, y, 0.6), draw_particle_sparks(x, y, 8), draw_particle_sparks(x, y, 8, _ult_color)]
}

function draw_missile_trail() {
	var _ps = part_system_create();
	part_system_draw_order(_ps, true);

	// Growing circle that fades out
	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_circle);
	// Start at ~1px (size 0.03 * 64px circle = ~2px), grow to ~40px (size 0.625 * 64 = 40px)
	part_type_size(_ptype1, 0.03, 0.03, 0.02, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 0, 0, 0, 0);
	part_type_direction(_ptype1, 0, 0, 0, 0);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_color1(_ptype1, c_white);
	part_type_alpha3(_ptype1, 1, 0.5, 0);
	part_type_blend(_ptype1, true);
	// Life long enough for particle to grow from 1px to 40px: (0.625 - 0.03) / 0.02 = ~30 frames
	part_type_life(_ptype1, 30, 30);

	return {
		system: _ps,
		type: _ptype1,
	}
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
/**
 * Ambient glitter: soft dust motes that drift and fade in/out, plus occasional twinkles.
 * Drawn on the BG_Effects layer so it sits above the background rings but below everything else.
 * Spawning is done by hand in background_glitter_step (not with emitters) so the spawn area can follow the
 * healthy rings without reconfiguring anything. It starts with a radius of 0 (nothing spawns)
 * @returns {Struct}
 */
function create_background_glitter() {
	var _ps = part_system_create_layer(LAYER_BG_EFFECTS, false)

	// dust motes
	var _dust = part_type_create()
	part_type_shape(_dust, pt_shape_disk) // hard edged (pt_shape_sphere is a soft blur)
	part_type_size(_dust, 0.03, 0.08, 0, 0) // pt shapes are 64px, so ~2-5px
	part_type_speed(_dust, 0.01, 0.04, 0, 0)
	part_type_direction(_dust, 0, 359, 0, 0.67)
	part_type_color_mix(_dust, c_white, #ffb8f0)
	// fade in, then back out. Peak brightness is set in set_background_glitter_radius
	part_type_blend(_dust, true)
	part_type_life(_dust, 360, 900)

	// occasional brighter twinkles
	var _twinkle = part_type_create()
	part_type_shape(_twinkle, pt_shape_star) // hard edged (pt_shape_flare is a soft blur)
	part_type_size(_twinkle, 0.08, 0.2, 0, 0)
	part_type_orientation(_twinkle, 0, 359, 0.33, 0, false)
	part_type_color_mix(_twinkle, c_white, #ffd6fa)
	part_type_blend(_twinkle, true)
	part_type_life(_twinkle, 120, 240)

	return {
		system: _ps,
		dust_type: _dust,
		twinkle_type: _twinkle,
		radius: 0,
		// spawn rates per frame for a screen-sized area: dust lives 630 frames on average, so 1 every 4.3 frames
		// keeps ~145 on screen. Twinkles live 180 frames, so 1 every 64 frames keeps ~3 on screen
		dust_per_frame: 1 / 4.3,
		twinkle_per_frame: 1 / 64,
		// peak brightness at full health -- it scales up to max_brightness_boost x as the healthy area shrinks
		dust_alpha: 0.45,
		twinkle_alpha: 0.85,
		max_brightness_boost: 2,
	}
}

/**
 * Spawns this frame's glitter at random points inside the healthy circle. Call once per frame.
 * @param {Struct} _glitter -- from create_background_glitter
 */
function background_glitter_step(_glitter) {
	_spawn_background_glitter(_glitter, _glitter.dust_type, _glitter.dust_per_frame)
	_spawn_background_glitter(_glitter, _glitter.twinkle_type, _glitter.twinkle_per_frame)
}

/**
 * Limits where glitter spawns to a circle of _radius around the player.
 * Shrinking clears the existing glitter (which can live up to 15s) and re-simulates it inside the new circle,
 * so nothing lingers outside it. Growing just widens the spawn area and new glitter fills in naturally.
 * @param {Struct} _glitter -- from create_background_glitter
 * @param {Real} _radius
 */
function set_background_glitter_radius(_glitter, _radius) {
	_radius = max(0, _radius)
	if (_radius == _glitter.radius) {
		return
	}
	var _shrinking = _radius < _glitter.radius
	_glitter.radius = _radius

	// glitter gets brighter as the healthy area shrinks
	var _lost = 1 - clamp(_radius / global.bg_circle_max_radius, 0, 1)
	var _boost = lerp(1, _glitter.max_brightness_boost, _lost)
	part_type_alpha3(_glitter.dust_type, 0, min(1, _glitter.dust_alpha * _boost), 0)
	part_type_alpha3(_glitter.twinkle_type, 0, min(1, _glitter.twinkle_alpha * _boost), 0)

	if (_shrinking) {
		part_particles_clear(_glitter.system)
		// the longest particle life, so the circle is immediately at its steady state
		repeat (900) {
			background_glitter_step(_glitter)
			part_system_update(_glitter.system)
		}
	}
}

/**
 * Picks random points uniformly inside the circle, keeping only on-screen ones -- so the on-screen density
 * matches the per-frame rate (which is tuned for a screen-sized area) no matter how big the circle is
 */
function _spawn_background_glitter(_glitter, _type, _per_frame) {
	if (_glitter.radius <= 0) {
		return
	}
	var _area_ratio = (pi * _glitter.radius * _glitter.radius) / (global.room_width * global.room_height)
	var _attempts = _per_frame * _area_ratio
	// fractional attempts become a chance of one more
	var _count = floor(_attempts) + (random(1) < frac(_attempts) ? 1 : 0)
	repeat (_count) {
		var _distance = _glitter.radius * sqrt(random(1)) // sqrt keeps the spread uniform rather than bunched at the center
		var _angle = random(360)
		var _x = global.xcenter + lengthdir_x(_distance, _angle)
		var _y = global.ycenter + lengthdir_y(_distance, _angle)
		if (_x >= 0 && _x <= global.room_width && _y >= 0 && _y <= global.room_height) {
			part_particles_create(_glitter.system, _x, _y, _type, 1)
		}
	}
}

/**
 * @param {Struct} _glitter -- from create_background_glitter
 */
function destroy_background_glitter(_glitter) {
	part_system_destroy(_glitter.system)
	part_type_destroy(_glitter.dust_type)
	part_type_destroy(_glitter.twinkle_type)
}
