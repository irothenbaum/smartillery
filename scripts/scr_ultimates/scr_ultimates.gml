// -------------------------------------------------------------------------------------------
// General & Shared functions
// -------------------------------------------------------------------------------------------

#macro ult_base_duration 9
#macro ult_duration_increment 3
// in frames
function ult_base_get_duration(_level) {
	return (ult_base_duration + _level * ult_duration_increment) * game_get_speed(gamespeed_fps)
}

function get_experience_needed_for_next_level(_curent_level) {
	return min(5 * _curent_level, 50)
}

// -------------------------------------------------------------------------------------------
// LEECH
// -------------------------------------------------------------------------------------------

function ult_heal_get_duration(_level) {
	return ult_base_get_duration(_level)
}

#macro leech_minimum_amount 5
#macro leech_minimum_increment 2
// in health
function ult_heal_get_leech_amount(_level) {
	return leech_minimum_amount + (_level  - 1) * leech_minimum_increment
}

// -------------------------------------------------------------------------------------------
// AIR STRIKE
// -------------------------------------------------------------------------------------------

#macro strike_minimum 4
#macro strike_increment_level_step 3
// n > 0
function ult_strike_get_count(_level) {
	// level 4 we get our first bump, then level 7, then 10
	return strike_minimum + floor((_level - 1) / strike_increment_level_step)
}

// -------------------------------------------------------------------------------------------
// TIME SLOW
// -------------------------------------------------------------------------------------------

#macro slow_base_multiplier 0.8
#macro slow_multiplier_increment 0.5
function ult_slow_get_speed_multiplier(_level) {
	return max(0.1, slow_base_multiplier - (slow_multiplier_increment * _level))
}

// in frames
function ult_slow_get_duration(_level) {
	return ult_base_get_duration(_level)
}

#macro slow_base_radius 3 // outside the fire distance of enemy2
// this is the area of effect in pixels
function ult_slow_get_radius(_level) {
	return get_radius_at_i(ult_slow_get_rings(_level))
}

// this is the area of effect in rings
function ult_slow_get_rings(_level) {
	return max(0, global.bg_number_of_circles - (slow_base_radius + _level))
}

// -------------------------------------------------------------------------------------------
// AIM ASSIST
// -------------------------------------------------------------------------------------------

function ult_assist_get_duration(_level) {
	return ult_base_get_duration(_level)
}


#macro assist_base_range 1 // (1 each way so if you guess 8, it will count 9 and 7)
function ult_assist_get_range(_level) {
	return assist_base_range + (_level-1)
}

#macro assist_base_target_count 1
#macro assist_secondary_strike_level_step 3 // every 3 levels we add another secondary target
function ult_assist_get_number_of_targets(_level) {
	return assist_base_target_count + floor((_level - 1) / assist_secondary_strike_level_step)
}

// -------------------------------------------------------------------------------------------
// COLLATERAL DAMAGE
// -------------------------------------------------------------------------------------------

function ult_collateral_get_duration(_level) {
	return ult_base_get_duration(_level)
}

#macro collateral_base_radius 50
#macro collateral_radius_increment_step 10
#macro collateral_radius_reduction 3 // how much our radius reduces by when we increase strike count 
// in pixels
function ult_collateral_get_radius(_level) {
	return collateral_base_radius + (_level - 1) * collateral_radius_increment_step
}

// -------------------------------------------------------------------------------------------
// SIMPLIFICATION
// -------------------------------------------------------------------------------------------

function ult_simplification_get_duration(_level) {
	return ult_base_get_duration(_level)
}

#macro simplification_base_multiplier 0.8 // starts of 20% easier
// this will return a number strictly between 0 and 1
function ult_simplification_get_difficulty_multiplier(_level) {
	// level 1 is 80% easier
	// level 2 is 64% easier
	// level 3 is 51% easier
	// .... etc
	return power(simplification_base_multiplier, _level)
}