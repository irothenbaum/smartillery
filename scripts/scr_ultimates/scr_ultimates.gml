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
	return global.selected_ultimate[$ _player_id]
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

		if (is_duration_ult(ult_type)) {
			game_controller.ultimate_charge[$ owner_player_id] = max(0, global.ultimate_requirement * alarm[0] / starting_duration)
		} else {
			game_controller.ultimate_charge[$ owner_player_id] = lerp(0, game_controller.ultimate_charge, global.fade_speed)
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
		if (ult_overlay > 0) {
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
