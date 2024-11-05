#macro base_heal_rate 0.02
#macro heal_rate_increment 0.01
// health per frame
function ult_heal_get_rate(_level) {
	return base_heal_rate + heal_rate_increment * _level
}

#macro heal_base_duration 9
#macro heal_duration_increment 3
// in frames
function ult_heal_get_duration(_level) {
	return (heal_base_duration + _level * heal_duration_increment) * game_get_speed(gamespeed_fps)
}

#macro leech_minimum_amount 5
#macro leech_minimum_increment 1
#macro leech_minimum_level 5
// in health
function ult_heal_get_leech_amount(_level) {
	if (_level < leech_minimum_level) {
		return 0
	}
	return leech_minimum_amount + (_level - leech_minimum_level) * leech_minimum_increment
}

#macro strike_minimum 4
#macro strike_increment_level_step 3
// n > 0
function ult_strike_get_count(_level) {
	// level 4 we get our first bump, then level 7
	return floor(strike_minimum + ((_level - 1) / strike_increment_level_step))
}

#macro strike_base_radius 50
#macro strike_radius_increment_step 10
#macro strike_radius_reduction 3 // how much our radius reduces by when we increase strike count 
// in pixels
function ult_strike_get_radius(_level) {
	return strike_base_radius 
		+ (strike_radius_increment_step * _level) 
		// everytime we increase our strike count, we take a small step back in our radius
		- (strike_radius_reduction * (ult_strike_get_count(_level) - strike_minimum))
}

#macro slow_base_multiplier 0.8
#macro slow_multiplier_increment 0.5
function ult_slow_get_speed_multiplier(_level) {
	return max(0.1, slow_base_multiplier - (slow_multiplier_increment * _level))
}

// in frames
function ult_slow_get_duration(_level) {
	return ult_heal_get_duration(_level)
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

// ----------------------------------------------------

function get_experience_needed_for_next_level(_curent_level) {
	return min(5 * _curent_level, 50)
}