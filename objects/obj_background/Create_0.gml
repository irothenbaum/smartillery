x = global.xcenter
y = global.ycenter	

idle_color = new CompositeColor(global.bg_color, 1)
no_health_color = new CompositeColor(c_black, 1)
low_health_color = new CompositeColor(#bf1d1d, 1)
low_health_min_brightness = 0.4 // how bright the low health red is at 0 health (1 = full #bf1d1d)

grid_color = c_white

// when the player's health goes up (e.g. a health orb lands), the health rings fade to green, hold, then fade back
heal_flash_color = new CompositeColor(global.ultimate_colors[$ ULTIMATE_HEAL], 1) // same green as health orbs
heal_flash_fade_in = 0.10 // in seconds
heal_flash_hold = 0.25 // in seconds
heal_flash_fade_out = 0.4 // in seconds
heal_flash_elapsed = infinity // in seconds since the flash started (infinity = not flashing)
heal_flash_amount = 0 // [0,1] how green the health rings are right now
last_player_health = undefined

function start_heal_flash() {
	// if we're already partway green, pick up the fade in from that point instead of dropping back to 0
	heal_flash_elapsed = heal_flash_fade_in * heal_flash_amount
}

function update_heal_flash() {
	heal_flash_elapsed += step_seconds()
	var _hold_end = heal_flash_fade_in + heal_flash_hold
	if (heal_flash_elapsed < heal_flash_fade_in) {
		heal_flash_amount = heal_flash_elapsed / heal_flash_fade_in
	} else if (heal_flash_elapsed < _hold_end) {
		heal_flash_amount = 1
	} else {
		heal_flash_amount = max(0, 1 - (heal_flash_elapsed - _hold_end) / heal_flash_fade_out)
	}
}

// sections of the active-ultimates ring (see draw_active_ultimates_ring), animated as ultimates start and end
ult_ring_sections = new AnimatedSections()

drawn_ring_line_alpha = array_create(global.bg_number_of_circles, 0)
drawn_ring_color = array_create(global.bg_number_of_circles, idle_color)

// we cache these computations since they never change
ring_radius = array_create(global.bg_number_of_circles, 0)
circle_precision = array_create(global.bg_number_of_circles, 0)

array_foreach(ring_radius, function(_v, _i) {
	ring_radius[_i] = get_radius_for_ring(_i)
	circle_precision[_i] = get_circle_precision_from_radius_and_degrees(ring_radius[_i], 360)
})

gradient_shadow = 0.5
drawn_skipped_rings = global.bg_number_of_circles
game_controller = get_game_controller()
booting_up = true
boot_up_time = 1 * game_get_speed(gamespeed_fps)
alarm[0] = boot_up_time

// ambient sparkle over the healthy (non-black) rings -- resized in Draw, destroyed in Clean Up (particle systems outlive their room otherwise)
glitter = create_background_glitter()



function get_ring_color(_i, _options) {
	if (_options.is_ulting_strike && _options.enemies_on_ring) {
		return new CompositeColor(global.ultimate_colors[$ ULTIMATE_STRIKE], 1)
	}
	
	var _ret_val = _i < _options.rounded_skipped_rings ? no_health_color : idle_color
	
	if (_options.player_health < global.max_health && _i >= _options.rounded_skipped_rings) {
		_ret_val = blend_composite_colors(_options.low_health_color, _ret_val, _options.player_health / global.max_health)
	}

	// heal flash only tints the rings that represent remaining health
	if (_options.heal_flash_amount > 0 && _i >= _options.rounded_skipped_rings) {
		_ret_val = blend_composite_colors(_ret_val, heal_flash_color, _options.heal_flash_amount / 3)
	}
	
	if (_options.is_ulting_rings && !is_undefined(_options.rings_ult_instance)) {
		_ret_val = blend_composite_colors(_ret_val, global.ultimate_colors[$ ULTIMATE_RINGS], _options.rings_ult_instance.recently_struck_rings[_i])
	}
	
	if (_options.enemies_on_ring > 0) {
		_ret_val = blend_composite_colors(_ret_val, c_white, _options.enemies_on_ring / 20)
	}
	
	return _ret_val	
}

function get_line_alpha_for_ring(_i, _options) {
	var _line_alpha = 0.1
	
	if(_i < _options.rounded_skipped_rings) {  
		_line_alpha = _line_alpha / 2	
	} else if (_options.rounded_skipped_rings > 0 && _i == _options.rounded_skipped_rings) {
		// make the edge of our missing health bar extra bright
		_line_alpha = 0.5
	}
	
	return _line_alpha
}

function get_fade_speed_for_ring(_i, _options) {
	var _fade_speed_multiplier = 1
	
	// TODO: could have logic in here if needed
	
	return global.fade_speed / _fade_speed_multiplier
}