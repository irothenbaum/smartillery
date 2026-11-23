// -------------------------------------------------------------------------------------------
// General & Shared functions
// -------------------------------------------------------------------------------------------

#macro ULT_BASE_DURATION 20
#macro ULT_DURATION_INCREMENT 1
// in frames
function ult_base_get_duration(_level) {
	return (ULT_BASE_DURATION + (_level * ULT_DURATION_INCREMENT)) * game_get_speed(gamespeed_fps)
}

function get_experience_needed_for_next_level(_curent_level) {
	// these are basically points needed
	return global.ultimate_requirement * _curent_level
}

// -------------------------------------------------------------------------------------------
// LEECH
// -------------------------------------------------------------------------------------------

function ult_heal_get_duration(_level) {
	return ult_base_get_duration(_level)
}

#macro LEECH_MINIMUM_AMOUNT 3
#macro LEECH_MINIMUM_INCREMENT 1
// in health
function ult_heal_get_leech_amount(_level) {
	return LEECH_MINIMUM_AMOUNT + (_level  - 1) * LEECH_MINIMUM_INCREMENT
}

// -------------------------------------------------------------------------------------------
// AIR STRIKE
// -------------------------------------------------------------------------------------------

#macro STRIKE_MINIMUM 4
#macro STRIKE_INCREMENT_LEVEL_STEP 1
// n > 0
function ult_strike_get_count(_level) {
	// level 4 we get our first bump, then level 7, then 10
	return STRIKE_MINIMUM + floor((_level - 1) / STRIKE_INCREMENT_LEVEL_STEP)
}

// -------------------------------------------------------------------------------------------
// TIME SLOW
// -------------------------------------------------------------------------------------------

#macro SLOW_BASE_MULTIPLIER 0.8
#macro SLOW_MULTIPLIER_INCREMENR 0.5
function ult_slow_get_speed_multiplier(_level) {
	return max(0.1, SLOW_BASE_MULTIPLIER - (SLOW_MULTIPLIER_INCREMENR * _level))
}

// in frames
function ult_slow_get_duration(_level) {
	return ult_base_get_duration(_level)
}

// -------------------------------------------------------------------------------------------
// AIM ASSIST
// -------------------------------------------------------------------------------------------

function ult_assist_get_duration(_level) {
	return ult_base_get_duration(_level)
}

// this will return a range (numbers above and numbers below a target) based on level
// e.g., if you are level 4, the range would be [2,1], and guess number 10 you'd apply range to include numbers 8 (10 - 2) through 11 (10 + 1)
function ult_assist_get_range(_level) {
	return [
		// min number 
		floor(_level / 2),
		// max number
		floor((_level-1) / 2)
	]
}

// Typing mode equivalent of the range: the highest mistake score (see word_mistake_score) another enemy's word can
// have compared to the typed word and still get hit. Level 1 = 0 (no effect, same as the math range), level 2 = 1
// (any single mistake), level 3 = 2 (two different kinds of mistakes), level 4 = 3 (two of the same kind), etc
function ult_assist_get_max_mistake_score(_level) {
	return _level - 1
}

// -------------------------------------------------------------------------------------------
// COLLATERAL DAMAGE
// -------------------------------------------------------------------------------------------

function ult_collateral_get_duration(_level) {
	return ult_base_get_duration(_level)
}

#macro COLLATERAL_BASE_RADIUS global.bg_circle_ring_width * 1.5 // base should be the rings above and below your target. Which means 1 above + target ring + 1 below = 3, 3 / 2 = 1.5
#macro COLLATERAL_RADIUS_INCREMENT_STEP 30
// in pixels
function ult_collateral_get_radius(_level) {
	return COLLATERAL_BASE_RADIUS + (_level - 1) * COLLATERAL_RADIUS_INCREMENT_STEP
}

// -------------------------------------------------------------------------------------------
// TURRET
// -------------------------------------------------------------------------------------------

function ult_turret_get_duration(_level) {
	return ult_base_get_duration(_level)
}

// this will return a number indicating how many turrets should be in orbit
function ult_turret_get_turret_count(_level) {
	return _level * 2
}


// -------------------------------------------------------------------------------------------
// RINGS
// -------------------------------------------------------------------------------------------

function ult_rings_get_duration(_level) {
	return ult_base_get_duration(_level)
}

// this will return a range (rings above and rings below a target) based on level
// e.g., if you are level 4, the range would be [2,1], and strike ring 3 you'd apply range to include rings 1 (3 - 2) through 4 (3 + 1)
function ult_rings_get_ring_range(_level) {
	return [
		// min ring 
		floor(_level / 2),
		floor((_level-1) / 2)
	]
}


// -------------------------------------------------------------------------------------------
// Utilities

/**
 * @param {String} _player_id
 * @returns {String}
 */
function get_player_ultimate(_player_id) {
	var _ult = global.selected_ultimate[$ _player_id]
	// falls back instead of handing back undefined -- a room that skips the
	// select-ultimate screen (e.g. rm_test) may not have populated this yet by the
	// time a placed instance's Create event asks for it
	return is_undefined(_ult) ? ULTIMATE_STRIKE : _ult
}

/**
 * @param {String} _player_id
 * @param {String} _ultimate
 */
function set_player_ultimate(_player_id, _ultimate) {
	// silent priming read, no console output -- carried over from confirm_selection()'s
	// original workaround for a struct-write visibility issue that was never fully
	// isolated (see git history). Centralized here so every writer gets it, not just
	// whichever call site happened to have it -- e.g. rm_test's bootstrap previously
	// wrote directly to global.selected_ultimate and skipped this entirely.
	variable_struct_get_names(global.selected_ultimate)
	global.selected_ultimate[$ _player_id] = _ultimate
}

function is_duration_ult(_ult_type) {
	return _ult_type != ULTIMATE_STRIKE
}

/**
 * @param {Id.Instance} _obj
 */
function ultimate_initialize(_obj, _type) {
	with (_obj) {
		ult_overlay = 1
		ult_type = _type
		game_controller = get_game_controller()
		// is_extra defaults to false; only true when passed via instance creation struct
		if (!variable_instance_exists(id, "is_extra")) {
			is_extra = false
		}
		if (is_duration_ult(ult_type)) {
			starting_duration = ult_base_get_duration(level)
			alarm[0] = starting_duration
		} else {
			start_duration = 0
		}
	}
}

/**
 * @param {Id.Instance} _obj
 */
function ultimate_step(_obj) {
	with(_obj) {
		if (ult_overlay > 0.001) {
			ult_overlay = lerp(ult_overlay, 0, global.fade_speed / 2)
		} else {
			ult_overlay = 0
		}

		if (is_extra) {
			// extras don't animate the player charge icon
			return
		}

		if (is_duration_ult(ult_type)) {
			game_controller.ultimate_charge[$ owner_player_id] = max(0, global.ultimate_requirement * alarm[0] / starting_duration)
		} else {
			// drain the charge meter while the ultimate runs
			game_controller.ultimate_charge[$ owner_player_id] = lerp(game_controller.ultimate_charge[$ owner_player_id], 0, global.fade_speed)
		}
	}
}

#macro ULT_TIMER_CIRCLE_THICKNESS 4

/**
 * @param {Id.Instance} _obj
 */
function ultimate_draw(_obj) {
	with (_obj) {
		// this draws the ult icon flash over the screen when the player launches their ultimate
		if (ult_overlay > 0  && !global.skip_ult_overlay) {
			var _scale = 0.3 + (1 - ult_overlay ) / 2.5
			draw_sprite_ext(global.ultimate_icons[$ ult_type], 0, global.xcenter, global.ycenter, _scale, _scale, 0, global.ultimate_colors[$ ult_type], ult_overlay)
			// draw_rectangle_clipped(new Bounds(0, 0, global.room_width, global.room_height), global.ultimate_colors[$ global.selected_ultimate], global.ultimate_icons[$ global.selected_ultimate], _scale)
		}
/*
I don't want to draw the circle around the player anymore
		if (is_duration_ult(ult_type)) {
			var _remaining_ratio = (game_controller.ultimate_charge[$ owner_player_id] / global.ultimate_requirement)
			var _thickness = ULT_TIMER_CIRCLE_THICKNESS + (ULT_TIMER_CIRCLE_THICKNESS * _remaining_ratio)
			// thickness / 2 because the path runs through the middle
			var _radius = global.player_body_radius - (_thickness / 2) + (_remaining_ratio * (global.bg_cicle_min_radius - global.player_body_radius))
			draw_set_color(global.ultimate_colors[$ ult_type])
			draw_arc(global.xcenter, global.ycenter, _radius, 360, 0, _thickness)
			reset_composite_color()
		}
*/
	}
}

// -------------------------------------------------------------------------------------------
// ACTIVE ULTIMATES RING
// The single place that shows which ultimates are active: one background ring (just inside the shield's),
// split across its thickness into an equal band per active ultimate (like the shield's health bands). Each band is
// a full circle in its ultimate's color whose sweep shrinks (like a pie chart) as the duration runs out, leaving the consumed part black.
// Drawn by obj_background so it sits with the other rings -- individual ultimates don't draw any of this.
// -------------------------------------------------------------------------------------------

// fixed order so sections don't shuffle around as ultimates start and end
// only time-based ultimates are shown (see is_duration_ult) -- air strike has no duration to count down
#macro ULT_RING_ORDER [ULTIMATE_SLOW, ULTIMATE_HEAL, ULTIMATE_ASSIST, ULTIMATE_TURRET, ULTIMATE_COLLATERAL, ULTIMATE_RINGS]
#macro ULT_RING_START_ANGLE 90 // sections are laid out starting from the top of the ring
#macro ULT_RING_FULL_BUFFER 0.5 // in seconds -- a section shows full for this long before it starts shrinking (covers its grow-in animation)
#macro ULT_RING_HEAD_WIDTH 3 // the white line marking where the remaining (colored) sweep meets the consumed (black) part

/**
 * Every active time-based ultimate instance (including extras), in ULT_RING_ORDER
 * @returns {Array<Id.Instance>}
 */
function get_active_ultimate_instances() {
	var _instances = []
	var _order = ULT_RING_ORDER
	for (var _i = 0; _i < array_length(_order); _i++) {
		if (!is_duration_ult(_order[_i])) {
			continue
		}
		with (global._G.ultimate_object_map[$ _order[_i]]) {
			array_push(_instances, id)
		}
	}
	return _instances
}

/**
 * How much of a time-based ultimate's duration is left
 * @param {Id.Instance} _ult
 * @param {Real} _full_buffer -- in seconds: the ratio stays at 1 for this long after the ult starts, then counts down over the rest of the duration
 * @returns {Real} [0,1]
 */
function ultimate_get_remaining_ratio(_ult, _full_buffer = 0) {
	// the lifetime alarm (alarm[0]) is started at starting_duration in ultimate_initialize
	return get_alarm_remaining_ratio(_ult, _ult.starting_duration, _full_buffer)
}

/**
 * @param {Real} _x
 * @param {Real} _y
 * @param {Struct.AnimatedSections} _sections -- persistent per drawer, so section sizes animate as ultimates start and end
 */
function draw_active_ultimates_ring(_x, _y, _sections) {
	var _ults = get_active_ultimate_instances()
	// snapshot what each section needs, so a section can keep drawing while it shrinks out after its ult is destroyed
	var _data = []
	for (var _i = 0; _i < array_length(_ults); _i++) {
		array_push(_data, {
			color: global.ultimate_colors[$ _ults[_i].ult_type],
			remaining: ultimate_get_remaining_ratio(_ults[_i], ULT_RING_FULL_BUFFER),
		})
	}
	_sections.update(_ults, _data)

	var _layout = _sections.get_layout()
	if (array_length(_layout) == 0) {
		return
	}

	// fill the ring exactly (rings are indexed from the outside in)
	var _ring_index = global.bg_number_of_circles - global.ult_ring_from_center
	var _outer_radius = get_radius_for_ring(_ring_index)
	var _inner_radius = get_radius_for_ring(_ring_index + 1)
	var _radius = (_outer_radius + _inner_radius) / 2
	var _thickness = _outer_radius - _inner_radius

	// the whole ring starts black, then each band's remaining duration is drawn over it in the ult's color
	draw_set_color(c_black)
	draw_arc(_x, _y, _radius, 360, 0, _thickness)

	// each active ult gets a full-circle band across the ring's thickness (like the shield's health bands), so every
	// countdown sweeps the whole circumference side by side with the others
	for (var _i = 0; _i < array_length(_layout); _i++) {
		var _section = _layout[_i]
		var _band_inner = _inner_radius + _section.start * _thickness
		var _band_thickness = _section.size * _thickness
		if (_band_thickness <= 0.5) {
			continue
		}
		var _band_outer = _band_inner + _band_thickness
		var _band_radius = _band_inner + _band_thickness / 2

		var _remaining_degrees = 360 * _section.data.remaining
		if (_remaining_degrees > 0.5) {
			draw_set_color(_section.data.color)
			draw_arc(_x, _y, _band_radius, _remaining_degrees, ULT_RING_START_ANGLE, _band_thickness)
		}

		// the head: a white radial line where the colored sweep meets the black. Hidden while the band is still full
		if (_section.data.remaining < 1) {
			var _head_angle = ULT_RING_START_ANGLE + _remaining_degrees
			draw_set_color(c_white)
			draw_line_width(
				_x + lengthdir_x(_band_inner, _head_angle), _y + lengthdir_y(_band_inner, _head_angle),
				_x + lengthdir_x(_band_outer, _head_angle), _y + lengthdir_y(_band_outer, _head_angle),
				ULT_RING_HEAD_WIDTH
			)
		}
	}

	// thin white lines separate the bands, same as the shield. They slide to their new spacing as bands grow in and out
	draw_set_color(c_white)
	for (var _i = 1; _i < array_length(_layout); _i++) {
		draw_arc(_x, _y, _inner_radius + _thickness * _layout[_i].start, 360, 0, 2)
	}

	reset_composite_color()
}

// TOOD: This needs to contorl more ultimate types
global._G.ultimate_object_map = {
	ULTIMATE_STRIKE: obj_ultimate_strike,
	ULTIMATE_HEAL: obj_ultimate_heal,
	ULTIMATE_SLOW: obj_ultimate_slow,
	ULTIMATE_ASSIST: obj_ultimate_assist,
	ULTIMATE_TURRET: obj_ultimate_turret,
	ULTIMATE_COLLATERAL: obj_ultimate_collateral,
	ULTIMATE_RINGS: obj_ultimate_rings
}


/**
 * @param {String} _ultimate
 * @param {Real} _level
 */
function get_ultimate_stats(_ultimate, _level) {
	var _stats = []
	var _frames_to_seconds = game_get_speed(gamespeed_fps)
	var _range
	switch (_ultimate) {
		case ULTIMATE_HEAL:
			array_push(_stats, string_concat("+", ult_heal_get_leech_amount(_level), " health per strike"))
			array_push(_stats, string_concat("Duration: ", round((ult_heal_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		case ULTIMATE_STRIKE:
			array_push(_stats, string_concat("Execute ", ult_strike_get_count(_level), " strikes on nearby targets"))
			break
		
		case ULTIMATE_SLOW:
			array_push(_stats, string_concat("Slow amount: ", round(ult_slow_get_speed_multiplier(_level) * 100), "%"))
			array_push(_stats, string_concat("Duration: ", round((ult_slow_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		case ULTIMATE_COLLATERAL:
			array_push(_stats, string_concat("Chain distance: ", round(ult_collateral_get_radius(_level))))
			array_push(_stats, string_concat("Duration: ", round((ult_collateral_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		case ULTIMATE_ASSIST:
			if (global.is_math_mode) {
				_range = ult_assist_get_range(_level)
				array_push(_stats, string_concat("Include answers range: -", round(_range[0]), " and +", _range[1]))
			} else {
				array_push(_stats, string_concat("Include words with a typo score up to ", ult_assist_get_max_mistake_score(_level)))
			}
			array_push(_stats, string_concat("Duration: ", round((ult_assist_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
			
		case ULTIMATE_RINGS:
			_range = ult_rings_get_ring_range(_level)
			array_push(_stats, string_concat("Strike nearby rings range: -", round(_range[0]), " and +", _range[1]))
			array_push(_stats, string_concat("Duration: ", round((ult_rings_get_duration(_level) / _frames_to_seconds) * 10) / 10, " seconds"))
			break
	}
	
	return array_reduce(_stats, function(_agr, _s) {
		return string_join(_agr, "\n", _s)
	}, "")
	
}
