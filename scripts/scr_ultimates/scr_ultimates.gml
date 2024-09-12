base_heal_rate = 0.1
heal_rate_increment = 0.05
// health per frame
function ult_heal_get_rate(_level) {
	return base_heal_rate + heal_rate_increment * _level
}

heal_base_duration = 20
heal_duration_increment = 5
// in frames
function ult_heal_get_duration(_level) {
	return (base_heal_duration + _level * heal_duration_increment) * game_get_speed(gamespeed_fps)
}

leech_minimum_amount = 10
leech_minimum_increment = 2
leech_minimum_level = 10
// in health
function ult_heal_get_leech_amount(_level) {
	if (_level < leech_minimum_level) {
		return 0
	}
	return leech_minimum_amount + (_level - leech_minimum_level) * leech_minimum_increment
}

strike_minimum = 3
strike_increment_level_step = 3
// n > 0
function ult_strike_get_count(_level) {
	return floor(strike_minimum + _level / strike_increment_level_step)
}

strike_base_radius = 50
strike_radius_increment_step = 10
strike_radius_reduction = 3
// in pixels
function ult_strike_get_radius(_level) {
	return strike_base_radius 
		+ (strike_radius_increment_step * _level) 
		// everytime we increase our strike count, we take a small step back in our radius
		- (strike_radius_reduction * (_level / strike_increment_level_step))
}

slow_base_multiplier = 0.75
function ult_slow_get_speed_multiplier(_level) {
	
}

slow_base_duration = heal_base_duration
slow_duration_increment = heal_duration_increment
// in frames
function ult_slow_get_duration(_level) {
	return ult_heal_get_duration(_level)
}

slow_base_radius = 4 // outside the fire distance of enemy2
// this is the area of effect in pixels
function ult_slow_get_radius(_level) {
	return get_radius_at_i(slow_base_radius + _level)
}